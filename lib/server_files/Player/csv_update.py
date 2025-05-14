import pandas as pd
import numpy as np


from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import os
import json
from bs4 import BeautifulSoup
import requests
import urllib

from unidecode import unidecode

positions_list = ['CB', 'LB', 'RB', 'LW', 'RW', 'GK', 'CF', 'CDM', 'CAM', 'CM']
leagues = [
    "Premier League",
    "La Liga",
    "Bundesliga",
    "SerieA",
    "Ligue 1",
]


def tis_csv_update(pos):
    csv_path = f"../../assets/data/playerdata/{pos}.csv"
    df = pd.read_csv(csv_path)
    nineties = np.array(df["90s"])
    df = df.fillna(0)
    np.seterr(divide='ignore', invalid='ignore')
    if (pos == 'CB'):
        # Defensive Actions
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Actions"] = (
            tackles+interceptions+blocks+clearances+recoveries)/nineties
        # Aerial Duels
        df["Aerial Duels"] = np.array(df["Won%"])/nineties
        # Passing and Build-up Play
        key_passes = np.array(df["KP"])
        pass_cmp = np.array(df["Cmp%"])
        progressive_passes = np.array(df["PrgP"])
        df["Passing and Build-up"] = (key_passes +
                                      pass_cmp+progressive_passes)/(nineties*10)
        # Positioning and Defensive Awarness
        df["Defensive Awareness"] = (clearances+blocks)/nineties
        # Discipline
        yellow_cards = np.array(df["CrdY"])
        second_yellow_card = np.array(df["2CrdY"])
        red_cards = np.array(df["CrdR"])
        fouls = np.array(df["Fls"])
        df["Discipline"] = (
            yellow_cards+second_yellow_card+red_cards+fouls)/nineties
    if (pos == 'LB' or pos == 'RB'):
        # Defensive Duties
        tackles_Def_3rd = np.array(df["Def 3rd"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Duties"] = (
            tackles_Def_3rd+interceptions+blocks+clearances+recoveries)/nineties
        # Offensive Contribution
        prg_carries = np.array(df["PrgC"])
        prg_passes = np.array(df["PrgP"])
        key_passes = np.array(df["KP"])
        xA = np.array(df["xA"])
        df["Offensive Contributions"] = (
            prg_carries+prg_passes+xA+key_passes)/nineties
        # Final Third Play
        crosses_attempted = np.array(df["Crs"])
        shot_creating_actions = np.array(df["SCA"])
        carries_penalty_area = np.array(df["CPA"])
        passes_penalty_area = np.array(df["PPA"])
        df["Final Third Play"] = (
            crosses_attempted+shot_creating_actions+carries_penalty_area+passes_penalty_area)/nineties
        # Possession Play
        TAtt3rd = np.array(df["Att 3rd_possession"])
        carry_distance = np.array(df["TotDist"])/100
        df["Possession Play"] = (TAtt3rd+carry_distance)/(nineties*10)
        # Dribbling and Transition Play
        successful_take_ons = np.array(df["Succ"])
        df["Dribbling Accuracy"] = successful_take_ons/nineties
    if (pos == 'CDM'):
        # Defensive Contributions
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Contributions"] = (
            tackles+interceptions+blocks+clearances+recoveries)/nineties
        # Passing Ability
        pass_cmp = np.array(df["Cmp%"])
        df["Passing Ability"] = pass_cmp/nineties
        # Build-up Play
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        Ast = np.array(df["Ast"])
        prgDist = np.array(df["PrgDist"])/100
        df["Build-Up Play"] = (xA+xAG+Ast+prgDist)/nineties
        # Ball Recovery and Defensive Work
        recoveries = np.array(df["Recov"])
        interceptions = np.array(df["Int"])
        df["Ball Recovery & Defensive Work"] = (
            recoveries+interceptions)/(nineties*10)
        # Defensive Line Breaking Passes
        prg_passes = np.array(df["PrgP"])
        key_passes = np.array(df["KP"])
        passes_final_third = np.array(df["Final Third"])
        df["Line Breaking Passes"] = (
            key_passes+prg_passes+passes_final_third)/(nineties*10)
    if (pos == "CM"):
        # Passing and Vision
        prg_passes = np.array(df["PrgP"])
        passes_final_third = np.array(df["Final Third"])
        df["Passing"] = (prg_passes+passes_final_third)/nineties
        # Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Ball Carrying"] = (successful_take_ons+prg_carries+cpa)/nineties
        # Defensive Work
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Work"] = (tackles+interceptions +
                                blocks+clearances+recoveries)/nineties
        # Chance Creation
        sca = np.array(df["SCA"])
        xG = np.array(df["xG"])
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        df["Chance Creation"] = (sca+xG+xA+xAG)/nineties
        # Possession Retention
        pass_cmp = np.array(df["Cmp"])
        key_passes = np.array(df["KP"])
        passes_final_third = np.array(df["Final Third"])
        successful_take_ons = np.array(df["Succ"])
        df["Possession Retention"] = (
            pass_cmp+key_passes+passes_final_third+successful_take_ons)/(nineties*10)
    if (pos == "CAM"):
        # Creativity and Playmaking
        xA = np.array(df["xA"])
        sca = np.array(df["SCA"])
        passes_final_third = np.array(df["Final Third"])
        df["Playmaking"] = (xA+sca+passes_final_third)/nineties
        # Ball Progression
        prg_carries = np.array(df["PrgC"])
        prg_passes = np.array(df["PrgP"])
        df["Ball Progression"] = (prg_passes+prg_carries)/nineties
        # Final Third Impact
        TAtt3rd = np.array(df["Att 3rd_possession"])
        cpa = np.array(df["CPA"])
        ppa = np.array(df["PPA"])
        df["Final Third Impact"] = (TAtt3rd+cpa+ppa)/(nineties*10)
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/nineties
        # Final Ball Efficiency
        passes_final_third = np.array(df["xA"])
        ppa = np.array(df['xAG'])
        assists = np.array(df["Ast"])
        df["Final Ball Efficiency"] = (passes_final_third+ppa+assists)/nineties
    if (pos == "LW" or pos == "RW"):
        # Dribbling and Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Dribbling"] = (successful_take_ons+prg_carries+cpa)/nineties
        # Crossing and Playmaking
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        crosses_attempted = np.array(df["Crs"])
        df["Crosses and Playmaking"] = (xA+xAG+crosses_attempted)/nineties
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/nineties
        # Final Third Involvement
        TAtt3rd = np.array(df["Att 3rd_possession"])
        cpa = np.array(df["CPA"])
        ppa = np.array(df["PPA"])
        df["Final Third Impact"] = (TAtt3rd+cpa+ppa)/(nineties*10)
        # Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Ball Carrying"] = (successful_take_ons+prg_carries+cpa)/nineties
    if (pos == 'CF'):
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/nineties
        # Chance Conversion
        npGoals = np.array(df["G-PK"])/nineties
        xG = np.array(df["xG"])/nineties
        df["Chance Conversion"] = (npGoals+xG)/nineties
        # Link-up Play
        prg_received = np.array(df["PrgR"])
        passes_final_third = np.array(df["1/3_possession"])
        xA = np.array(df["xA"])
        ppa = np.array(df["PPA"])
        df["Link-Up Play"] = (prg_received+xA+ppa)/nineties
        # Shooting Accuracy
        SoT = np.array(df["SoT"])
        shots = np.array(df["Sh"])
        df["Shooting Accuracy"] = (SoT+shots)/nineties
        # Penalty Box Presence
        TAttPen = np.array(df["Att Pen"])
        df["Penalty Box Presence"] = TAttPen/nineties
    if (pos == "GK"):
        # Shot Stopping Ability
        saves = np.array(df["Saves"])
        df["Shot Stopping"] = saves/nineties
        # Expected Goals Prevented
        psxG = np.array(df["PSxG"]/nineties)
        ga = np.array(df["GA"]/nineties)
        df["Expected Goals Prevented"] = psxG-ga
        # Cross and Aerial Control
        crosses_stopped = np.array(df["Stp"])
        df["Cross and Aerial Control"] = crosses_stopped/nineties
        # Sweeper Keeper Activity
        sweeper = np.array(df["#OPA/90"])
        df["Sweeper Keeper Activity"] = sweeper
        # Passing and Distribution
        passes_cmp = np.array(df["Cmp"])
        key_passes = np.array(df["KP"])
        passes_final_third = np.array(df["Final Third"])
        df["Distribution Ability"] = (
            passes_cmp+key_passes+passes_final_third)/nineties
    df = df.fillna(0)
    df.to_csv(csv_path, index=False)


