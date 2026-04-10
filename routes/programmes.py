"""
IronTrack — routes/programmes.py
Page « Mes Programmes » + API POST pour enregistrer une séance.
"""

from flask import Blueprint, render_template, request, jsonify, session
from db import get_db
from datetime import datetime

bp = Blueprint('programmes', __name__)


@bp.route('/programmes')
def mes_programmes():
    """
    Affiche la page mes_programmes.html avec les exercices et programmes
    injectés en Jinja2 via le filtre tojson.
    """
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # ── Exercices avec leurs muscles ──────────────────────────
        cursor.execute("""
            SELECT e.id_ex   AS id,
                   e.nom,
                   e.equipement AS eq,
                   e.difficulte AS diff,
                   GROUP_CONCAT(m.nom_muscle ORDER BY m.nom_muscle SEPARATOR '||') AS muscles_raw
            FROM exercice e
            LEFT JOIN cibler  c ON e.id_ex     = c.id_ex
            LEFT JOIN Muscles m ON c.id_muscle = m.id_muscle
            GROUP BY e.id_ex
            ORDER BY e.id_ex
        """)
        rows = cursor.fetchall()

        exercices = []
        for r in rows:
            exercices.append({
                'id':      r['id'],
                'nom':     r['nom'],
                'eq':      r['eq'] or 'Aucun',
                'diff':    r['diff'] or 'Débutant',
                'muscles': r['muscles_raw'].split('||') if r['muscles_raw'] else []
            })

        # ── Programmes du catalogue ──────────────────────────────
        cursor.execute("""
            SELECT id_programme AS id,
                   nom_programme AS nom,
                   description_p AS `desc`,
                   duree_semaines
            FROM programme
            ORDER BY id_programme
        """)
        programmes_db = cursor.fetchall()

        # Transformer en format attendu par le JS front-end
        programmes = []
        for p in programmes_db:
            programmes.append({
                'id':      p['id'],
                'nom':     p['nom'],
                'desc':    p['desc'] or '',
                'custom':  False,
                'exoIds':  []
            })

        return render_template('mes_programmes.html',
                               exercices=exercices,
                               programmes=programmes)
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/seance', methods=['POST'])
def enregistrer_seance():
    """
    API POST — Enregistre une séance complète.

    JSON attendu :
    {
      "id_programme": 1,
      "date_debut": "2026-01-05T10:00:00",
      "date_fin":   "2026-01-05T11:15:00",
      "duree":      "01:15:00",
      "series": [
        {"id_ex": 10, "poids": 60.0, "reps": 10, "rpe": 7.0, "type_serie": "normale"},
        ...
      ]
    }

    Flux transactionnel :
      1. INSERT seance          → récupérer id_seance
      2. INSERT serie_log × N   → le trigger update_pr se déclenche à chaque INSERT
      3. CALL calculer_volume_seance(id_seance)  → AVANT le commit
      4. COMMIT  (ou ROLLBACK si erreur)
    """

    # ── Vérification session ────────────────────────────────────
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    # ── Validation du payload ───────────────────────────────────
    data = request.get_json()
    if not data:
        return jsonify({'error': 'JSON invalide'}), 400

    id_programme = data.get('id_programme')
    date_debut   = data.get('date_debut')
    date_fin     = data.get('date_fin')
    duree        = data.get('duree')
    series       = data.get('series', [])

    if not id_programme or not series:
        return jsonify({'error': 'id_programme et series sont requis'}), 400

    # ── Transaction ─────────────────────────────────────────────
    conn = get_db()
    cursor = conn.cursor()
    try:
        # 1. Insérer la séance
        cursor.execute("""
            INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total)
            VALUES (%s, %s, %s, %s, %s, 0)
        """, (user_id, id_programme, date_debut, date_fin, duree))

        id_seance = cursor.lastrowid

        # 2. Insérer chaque série (le trigger update_pr se déclenche automatiquement)
        for s in series:
            id_ex      = s.get('id_ex')
            poids      = float(s.get('poids', 0))
            reps       = int(s.get('reps', 0))
            rpe        = float(s.get('rpe')) if s.get('rpe') else None
            type_serie = s.get('type_serie', 'normale')

            if not id_ex or reps <= 0:
                conn.rollback()
                return jsonify({'error': f'Série invalide : id_ex={id_ex}, reps={reps}'}), 400

            cursor.execute("""
                INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (id_seance, id_ex, poids, reps, rpe, type_serie))

        # 3. Calculer le volume AVANT le commit (atomicité)
        cursor.callproc('calculer_volume_seance', (id_seance,))

        # 4. Commit global — si on arrive ici, tout est OK
        conn.commit()

        return jsonify({
            'success': True,
            'id_seance': id_seance,
            'message': 'Séance enregistrée avec succès'
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({'error': f'Erreur serveur : {str(e)}'}), 500
    finally:
        cursor.close()
        conn.close()