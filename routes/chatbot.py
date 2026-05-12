"""
IronTrack — routes/chatbot.py
API pour le chatbot Eyelée utilisant Ollama Llama 3.
"""

from flask import Blueprint, request, jsonify, session
from db import get_db
import ollama

bp = Blueprint('chatbot', __name__)


def _build_site_context(user_id=None):
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT p.id_programme, p.nom_programme, p.description_p, p.duree_semaines
            FROM programme p
            WHERE p.id_createur IS NULL
        """
        params = []
        if user_id:
            query = """
                SELECT p.id_programme, p.nom_programme, p.description_p, p.duree_semaines
                FROM programme p
                WHERE p.id_createur IS NULL OR p.id_createur = %s
                ORDER BY p.id_createur IS NOT NULL DESC, p.id_programme
            """
            params = [user_id]

        cursor.execute(query, params)
        programmes = cursor.fetchall()

        for prog in programmes:
            cursor.execute("""
                SELECT e.nom
                FROM composer c
                JOIN exercice e ON c.id_ex = e.id_ex
                WHERE c.id_programme = %s
                ORDER BY c.ordre
            """, (prog['id_programme'],))
            prog['exercices'] = [row['nom'] for row in cursor.fetchall()]

        cursor.execute("""
            SELECT e.nom, e.description, e.equipement, e.difficulte
            FROM exercice e
            ORDER BY e.nom
        """)
        exercices = cursor.fetchall()

        programme_lines = []
        for prog in programmes:
            exercises = ', '.join(prog['exercices']) if prog['exercices'] else 'Aucun exercice connu'
            programme_lines.append(
                f"- {prog['nom_programme']} ({prog['duree_semaines']} semaines) : {prog['description_p'] or 'Pas de description'}. Exercices : {exercises}"
            )

        exercise_lines = []
        for ex in exercices:
            exercise_lines.append(
                f"- {ex['nom']} : {ex['description'] or 'Pas de description'} "
                f"(équipement: {ex['equipement'] or 'aucun'}, difficulté: {ex['difficulte'] or 'non précisée'})"
            )

        programmes_text = "\n".join(programme_lines)[:8000]
        exercices_text = "\n".join(exercise_lines)[:8000]

        return (
            "Voici les programmes et exercices disponibles sur le site IronTrack :\n"
            "Programmes :\n" + programmes_text + "\n\n"
            "Exercices :\n" + exercices_text
        )
    finally:
        cursor.close()
        conn.close()


@bp.route('/api/chatbot', methods=['POST'])
def api_chatbot():
    data = request.get_json(silent=True)
    if not data or not isinstance(data, dict):
        return jsonify({'error': 'JSON invalide'}), 400

    question = str(data.get('question', '')).strip()
    if not question:
        return jsonify({'error': 'La question est requise.'}), 400

    try:
        context = _build_site_context(session.get('user_id'))
        response = ollama.chat(
            model='llama3',
            messages=[
                {
                    'role': 'system',
                    'content': (
                        "Tu es un assistant pour le site IronTrack. "
                        "Réponds en français de manière claire, concise et utile. "
                        "Aide l'utilisateur à comprendre l'entraînement, la nutrition, "
                        "les fonctionnalités du site et la sécurité."
                    )
                },
                {
                    'role': 'system',
                    'content': context
                },
                {'role': 'user', 'content': question},
            ],
            stream=False,
        )

        answer = ''
        if hasattr(response, 'message') and response.message is not None:
            answer = getattr(response.message, 'content', '') or ''
        if not answer:
            answer = str(response)

        return jsonify({'answer': answer})
    except Exception as exc:
        return jsonify({'error': 'Erreur interne du chatbot', 'details': str(exc)}), 500
