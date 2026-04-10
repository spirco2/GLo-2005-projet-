"""
IronTrack — app.py
Initialisation Flask + montage des Blueprints.
"""

from flask import Flask
import os

app = Flask(
    __name__,
    template_folder='html',
    static_folder='static',
    static_url_path='/static'
)

# Clé secrète pour les sessions (à remplacer en production)
app.secret_key = os.environ.get('SECRET_KEY', 'irontrack-dev-secret-key-change-me')

# ── Blueprints ────────────────────────────────────────────────
from routes.acceuil import bp as acceuil_bp
from routes.securite import bp as securite_bp
from routes.programmes import bp as programmes_bp
from routes.suivi import bp as suivi_bp

app.register_blueprint(acceuil_bp)
app.register_blueprint(securite_bp)
app.register_blueprint(programmes_bp)
app.register_blueprint(suivi_bp)

if __name__ == '__main__':
    app.run(debug=True, port=5000)