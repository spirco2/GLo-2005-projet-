"""
IronTrack — routes/suivi.py
Page de statistiques et suivi.
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash
from db import get_db
from datetime import datetime, timedelta
import calendar

bp = Blueprint('suivi', __name__)


@bp.route('/stats')
def statistiques():
    if not session.get('user_id'):
        flash('Connectez-vous pour voir vos statistiques.', 'error')
        return redirect(url_for('acceuil.index'))

    user_id = session['user_id']
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # ── Infos utilisateur ──────────────────────────────
        cursor.execute("""
            SELECT pseudo, email, taille, poids
            FROM Utilisateurs WHERE id = %s
        """, (user_id,))
        user = cursor.fetchone()

        # ── Totaux ─────────────────────────────────────────
        cursor.execute("""
            SELECT COUNT(*)              AS nb_seances,
                   COALESCE(SUM(volume_total), 0) AS volume_total,
                   COALESCE(SUM(TIME_TO_SEC(duree)), 0) AS temps_total_sec
            FROM seance
            WHERE id_user = %s
        """, (user_id,))
        totaux = cursor.fetchone()

        # ── Semaines consécutives ──────────────────────────
        cursor.execute("""
            SELECT semaines_consecutives
            FROM statistiques_utilisateurs
            WHERE id_user = %s
        """, (user_id,))
        streak_row = cursor.fetchone()
        streak = streak_row['semaines_consecutives'] if streak_row else 0

        # ── Données hebdomadaires (12 dernières semaines) ──
        cursor.execute("""
            SELECT YEARWEEK(date_debut, 1)        AS yw,
                   MIN(DATE(date_debut))           AS label_date,
                   SUM(TIME_TO_SEC(duree)) / 60    AS minutes
            FROM seance
            WHERE id_user = %s
              AND date_debut >= DATE_SUB(NOW(), INTERVAL 12 WEEK)
            GROUP BY YEARWEEK(date_debut, 1)
            ORDER BY yw
        """, (user_id,))
        weekly_raw = cursor.fetchall()

        max_min = max((w['minutes'] for w in weekly_raw), default=1) or 1
        weekly_data = []
        for w in weekly_raw:
            pct = int((w['minutes'] / max_min) * 100)
            label = w['label_date'].strftime('%d %b') if w['label_date'] else ''
            weekly_data.append({
                'label': label,
                'minutes': int(w['minutes']),
                'pct': pct
            })

        # ── Séances récentes ───────────────────────────────
        cursor.execute("""
            SELECT s.id_seance,
                   p.nom_programme AS name,
                   DATE_FORMAT(s.date_debut, '%%d %%b') AS date,
                   COUNT(DISTINCT sl.id_ex) AS nb_exercises,
                   CONCAT(MINUTE(s.duree) + HOUR(s.duree)*60, ' min') AS duration
            FROM seance s
            JOIN programme p ON s.id_programme = p.id_programme
            LEFT JOIN serie_log sl ON s.id_seance = sl.id_seance
            WHERE s.id_user = %s
            GROUP BY s.id_seance
            ORDER BY s.date_debut DESC
            LIMIT 5
        """, (user_id,))
        recent_workouts = cursor.fetchall()

        # ── Calendrier du mois courant ─────────────────────
        today = datetime.now()
        cursor.execute("""
            SELECT DAY(date_debut) AS jour
            FROM seance
            WHERE id_user = %s
              AND MONTH(date_debut) = %s
              AND YEAR(date_debut) = %s
        """, (user_id, today.month, today.year))
        jours_seance = [r['jour'] for r in cursor.fetchall()]

        stats = {
            'volume_total':   int(totaux['volume_total']),
            'nb_seances':     totaux['nb_seances'],
            'temps_total_min': int(totaux['temps_total_sec'] / 60),
            'streak_semaines': streak,
            'weekly_data':     weekly_data,
            'recent_workouts': recent_workouts,
            'jours_seance':    jours_seance,
        }

        return render_template('statistique.html', user=user, stats=stats)
    finally:
        cursor.close()
        conn.close()