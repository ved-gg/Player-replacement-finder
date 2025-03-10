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
from fbref_searcher import scrape_fbref


league_links = {
     "Premier League":"https://fbref.com/en/comps/9/Premier-League-Stats", 
     "La Liga":"https://fbref.com/en/comps/12/La-Liga-Stats", 
     "Liga Portugal":"https://fbref.com/en/comps/32/Primeira-Liga-Stats",
     "Bundesliga": "https://fbref.com/en/comps/20/Bundesliga-Stats",
     "Eredivise": "https://fbref.com/en/comps/23/Eredivisie-Stats",
     "SerieA": "https://fbref.com/en/comps/11/Serie-A-Stats",
     "Ligue 1": "https://fbref.com/en/comps/13/Ligue-1-Stats",
}


def standings_getter(league):

     league_standings = {}
     try:
          standings = pd.read_csv(f"assets\Data\{league}\{league}_Standings.csv")
          standings = standings.drop(columns=['xG','xGA','xGD','xGD/90','Top Team Scorer','Goalkeeper','Pts/MP','Last 5'])
          # for i in range(len(standings)):
          league_standings = {
               "Rank": list(standings["Rk"]), 
               "Teams": list(standings["Squad"]), 
               "MP": list(standings["MP"]), 
               "W": list(standings["W"]), 
               "D": list(standings["D"]), 
               "L": list(standings["L"]), 
               "GF": list(standings["GF"]), 
               "GA": list(standings["GA"]), 
               "GD": list(standings["GD"]), 
               "Pts": list(standings["Pts"]), 
          }   
          print(league_standings)  
          return league_standings
     except Exception as e:
          print("Something went wrong in standings_getter:",e)

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
                request = Request(f"https://fbref.com{player_url}", headers=headers)
                query = urlopen(request).read().decode("utf-8")  # ✅ Decode again
                soup = BeautifulSoup(query, "html.parser")
                break
    info = soup.find("div", {"id": "meta"})
    for div in info.findAll("div", {'class': 'media-item'}):
        image = div.find("img")
        if image and "src" in image.attrs:
            return image["src"]

    return None  

def fetch_top_performers(league):
     best_performers = {}
     link = league_links[league]
     HEADERS = {
          "User-Agent": "Mozilla/6.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
     }
     response = requests.get(link, headers=HEADERS)
     if response.status_code != 200:
          print("Failed to fetch the page.")
          return
     soup = BeautifulSoup(response.text, "html.parser")
     info = soup.find("div",{'id':'meta'})
     for p in info.findAll("p"):
          strong = p.find("strong")
          a = p.find("a")
          span = p.find("span")
          if strong and a and span:
               if strong.text.strip() == "Most Goals":  # Strip to avoid leading/trailing spaces
                    team_name = p.text.split("(")[-1].split(")")[0]
                    player_name = a.text.encode("utf-8").strip()
                    scorer_image = image_getter(player_name)
                    best_performers['Top Scorer'] = {a.text.strip(): span.text.strip(), 'image':scorer_image,'team':team_name}
               if strong.text.strip() == "Most Assists":  # Strip to avoid leading/trailing spaces
                    team_name = p.text.split("(")[-1].split(")")[0]
                    player_name = a.text.encode("utf-8").strip() 
                    assister_image = image_getter(player_name)
                    best_performers['Top Assister'] = {a.text.strip(): span.text.strip(), 'image':assister_image,'team':team_name}
               if strong.text.strip() == "Most Clean Sheets":  # Strip to avoid leading/trailing spaces
                    team_name = p.text.split("(")[-1].split(")")[0]
                    player_name = a.text.encode("utf-8").strip()
                    sheets_image = image_getter(player_name)
                    best_performers['Clean Sheets'] = {a.text.strip(): span.text.strip(), 'image': sheets_image,'team':team_name}
     print(best_performers)
     return best_performers

# fetch_top_performers("La Liga")
# image_getter("Lionel Messi")
standings_getter("La Liga")
