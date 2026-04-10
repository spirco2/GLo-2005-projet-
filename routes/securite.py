"""
IronTrack — routes/securite.py
Gestion du profil, mot de passe et suppression de compte.
Sécurité : werkzeug.security (PBKDF2 + salt).
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from werkzeug.security import generate_password_hash, check_password_hash
from db import get_db

bp = Blueprint('securite', __name__)


@bp.route('/securite', methods=['GET', 'POST'])
def compte():
    if not session.get('user_id'):
        flash('Connectez-vous pour accéder à cette page.', 'error')
        return redirect(url_for('acceuil.index'))

    user_id = session['user_id']

    if request.method == 'POST':
        action = request.form.get('action')

        conn = get_db()
        cursor = conn.cursor(dictionary=True)
        try:
            if action == 'update_profile':
                pseudo = request.form.get('username', '').strip()
                sexe = request.form.get('sex', '')
                date_naissance = request.form.get('birthdate', '')
                taille = request.form.get('taille', type=int)
                poids = request.form.get('poids', type=float)

                cursor.execute("""
                    UPDATE Utilisateurs
                    SET pseudo = %s, sexe = %s, date = %s,
                        taille = %s, poids = %s
                    WHERE id = %s
                """, (pseudo, sexe, date_naissance, taille, poids, user_id))

                # Recalculer l'IMC si taille/poids modifiés
                if taille and poids:
                    cursor.callproc('imc_de_utilisateur', (user_id,))

                conn.commit()
                session['pseudo'] = pseudo
                flash('Profil mis à jour.', 'success')

            elif action == 'update_password':
                current_pw = request.form.get('current_password', '')
                new_pw = request.form.get('new_password', '')
                confirm_pw = request.form.get('confirm_password', '')

                if new_pw != confirm_pw:
                    flash('Les mots de passe ne correspondent pas.', 'error')
                    return redirect(url_for('securite.compte'))

                if len(new_pw) < 8:
                    flash('Le mot de passe doit contenir au moins 8 caractères.', 'error')
                    return redirect(url_for('securite.compte'))

                # Vérifier le mot de passe actuel avec check_password_hash
                cursor.execute("""
                    SELECT mdp_hash FROM Utilisateurs WHERE id = %s
                """, (user_id,))
                row = cursor.fetchone()

                if not row or not check_password_hash(row['mdp_hash'], current_pw):
                    flash('Mot de passe actuel incorrect.', 'error')
                    return redirect(url_for('securite.compte'))

                new_hash = generate_password_hash(new_pw)
                cursor.execute("""
                    UPDATE Utilisateurs SET mdp_hash = %s WHERE id = %s
                """, (new_hash, user_id))
                conn.commit()
                flash('Mot de passe mis à jour.', 'success')

            elif action == 'delete_account':
                cursor.execute("DELETE FROM Utilisateurs WHERE id = %s", (user_id,))
                conn.commit()
                session.clear()
                flash('Compte supprimé.', 'success')
                return redirect(url_for('acceuil.index'))

        except Exception:
            conn.rollback()
            flash('Erreur lors de la mise à jour.', 'error')
        finally:
            cursor.close()
            conn.close()

        return redirect(url_for('securite.compte'))

    # GET — charger les données du profil
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT pseudo, email, date, taille, poids, sexe, imc
            FROM Utilisateurs WHERE id = %s
        """, (user_id,))
        user = cursor.fetchone()
        return render_template('securite.html', user=user)
    finally:
        cursor.close()
        conn.close()