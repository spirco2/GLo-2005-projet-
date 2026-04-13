"""
IronTrack — routes/admin.py
Page d'analyse avancée : requêtes complexes (jointures, sous-requêtes, agrégations).
Démonstration GLO-2005.
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash
from db import get_db

bp = Blueprint('admin', __name__)


@bp.route('/analyse')
def analyse():
    if not session.get('user_id'):
        flash('Connectez-vous pour accéder à cette page.', 'error')
        return redirect(url_for('acceuil.index'))

    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # ── 1. Classement par volume total (agrégation + jointure 3 tables) ──
        cursor.execute("""
            SELECT u.pseudo,
                   ROUND(SUM(sl.poids * sl.reps), 0) AS volume_total_kg
            FROM serie_log sl
            JOIN seance       s ON sl.id_seance = s.id_seance
            JOIN Utilisateurs u ON s.id_user    = u.id
            GROUP BY u.pseudo
            ORDER BY volume_total_kg DESC
            LIMIT 10
        """)
        classement_volume = cursor.fetchall()

        # ── 2. Top exercices les plus lourds (MAX + jointure 4 tables) ──
        cursor.execute("""
            SELECT u.pseudo,
                   e.nom AS exercice,
                   MAX(sl.poids) AS poids_max_kg
            FROM serie_log    sl
            JOIN seance        s ON sl.id_seance = s.id_seance
            JOIN Utilisateurs  u ON s.id_user    = u.id
            JOIN exercice      e ON sl.id_ex     = e.id_ex
            WHERE sl.type_serie <> 'warmup' AND sl.poids > 0
            GROUP BY u.pseudo, e.nom
            ORDER BY poids_max_kg DESC
            LIMIT 10
        """)
        top_exercices = cursor.fetchall()

        # ── 3. Muscles les plus travaillés (agrégation + jointure 3 tables) ──
        cursor.execute("""
            SELECT m.nom_muscle,
                   m.categorie,
                   COUNT(sl.id) AS nb_series
            FROM serie_log sl
            JOIN cibler    c ON sl.id_ex    = c.id_ex
            JOIN Muscles   m ON c.id_muscle = m.id_muscle
            GROUP BY m.id_muscle
            ORDER BY nb_series DESC
            LIMIT 10
        """)
        muscles_populaires = cursor.fetchall()

        # ── 4. Utilisateurs sans séance (sous-requête NOT IN) ──
        cursor.execute("""
            SELECT pseudo, email
            FROM Utilisateurs
            WHERE id NOT IN (
                SELECT DISTINCT id_user FROM seance
            )
        """)
        users_inactifs = cursor.fetchall()

        # ── 5. Records personnels récents (jointure 3 tables + tri) ──
        cursor.execute("""
            SELECT u.pseudo,
                   e.nom AS exercice,
                   rp.poids_max AS record_kg,
                   rp.date_record
            FROM record_personnel rp
            JOIN Utilisateurs u ON rp.id_utilisateur = u.id
            JOIN exercice     e ON rp.id_ex          = e.id_ex
            ORDER BY rp.date_record DESC
            LIMIT 10
        """)
        records_recents = cursor.fetchall()

        # ── 6. Nombre de séances par programme (sous-requête corrélée) ──
        cursor.execute("""
            SELECT p.nom_programme,
                   (SELECT COUNT(*) FROM seance s WHERE s.id_programme = p.id_programme) AS nb_seances
            FROM programme p
            ORDER BY nb_seances DESC
        """)
        seances_par_prog = cursor.fetchall()

        return render_template('admin.html',
                               classement_volume=classement_volume,
                               top_exercices=top_exercices,
                               muscles_populaires=muscles_populaires,
                               users_inactifs=users_inactifs,
                               records_recents=records_recents,
                               seances_par_prog=seances_par_prog)
    finally:
        cursor.close()
        conn.close()