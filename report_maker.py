from langchain_core.prompts import PromptTemplate
from langchain_google_genai import GoogleGenerativeAI
import os
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    raise ValueError(
        "API key for Google Generative AI not found in environment variables")


def generate_report(player1, player2):

    llm = GoogleGenerativeAI(model="gemini-1.5-flash",
                             temperature=0.3, google_api_key=api_key)
    template = "Generate a report comparing {player1} and {player2}. Provide only the summary of the report in a maximum of 100 words."
    prompt = PromptTemplate(template=template, input_variables=[
                            "player1", "player2"])
    sequence = prompt | llm
    report = sequence.invoke({"player1": player1, "player2": player2})
    return report


if __name__ == "__main__":
    player1 = "Lamine Yamal"
    player2 = "Nicolas Jackson"
    print(generate_report(player1, player2))
