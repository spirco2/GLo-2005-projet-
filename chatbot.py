from langchain_ollama import OllamaLLM
from langchain_core.prompts import ChatPromptTemplate

template = """
context de la convesation: {context}

Reponds a cette question

Question: {question}

Reponse:
"""

model = OllamaLLM(model="llama3")
prompt = ChatPromptTemplate.from_template(template)
chain = prompt | model

def gerer_conversation():
    context = ""
    print("Bonjour, je suis votre coach IA personnelle de quoi je peux vous aidez. Tapez bye pour quitter.")
    while True:
        user_input = input("Toi:")
        if user_input.lower() == "bye":
            break


        result = chain.invoke({"context": context, "question": user_input})
        print("coach", result)
        context += f"\nUser: {user_input}\nAI: {result}"


if __name__ == "__main__":
    gerer_conversation()