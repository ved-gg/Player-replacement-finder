import traceback
import pandas as pd
import json

from fastapi import FastAPI, HTTPException, Header, Body, status
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from fbref_searcher import scrape_fbref
from League.standings_getter import standings_getter
# from standings_getter import fetch_top_performers
from League.leagues_plot_data import attack_vs_defence
from League.leagues_plot_data import defensive_solidity
from Player.attributes_calculation import attributes_calculation
from League.top_performers import get_top_performers
from Player.formation_fit_analysis import analyze_formations
from Player.players_dashboard_data import send_dashboard_data

app = FastAPI(
    title="Football Stats API",
    description="API for fetching football player and league statistics.",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ScrapeRequest(BaseModel):
    player_name: str


def load_player_data_for_fitness(player_name: str, player_pos: str) -> pd.Series | None:
    try:
        file_path = f'../../assets/data/playerdata/{player_pos}.csv'
        df = pd.read_csv(file_path)
        df = df.reset_index(drop=True)
        match = df[df['name'].str.lower() == player_name.lower()]
        return match.iloc[0] if not match.empty else None
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None
    except Exception as e:
        print(
            f"Error loading data from {file_path} for {player_name} ({player_pos}): {str(e)}")
        return None


@app.post("/scrape")
async def scrape_player_data(payload: ScrapeRequest):
    try:
        data = scrape_fbref(payload.player_name)
        return {"data": data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# @app.post("/report")
# async def generate_player_report(payload: ReportRequest): # Assuming ReportRequest Pydantic model
#     try:
#         # from your_module import generate_report
#         report_data = generate_report(payload.player1, payload.player2)
#         print(report_data)
#         return {"report": report_data}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))


@app.get("/standings")
async def get_league_standings(league: str = Header(..., description="League identifier")):
    try:
        data = standings_getter(league)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/top_performers")
async def get_league_top_performers(league: str = Header(..., description="League identifier")):
    try:
        data = get_top_performers(league)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/attack_vs_defence_charts_data")
async def get_attack_vs_defence_data(league: str = Header(..., description="League identifier")):
    try:
        data = attack_vs_defence(league)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/defensive_solidity")
async def get_defensive_solidity_data(league: str = Header(..., description="League identifier")):
    try:
        data = defensive_solidity(league)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/player_attributes")
async def get_player_attributes_data(
    position: str = Header(..., description="Player's position"),
    player: str = Header(..., description="Player's name")
):
    try:
        data = attributes_calculation(position, player)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


@app.get("/fitness_score")
async def get_player_formation_fitness_score(
    player: str = Header(..., description="Player's name"),
    position: str = Header(..., description="Player's position")
):
    try:
        if not player or not position:
            raise HTTPException(
                status_code=400, detail="Missing player name or position in headers")

        player_data = load_player_data_for_fitness(player, position)

        if player_data is None:
            available_players_list = []
            try:
                available_players_df = pd.read_csv(
                    f'../../assets/data/playerdata/{position}.csv')
                available_players_list = list(available_players_df['name'])
            except Exception:
                pass

            raise HTTPException(
                status_code=404,
                detail={
                    'error': f'Player {player} not found in position {position} data',
                    'available_players_in_position': available_players_list if available_players_list else "Could not retrieve list."
                }
            )

        if not isinstance(player_data, pd.Series):
            raise HTTPException(
                status_code=500, detail="Data loading format incorrect for player.")

        results = analyze_formations(player_data, position)
        formatted_results = []
        for res in results:
            if res.get('score', 0) > 0:
                formatted_results.append({
                    'formation': res.get('formation'),
                    'score': float(res.get('score', 0.0)),
                    'style': res.get('style'),
                    'position': res.get('position'),
                    'explanation': res.get('explanation')
                })

        return {
            'player': player,
            'position': position,
            'results': formatted_results
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail={
                'error': str(e),
                'traceback': traceback.format_exc()
            }
        )


@app.get("/player_dashboard_data")
async def get_player_dashboard(
    position: str = Header(..., description="Player's position"),
    player: str = Header(..., description="Player's name")
):
    try:
        data = send_dashboard_data(position, player)
        print(data)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


@app.get("/healthz")
async def healthz_check():
    return {"status": "ok"}


@app.head("/healthz", status_code=status.HTTP_200_OK)
async def healthz_check_head():
    return {}
