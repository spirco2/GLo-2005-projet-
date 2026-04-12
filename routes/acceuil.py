"""
IronTrack — routes/acceuil.py
Page d'accueil épurée : Hero + IMC + Connexion/Inscription.
Sécurité : werkzeug.security (PBKDF2 + salt) au lieu de hashlib.
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from werkzeug.security import generate_password_hash, check_password_hash
from db import get_db

bp = Blueprint('acceuil', __name__)


@bp.route('/')
def index():
    return render_template('index.html')


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

    if len(mdp) < 8:
        flash('Le mot de passe doit contenir au moins 8 caractères.', 'error')
        return redirect(url_for('acceuil.index') + '#inscription')

    # Hash sécurisé avec PBKDF2 + salt aléatoire
    mdp_hash = generate_password_hash(mdp)

    conn = get_db()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Utilisateurs (pseudo, email, mdp_hash, date, taille, poids, sexe)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (pseudo, email, mdp_hash, date_naissance, taille, poids, sexe))

        user_id = cursor.lastrowid

        # Initialiser statistiques d'assiduité
        cursor.execute("""
            INSERT INTO statistiques_utilisateurs (id_user, semaines_consecutives)
            VALUES (%s, 0)
        """, (user_id,))

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
            flash('Erreur lors de l\'inscription.', 'error')
        return redirect(url_for('acceuil.index') + '#inscription')
    finally:
        cursor.close()
        conn.close()


@bp.route('/connexion', methods=['POST'])
def connexion():
    email = request.form.get('email', '').strip()
    mdp = request.form.get('mdp', '')

    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # Récupérer le hash stocké pour cet email
        cursor.execute("""
            SELECT id, pseudo, mdp_hash FROM Utilisateurs
            WHERE email = %s
        """, (email,))
        user = cursor.fetchone()

        # Vérification sécurisée avec check_password_hash
        if user and check_password_hash(user['mdp_hash'], mdp):
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