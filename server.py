import logging
import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from langchain_google_genai import GoogleGenerativeAI
from langchain_core.prompts import PromptTemplate


class PlayerRequest(BaseModel):
    player_name: str


class ReportRequest(BaseModel):
    player1: str
    player2: str


async def lifespan(app: FastAPI):
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError(
            "API key for Google Generative AI not found in environment variables")

    logging.info("Initializing Google Generative AI...")

    llm = GoogleGenerativeAI(
        model="gemini-1.5-flash", temperature=0.3, google_api_key=api_key)
    prompt = PromptTemplate(
        template="Generate a report comparing {player1} and {player2}. Provide only the summary of the report in a maximum of 100 words.", input_variables=["player1", "player2"])
    app.state.sequence = prompt | llm

    yield

    del app.state.sequence


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post('/scrape')
async def scrape(request: PlayerRequest):
    try:
        data = scrape_fbref(request.player_name)
        return {"data": data}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post('/report')
async def report(request: ReportRequest):
    try:
        logging.info(f"Generating report for {
                     request.player1} and {request.player2}")
        data = app.state.sequence.invoke(
            {"player1": request.player1, "player2": request.player2})
        return {"data": data}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8000)
