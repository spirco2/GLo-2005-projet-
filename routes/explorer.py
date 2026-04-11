"""
IronTrack — routes/explorer.py
Page Explorer : consultation des programmes prédéfinis et catalogue d'exercices.
Vocation informationnelle — aucune action d'écriture.
Les muscles sont récupérés individuellement depuis la table Muscles (pas les catégories).
"""

from flask import Blueprint, render_template
from db import get_db

bp = Blueprint('explorer', __name__)


@bp.route('/explorer')
def explorer():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # ── Programmes prédéfinis avec leurs exercices ────────
        cursor.execute("""
            SELECT p.id_programme, p.nom_programme, p.description_p,
                   p.duree_semaines,
                   COUNT(c.id_ex) AS nb_exercices
            FROM programme p
            LEFT JOIN composer c ON p.id_programme = c.id_programme
            WHERE p.id_createur IS NULL
            GROUP BY p.id_programme
            HAVING nb_exercices > 0
            ORDER BY p.id_programme
        """)
        programmes = cursor.fetchall()

        for prog in programmes:
            cursor.execute("""
                SELECT e.nom, e.equipement, e.difficulte
                FROM composer c
                JOIN exercice e ON c.id_ex = e.id_ex
                WHERE c.id_programme = %s
                ORDER BY c.ordre
            """, (prog['id_programme'],))
            prog['exercices'] = cursor.fetchall()

        # ── Tous les muscles individuels (pour les chips) ─────
        cursor.execute("""
            SELECT id_muscle, nom_muscle, categorie
            FROM Muscles
            ORDER BY categorie, nom_muscle
        """)
        muscles = cursor.fetchall()

        # ── Catalogue complet d'exercices ─────────────────────
        # Séparateur || pour un split exact côté JS
        cursor.execute("""
            SELECT e.id_ex, e.nom, e.description, e.equipement, e.difficulte,
                   GROUP_CONCAT(m.nom_muscle ORDER BY m.nom_muscle SEPARATOR '||') AS muscles_strict,
                   GROUP_CONCAT(m.nom_muscle ORDER BY m.nom_muscle SEPARATOR ', ') AS muscles_display
            FROM exercice e
            LEFT JOIN cibler  c ON e.id_ex     = c.id_ex
            LEFT JOIN Muscles m ON c.id_muscle = m.id_muscle
            GROUP BY e.id_ex
            ORDER BY e.nom
        """)
        exercices = cursor.fetchall()

        return render_template('explorer.html',
                               programmes=programmes,
                               exercices=exercices,
                               muscles=muscles)
    finally:
        cursor.close()
        conn.close()