for pos in positions_list:
    print(f"Csv for {pos} updated")
    tis_csv_update(pos)


def player_table(position, name_list):
    # Define the CSV path
    csv_path = f"../../assets/data/playerdata/{position}.csv"

    # Load the CSV into a DataFrame
    df = pd.read_csv(csv_path)

    # Filter by the names in the list
    filtered_df = df[df['name'].isin(name_list)]

    # Select only the last 6 columns
    result_df = filtered_df[['name'] + list(filtered_df.columns[-6:])]
    # Save the result to a new CSV file
    output_path = f"../../assets/data/playerdata/{position}_filtered.csv"
    result_df.to_csv(output_path, index=False)


# Example usage
player_table("CF", ['Robert Lewandowski', 'Harry Kane',
             'Erling Haaland', 'Kylian Mbappé', 'Lautaro Martínez'])


league_links = {
    "Premier League": "https://fbref.com/en/comps/9/Premier-League-Stats",
    "La Liga": "https://fbref.com/en/comps/12/La-Liga-Stats",
    "Liga Portugal": "https://fbref.com/en/comps/32/Primeira-Liga-Stats",
    "Bundesliga": "https://fbref.com/en/comps/20/Bundesliga-Stats",
    "Eredivise": "https://fbref.com/en/comps/23/Eredivisie-Stats",
    "SerieA": "https://fbref.com/en/comps/11/Serie-A-Stats",
    "Ligue 1": "https://fbref.com/en/comps/13/Ligue-1-Stats",
}


