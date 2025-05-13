import os
import pandas as pd
import numpy as np


league_links = {
    "Premier League": "https://fbref.com/en/comps/9/Premier-League-Stats",
    "La Liga": "https://fbref.com/en/comps/12/La-Liga-Stats",
    "Liga Portugal": "https://fbref.com/en/comps/32/Primeira-Liga-Stats",
    "Bundesliga": "https://fbref.com/en/comps/20/Bundesliga-Stats",
    "Eredivise": "https://fbref.com/en/comps/23/Eredivisie-Stats",
    "SerieA": "https://fbref.com/en/comps/11/Serie-A-Stats",
    "Ligue 1": "https://fbref.com/en/comps/13/Ligue-1-Stats",
}


def path_decider(league):
    folder_path = f"./assets/data/{league}"
    if os.path.exists(folder_path):
        return folder_path
    else:
        os.mkdir(folder_path)
    return folder_path


def league_standings_csv(league):
    link = league_links[league]
    df = pd.read_html(link)
    df[0] = df[0].drop(columns=['Notes', 'Attendance'])
    folder_path = path_decider(league)
    csv_path = os.path.join(folder_path, f"{league}_Standings.csv")
    df[0].to_csv(csv_path, index=False)


def squad_defensive_actions(league):
    link = league_links[league]
    df = pd.read_html(link)
    folder_path = path_decider(league)
    csv_path = os.path.join(
        folder_path, f"{league}_Squad_Defensive_Actions.csv")
    df[16].to_csv(csv_path, index=False)


squad_defensive_actions("Eredivise")

# league_standings_csv("Premier League")s

# for key in league_links.keys():
#     print(key)
#     league_standings_csv(key)
#     squad_defensive_actions(key)
