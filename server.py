from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from report_maker import generate_report

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class PlayerRequest(BaseModel):
    player_name: str


@app.post('/scrape')
async def scrape(request: PlayerRequest):
    try:
        player_name = request.player_name
        data = scrape_fbref(player_name)
        return {"data": data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def generate_report(player1, player2):
    report = generate_report(player1, player2)
    return report


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000, debug=True)
