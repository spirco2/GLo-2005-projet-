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
