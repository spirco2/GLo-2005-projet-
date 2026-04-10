"""
IronTrack — db.py
Connexion MySQL brute via mysql.connector (pas d'ORM).
"""

import mysql.connector
from mysql.connector import pooling

# ── Configuration ──────────────────────────────────────────────
DB_CONFIG = {
    'host':     'localhost',
    'user':     'root',
    'password': 'Melvin08042006%',           # à adapter selon votre environnement
    'database': 'db_local',
    'charset':  'utf8mb4',
    'autocommit': False,      # on gère les transactions manuellement
}

# Pool de 5 connexions réutilisables
_pool = pooling.MySQLConnectionPool(
    pool_name='irontrack_pool',
    pool_size=5,
    **DB_CONFIG
)


def get_db():
    """Retourne une connexion depuis le pool."""
    return _pool.get_connection()