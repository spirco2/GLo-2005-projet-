"""
IronTrack — app.py
Initialisation Flask + filtres Jinja2 + montage des Blueprints.
"""

from flask import Flask
from datetime import datetime
import os

app = Flask(
    __name__,
    template_folder='templates',
    static_folder='static',
    static_url_path='/static'
)

app.secret_key = os.environ.get('SECRET_KEY', 'irontrack-dev-secret-key-change-me')


# ── Filtre Jinja2 : dates en français ─────────────────────────
MOIS_FR = {
    1: 'jan', 2: 'fév', 3: 'mars', 4: 'avr', 5: 'mai', 6: 'juin',
    7: 'juil', 8: 'août', 9: 'sept', 10: 'oct', 11: 'nov', 12: 'déc'
}

MOIS_FR_LONG = {
    1: 'janvier', 2: 'février', 3: 'mars', 4: 'avril', 5: 'mai',
    6: 'juin', 7: 'juillet', 8: 'août', 9: 'septembre',
    10: 'octobre', 11: 'novembre', 12: 'décembre'
}


@app.template_filter('datefr')
def datefr(value, fmt='court'):
    """
    Formate une date en français.
    fmt='court'  → '05 jan'
    fmt='long'   → '5 janvier 2026'
    """
    if value is None:
        return '—'
    if isinstance(value, str):
        try:
            value = datetime.fromisoformat(value)
        except ValueError:
            return value
    if fmt == 'long':
        return f"{value.day} {MOIS_FR_LONG.get(value.month, '')} {value.year}"
    return f"{value.day:02d} {MOIS_FR.get(value.month, '')}"


@app.template_filter('duree_humaine')
def duree_humaine(seconds):
    """Convertit des secondes en format lisible : '1h 15min' ou '45 min'."""
    if not seconds or seconds == 0:
        return '0 min'
    seconds = int(seconds)
    h = seconds // 3600
    m = (seconds % 3600) // 60
    if h > 0:
        return f"{h}h {m:02d}min"
    return f"{m} min"


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