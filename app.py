# app.py — point d'entrée Flask
from flask import Flask, session
from routes.acceuil    import acceuil_bp
from routes.programmes import programmes_bp
from routes.suivi      import suivi_bp
from routes.securite   import securite_bp

app = Flask(__name__)
app.secret_key = 'irontrack_secret_2026'

# Enregistrer les blueprints de chaque membre
app.register_blueprint(acceuil_bp)
app.register_blueprint(programmes_bp)
app.register_blueprint(suivi_bp)
app.register_blueprint(securite_bp)

if __name__ == '__main__':
    app.run(debug=True)

@app.route('/test')
def test():
    return "App fonctionne"