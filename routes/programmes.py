"""
IronTrack — routes/programmes.py
Page « Mes Programmes » + API CRUD programmes + API POST séance.
Utilise la table composer pour lier programme ↔ exercice.
"""

from flask import Blueprint, render_template, request, jsonify, session
from db import get_db
from datetime import datetime

bp = Blueprint('programmes', __name__)


@bp.route('/programmes')
def mes_programmes():
    """Page mes_programmes.html avec données injectées via tojson."""
    if not session.get('user_id'):
        return render_template('mes_programmes.html', exercices=[], programmes=[])

    user_id = session['user_id']
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # ── Exercices avec muscles ────────────────────────────
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

        # ── Programmes (prédéfinis + persos de l'utilisateur) ─
        cursor.execute("""
            SELECT p.id_programme AS id,
                   p.nom_programme AS nom,
                   p.description_p AS `desc`,
                   p.duree_semaines,
                   p.id_createur,
                   GROUP_CONCAT(c.id_ex ORDER BY c.ordre SEPARATOR ',') AS exo_ids_raw
            FROM programme p
            LEFT JOIN composer c ON p.id_programme = c.id_programme
            WHERE p.id_createur IS NULL OR p.id_createur = %s
            GROUP BY p.id_programme
            ORDER BY p.id_createur IS NOT NULL DESC, p.id_programme
        """, (user_id,))
        prog_rows = cursor.fetchall()

        programmes = []
        for p in prog_rows:
            exo_ids = []
            if p['exo_ids_raw']:
                exo_ids = [int(x) for x in p['exo_ids_raw'].split(',')]
            programmes.append({
                'id':      p['id'],
                'nom':     p['nom'],
                'desc':    p['desc'] or '',
                'custom':  p['id_createur'] is not None,
                'exoIds':  exo_ids
            })

        return render_template('mes_programmes.html',
                               exercices=exercices,
                               programmes=programmes)
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/programme', methods=['POST'])
def creer_programme():
    """Crée un programme personnel lié à l'utilisateur."""
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    data = request.get_json()
    nom = data.get('nom', '').strip()
    desc = data.get('desc', '').strip()

    if not nom:
        return jsonify({'error': 'Le nom est requis'}), 400

    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO programme (nom_programme, description_p, duree_semaines, id_createur)
            VALUES (%s, %s, 0, %s)
        """, (nom, desc, user_id))
        prog_id = cursor.lastrowid
        conn.commit()
        return jsonify({'success': True, 'id': prog_id}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/programme/<int:prog_id>', methods=['PUT'])
def modifier_programme(prog_id):
    """Renomme un programme personnel."""
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    data = request.get_json()
    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            UPDATE programme SET nom_programme = %s, description_p = %s
            WHERE id_programme = %s AND id_createur = %s
        """, (data.get('nom', ''), data.get('desc', ''), prog_id, user_id))
        conn.commit()
        return jsonify({'success': True})
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/programme/<int:prog_id>', methods=['DELETE'])
def supprimer_programme(prog_id):
    """Supprime un programme personnel."""
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            DELETE FROM programme
            WHERE id_programme = %s AND id_createur = %s
        """, (prog_id, user_id))
        conn.commit()
        return jsonify({'success': True})
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/programme/<int:prog_id>/exercices', methods=['POST'])
def modifier_exercices_programme(prog_id):
    """
    Met à jour les exercices d'un programme personnel.
    JSON attendu : { "exoIds": [10, 75, 56, ...] }
    """
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    data = request.get_json()
    exo_ids = data.get('exoIds', [])

    conn = get_db()
    cursor = conn.cursor()
    try:
        # Vérifier que le programme appartient à l'utilisateur
        cursor.execute("""
            SELECT id_programme FROM programme
            WHERE id_programme = %s AND id_createur = %s
        """, (prog_id, user_id))
        if not cursor.fetchone():
            return jsonify({'error': 'Programme introuvable ou non autorisé'}), 403

        # Supprimer les anciens liens
        cursor.execute("DELETE FROM composer WHERE id_programme = %s", (prog_id,))

        # Insérer les nouveaux
        for ordre, id_ex in enumerate(exo_ids, start=1):
            cursor.execute("""
                INSERT INTO composer (id_programme, id_ex, ordre)
                VALUES (%s, %s, %s)
            """, (prog_id, id_ex, ordre))

        conn.commit()
        return jsonify({'success': True})
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/seance', methods=['POST'])
def enregistrer_seance():
    """
    Enregistre une séance complète.
    Durée calculée côté serveur via timedelta (source de vérité).

    JSON attendu :
    {
      "id_programme": 1,
      "date_debut": "2026-01-05T10:00:00",
      "date_fin":   "2026-01-05T11:15:00",
      "series": [
        {"id_ex": 10, "poids": 60.0, "reps": 10, "rpe": 7.0, "type_serie": "normale"},
        ...
      ]
    }
    """
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'error': 'Non authentifié'}), 401

    data = request.get_json()
    if not data:
        return jsonify({'error': 'JSON invalide'}), 400

    id_programme = data.get('id_programme')
    date_debut   = data.get('date_debut')
    date_fin     = data.get('date_fin')
    series       = data.get('series', [])

    if not id_programme or not series:
        return jsonify({'error': 'id_programme et series sont requis'}), 400

    # ── Calcul de la durée côté serveur ─────────────────────
    try:
        dt_debut = datetime.fromisoformat(date_debut)
        dt_fin   = datetime.fromisoformat(date_fin)
        delta    = dt_fin - dt_debut
        total_seconds = int(delta.total_seconds())
        h = total_seconds // 3600
        m = (total_seconds % 3600) // 60
        s = total_seconds % 60
        duree_str = f"{h:02d}:{m:02d}:{s:02d}"
    except (ValueError, TypeError):
        duree_str = "00:00:00"

    # ── Transaction ─────────────────────────────────────────
    conn = get_db()
    cursor = conn.cursor()
    try:
        # 1. Insérer la séance
        cursor.execute("""
            INSERT INTO seance (id_user, id_programme, date_debut, date_fin, duree, volume_total)
            VALUES (%s, %s, %s, %s, %s, 0)
        """, (user_id, id_programme, date_debut, date_fin, duree_str))

        id_seance = cursor.lastrowid

        # 2. Insérer chaque série (triggers update_pr + calcul_assiduite)
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

        # 3. Calcul du volume AVANT le commit (atomicité)
        cursor.callproc('calculer_volume_seance', (id_seance,))

        # 4. Commit global
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