def image_getter(player_name):
    normalized_name = unidecode(player_name.decode("utf-8"))
    formatted_name = "-".join(normalized_name.split())
    player_url = f"https://fbref.com/en/search/search.fcgi?hint={formatted_name}&search={formatted_name}"
    headers = {
        "User-Agent": "Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
    }
    request = Request(player_url, headers=headers)
    query = urlopen(request).read().decode("utf-8")
    soup = BeautifulSoup(query, "html.parser")
    if "Players from Leagues Covered by FBref." in soup.text:
        options = soup.find_all("div", {"class": "search-item-name"})
        for option in options:
            if unidecode(option.find("a").text.strip()) == normalized_name.strip():
                player_url = option.find("a", href=True)['href']
                request = Request(
                    f"https://fbref.com{player_url}", headers=headers)
                query = urlopen(request).read().decode(
                    "utf-8")  # ✅ Decode again
                soup = BeautifulSoup(query, "html.parser")
                break
    info = soup.find("div", {"id": "meta"})
    for div in info.find_all("div", {'class': 'media-item'}):
        image = div.find("img")
        if image and "src" in image.attrs:
            return image["src"]

    return None


def advanced_top_performers(league, top_performers_df):
    path = f"../../assets/data/playerdata/Players_Leaguewise/{league}_players.csv"
    players_df = pd.read_csv(path)
    # TODO: Create a leaderboard based on advanced metrics such npxG, successful take ons, xA, xG, etc.


def top_performers_csv_update(league):
    csv_path = f"../../assets/data/{league}/{league}_TopPerformers.csv"
    top_performers_df = pd.read_csv(csv_path)
    link = league_links[league]
    HEADERS = {
        "User-Agent": "Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(link, headers=HEADERS)
    if response.status_code != 200:
        print("Failed to fetch the page. Got response: ", response.status_code)
        return
    soup = BeautifulSoup(response.text, "html.parser")
    info = soup.find("div", {'id': 'meta'})
    for p in info.find_all("p"):
        strong = p.find("strong")
        a = p.find("a")
        span = p.find("span")
        if strong and a and span:
            if strong.text.strip() == "Most Goals":  # Strip to avoid leading/trailing spaces
                top_performers_df['Top Scorer Team'] = p.text.split(
                    "(")[-1].split(")")[0]
                player_name = a.text.encode("utf-8").strip()
                top_performers_df['Scorer Image'] = image_getter(player_name)
                top_performers_df['Top Scorer'] = a.text.strip()
                top_performers_df['Goals Scored'] = span.text.strip()
            if strong.text.strip() == "Most Assists":  # Strip to avoid leading/trailing spaces
                top_performers_df['Top Assister Team'] = p.text.split(
                    "(")[-1].split(")")[0]
                player_name = a.text.encode("utf-8").strip()
                top_performers_df['Assister Image'] = image_getter(player_name)
                top_performers_df['Top Assister'] = a.text.strip()
                top_performers_df['Assists Provided'] = span.text.strip()
            if strong.text.strip() == "Most Clean Sheets":  # Strip to avoid leading/trailing spaces
                top_performers_df['Most CS Team'] = p.text.split(
                    "(")[-1].split(")")[0]
                player_name = a.text.encode("utf-8").strip()
                top_performers_df['Clean Sheets Image'] = image_getter(
                    player_name)
                top_performers_df['Most Clean Sheets'] = a.text.strip()
                top_performers_df['Clean Sheets'] = span.text.strip()

    advanced_top_performers(league, top_performers_df)
    top_performers_df.to_csv(csv_path, index=False)


for league in leagues:
    top_performers_csv_update(league)
    print(f"{league} File Updated")

# top_performers_csv_update("SerieA")
