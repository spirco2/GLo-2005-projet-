"""
IronTrack — routes/acceuil.py
Page d'accueil : héro, calculateur IMC, muscles, exercices, programmes, inscription.
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from db import get_db
import hashlib

bp = Blueprint('acceuil', __name__)


@bp.route('/')
def index():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # Muscles groupés par catégorie
        cursor.execute("""
            SELECT m.categorie, m.nom_muscle,
                   COUNT(c.id_ex) AS nb_exercices
            FROM Muscles m
            LEFT JOIN cibler c ON m.id_muscle = c.id_muscle
            GROUP BY m.id_muscle
            ORDER BY m.categorie, m.nom_muscle
        """)
        muscles_raw = cursor.fetchall()

        # Regrouper par catégorie
        categories = {}
        for row in muscles_raw:
            cat = row['categorie']
            if cat not in categories:
                categories[cat] = {'noms': [], 'nb_total': 0}
            categories[cat]['noms'].append(row['nom_muscle'])
            categories[cat]['nb_total'] += row['nb_exercices']

        # Exercices (échantillon pour la page d'accueil)
        cursor.execute("""
            SELECT e.id_ex, e.nom, e.description, e.equipement, e.difficulte,
                   GROUP_CONCAT(m.categorie SEPARATOR ' · ') AS muscles
            FROM exercice e
            LEFT JOIN cibler c ON e.id_ex = c.id_ex
            LEFT JOIN Muscles m ON c.id_muscle = m.id_muscle
            GROUP BY e.id_ex
            ORDER BY RAND()
            LIMIT 8
        """)
        exercices = cursor.fetchall()

        # Programmes
        cursor.execute("SELECT * FROM programme ORDER BY id_programme LIMIT 6")
        programmes = cursor.fetchall()

        return render_template('index.html',
                               categories=categories,
                               exercices=exercices,
                               programmes=programmes,
                               user=session.get('user_id'))
    finally:
        cursor.close()
        conn.close()


@bp.route('/inscription', methods=['POST'])
def inscription():
    pseudo = request.form.get('pseudo', '').strip()
    email = request.form.get('email', '').strip()
    mdp = request.form.get('mdp', '')
    date_naissance = request.form.get('date_naissance', '')
    taille = request.form.get('taille', type=int)
    poids = request.form.get('poids', type=float)
    sexe = request.form.get('sexe', '')

    if not all([pseudo, email, mdp, date_naissance, taille, poids, sexe]):
        flash('Tous les champs sont obligatoires.', 'error')
        return redirect(url_for('acceuil.index') + '#inscription')

    mdp_hash = hashlib.sha256(mdp.encode()).hexdigest()[:16]

    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Utilisateurs (pseudo, email, mdp_hash, date, taille, poids, sexe)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (pseudo, email, mdp_hash, date_naissance, taille, poids, sexe))

        user_id = cursor.lastrowid
        conn.commit()

        # Initialiser les statistiques d'assiduité
        cursor.execute("""
            INSERT INTO statistiques_utilisateurs (id_user, semaines_consecutives)
            VALUES (%s, 0)
        """, (user_id,))
        conn.commit()

        # Calculer l'IMC via la procédure stockée
        cursor.callproc('imc_de_utilisateur', (user_id,))
        conn.commit()

        session['user_id'] = user_id
        session['pseudo'] = pseudo
        flash('Compte créé avec succès !', 'success')
        return redirect(url_for('acceuil.index'))

    except Exception as e:
        conn.rollback()
        if 'Duplicate' in str(e):
            flash('Ce pseudo ou cet email est déjà utilisé.', 'error')
        else:
            flash(f'Erreur lors de l\'inscription.', 'error')
        return redirect(url_for('acceuil.index') + '#inscription')
    finally:
        cursor.close()
        conn.close()


@bp.route('/connexion', methods=['POST'])
def connexion():
    email = request.form.get('email', '').strip()
    mdp = request.form.get('mdp', '')
    mdp_hash = hashlib.sha256(mdp.encode()).hexdigest()[:16]

    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT id, pseudo FROM Utilisateurs
            WHERE email = %s AND mdp_hash = %s
        """, (email, mdp_hash))
        user = cursor.fetchone()

        if user:
            session['user_id'] = user['id']
            session['pseudo'] = user['pseudo']
            flash('Connexion réussie !', 'success')
        else:
            flash('Email ou mot de passe incorrect.', 'error')

        return redirect(url_for('acceuil.index'))
    finally:
        cursor.close()
        conn.close()


@bp.route('/deconnexion')
def deconnexion():
    session.clear()
    flash('Déconnexion réussie.', 'success')
    return redirect(url_for('acceuil.index'))