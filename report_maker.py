from langchain_core.prompts import PromptTemplate
from langchain_google_genai import GoogleGenerativeAI
from langchain_core.runnables import RunnableSequence


def generate_report(player1, player2):
    llm = GoogleGenerativeAI(model="gemini-1.5-flash",
                             google_api_key="AIzaSyAM1ee61TpPMXFMi3nOzca044J5h-ekjQU", temperature=0.3)
    template = "Generate a report comparing {player1} and {player2}. Provide only the summary of the report in a maximum of 100 words."
    prompt = PromptTemplate(template=template, input_variables=[
                            "player1", "player2"])
    sequence = prompt | llm

    report = sequence.invoke({"player1": player1, "player2": player2})

    return report

# if __name__ == "__main__":
#     player1 = "Lamine Yamal"
#     player2 = "Nicolas Jackson"
#     print(generate_report(player1, player2))
