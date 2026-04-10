from flask import Blueprint, render_template, request, session, redirect, url_for, flash
from db import get_connection

programmes_bp = Blueprint('programmes', __name__)

@programmes_bp.route('/programmes')
def programmes():
    if not session.get('user_id'):
        return redirect(url_for('accueil.connexion'))
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        # Programmes de l'utilisateur
        cursor.execute("""
            SELECT * FROM programme
            WHERE id_user = %s
        """, (session['user_id'],))
        mes_progs = cursor.fetchall()

        # Tous les exercices pour la bibliothèque
        cursor.execute("SELECT * FROM exercice ORDER BY nom")
        exercices = cursor.fetchall()

        conn.close()
        return render_template('mes_programmes.html',
            programmes=mes_progs,
            exercices=exercices,
            active_page='programmes'
        )
    except Exception as e:
        flash('Erreur lors du chargement.', 'error')
        return redirect(url_for('accueil.accueil'))

@programmes_bp.route('/programmes/creer', methods=['POST'])
def creer_programme():
    if not session.get('user_id'):
        return redirect(url_for('accueil.connexion'))
    try:
        nom  = request.form.get('nom', '').strip()
        desc = request.form.get('desc', '').strip()

        if not nom:
            flash('Le nom est obligatoire.', 'error')
            return redirect(url_for('programmes.programmes'))

        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO programme (nom_programme, description_p, id_user)
            VALUES (%s, %s, %s)
        """, (nom, desc, session['user_id']))
        conn.commit()
        conn.close()
        flash('Programme créé !', 'success')
    except Exception as e:
        flash('Erreur lors de la création.', 'error')
    return redirect(url_for('programmes.programmes'))

@programmes_bp.route('/seance/terminer', methods=['POST'])
def terminer_seance():
    if not session.get('user_id'):
        return redirect(url_for('accueil.connexion'))
    try:
        data = request.get_json()
        prog_id    = data.get('prog_id')
        series     = data.get('series', [])
        date_debut = data.get('date_debut')
        date_fin   = data.get('date_fin')

        conn = get_connection()
        cursor = conn.cursor()

        # Insérer la séance
        cursor.execute("""
            INSERT INTO seance (id_user, id_programme, date_debut, date_fin)
            VALUES (%s, %s, %s, %s)
        """, (session['user_id'], prog_id, date_debut, date_fin))
        id_seance = cursor.lastrowid

        # Insérer les séries — le trigger update_pr s'exécute automatiquement
        for s in series:
            cursor.execute("""
                INSERT INTO serie_log (id_seance, id_ex, poids, reps, rpe, type_serie)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (id_seance, s['id_ex'], s['poids'], s['reps'], s.get('rpe'), s['type']))

        # Calculer le volume total via la procédure
        cursor.callproc('calculer_volume_seance', [id_seance])
        conn.commit()
        conn.close()
        return {'success': True}
    except Exception as e:
        return {'success': False, 'error': str(e)}, 500