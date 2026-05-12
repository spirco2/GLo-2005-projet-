"""
IronTrack — db.py
Connexion MySQL brute via mysql.connector (pas d'ORM).
"""

import os
import mysql.connector
from mysql.connector import pooling
from dotenv import load_dotenv

# Charger le .env
load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME'),
    'port': int(os.getenv('DB_PORT', 3306)),
    'charset': 'utf8mb4',
    'autocommit': False,
}

_pool = pooling.MySQLConnectionPool(
    pool_name='irontrack_pool',
    pool_size=5,
    **DB_CONFIG
)

def get_db():
    """Retourne une connexion depuis le pool."""
    return _pool.get_connection()


# ========== FONCTIONS UTILISATEUR ==========

def get_user_info(user_id):
    """Récupère les infos d'un utilisateur (SANS le mot de passe)."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT id, pseudo, email, date, taille, poids, sexe, imc
            FROM Utilisateurs WHERE id = %s
        """, (user_id,))
        user = cursor.fetchone()
        return user
    finally:
        cursor.close()
        conn.close()


def get_user_by_pseudo(pseudo):
    """Récupère un utilisateur par son pseudo."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT id, pseudo, email, date, taille, poids, sexe, imc
            FROM Utilisateurs WHERE pseudo = %s
        """, (pseudo,))
        user = cursor.fetchone()
        return user
    finally:
        cursor.close()
        conn.close()


# ========== FONCTIONS SÉRIE LOG & ENTRAÎNEMENT ==========

def get_user_recent_series(user_id, limit=20):
    """Récupère les séries récentes d'un utilisateur."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT 
                sl.id,
                sl.id_ex,
                e.nom_ex,
                e.description,
                sl.poids,
                sl.reps,
                sl.rpe,
                sl.type_serie,
                s.date_seance
            FROM serie_log sl
            JOIN seance s ON sl.id_seance = s.id_seance
            JOIN exercice e ON sl.id_ex = e.id_ex
            JOIN programme p ON s.id_programme = p.id_programme
            WHERE p.id_user = %s
            ORDER BY s.date_seance DESC
            LIMIT %s
        """, (user_id, limit))
        series = cursor.fetchall()
        return series
    finally:
        cursor.close()
        conn.close()


def get_user_records(user_id):
    """Récupère les records personnels d'un utilisateur."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT 
                rp.id,
                rp.id_ex,
                e.nom_ex,
                rp.poids_max,
                rp.date_record
            FROM record_personnel rp
            JOIN exercice e ON rp.id_ex = e.id_ex
            WHERE rp.id_utilisateur = %s
            ORDER BY rp.poids_max DESC
        """, (user_id,))
        records = cursor.fetchall()
        return records
    finally:
        cursor.close()
        conn.close()


def get_user_current_program(user_id):
    """Récupère le programme actuel de l'utilisateur."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT 
                id_programme,
                nom_programme,
                description_p,
                date_debut,
                date_fin,
                nb_seances_par_semaine
            FROM programme
            WHERE id_user = %s 
            AND date_fin IS NULL
            ORDER BY date_debut DESC
            LIMIT 1
        """, (user_id,))
        program = cursor.fetchone()
        return program
    finally:
        cursor.close()
        conn.close()


# ========== FONCTIONS RECOMMANDATION DE PROGRAMMES ==========

def get_user_level(user_id):
    """Détermine le niveau de l'utilisateur basé sur son historique."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        # Compter le nombre de séances
        cursor.execute("""
            SELECT COUNT(DISTINCT s.id_seance) as nb_seances
            FROM seance s
            JOIN programme p ON s.id_programme = p.id_programme
            WHERE p.id_user = %s
        """, (user_id,))
        result = cursor.fetchone()
        nb_seances = result['nb_seances'] if result else 0
        
        # Compter les records personnels
        cursor.execute("""
            SELECT COUNT(*) as nb_records
            FROM record_personnel
            WHERE id_utilisateur = %s
        """, (user_id,))
        result = cursor.fetchone()
        nb_records = result['nb_records'] if result else 0
        
        # Déterminer le niveau
        if nb_seances < 5 or nb_records < 3:
            return "débutant"
        elif nb_seances < 20 or nb_records < 10:
            return "intermédiaire"
        else:
            return "avancé"
            
    finally:
        cursor.close()
        conn.close()


def get_programs_by_level_and_objective(level, objective):
    """Récupère les programmes adaptés au niveau et objectif."""
    # Définition des programmes par niveau
    programs_by_level = {
        "débutant": [1, 6, 13, 19],  # Full Body Débutant, Bodyweight, Mobilité, Sénior
        "intermédiaire": [2, 3, 4, 8, 9],  # Split 4 Jours, PPL, Upper/Lower, Powerbuilding, Dos&Posture
        "avancé": [5, 11, 14, 15]  # Force Athlétique, Volume Allemand, Explosivité, Marathon
    }
    
    # Définition des programmes par objectif
    programs_by_objective = {
        "perdre_poids": [10, 17, 15],  # Cardio & Abs, Circuit HIIT, Marathon
        "perdre_poids_prendre_muscle": [8, 11, 2],  # Powerbuilding, Volume Allemand, Split Hypertrophie
        "se_mettre_en_forme": [1, 7, 17, 6]  # Full Body, Cross-Training, Circuit HIIT, Bodyweight
    }
    
    level_programs = programs_by_level.get(level, [])
    objective_programs = programs_by_objective.get(objective, [])
    
    # Programmes communs aux deux critères
    recommended_ids = list(set(level_programs) & set(objective_programs))
    
    # Si pas de programmes communs, prendre ceux du niveau
    if not recommended_ids:
        recommended_ids = level_programs[:3]  # Top 3 du niveau
    
    # Récupérer les détails des programmes
    if recommended_ids:
        conn = get_db()
        cursor = conn.cursor(dictionary=True)
        try:
            placeholders = ','.join(['%s'] * len(recommended_ids))
            cursor.execute(f"""
                SELECT id_programme, nom_programme, description_p, duree_semaines
                FROM programme
                WHERE id_programme IN ({placeholders})
                ORDER BY id_programme
            """, recommended_ids)
            programs = cursor.fetchall()
            return programs
        finally:
            cursor.close()
            conn.close()
    
    return []


def get_all_programs():
    """Récupère tous les programmes disponibles."""
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT id_programme, nom_programme, description_p, duree_semaines
            FROM programme
            ORDER BY id_programme
        """)
        programs = cursor.fetchall()
        return programs
    finally:
        cursor.close()
        conn.close()