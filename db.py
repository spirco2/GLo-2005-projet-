# db.py — connexion à la base de données
import mysql.connector
from dotenv import load_dotenv

load_dotenv()
def get_connection():
    return mysql.connector.connect(
        host     = 'localhost',
        user     = 'root',
        password = 'tonmotdepasse',
        database = 'BD_LOCAL'
    )