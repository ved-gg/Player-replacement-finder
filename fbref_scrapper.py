"""
    ?SCRAPER FOR FBREF.COM:
    This script is used to scrap data from fbref.com
    We will use the European big 5 leagues as our dataset, get links for each league from -> https://fbref.com/en/comps/
    For each league, we will traverse through the past five seasons and get the data for each player.
    For each season, we get the team links using the first table.
    Traversing the team links, we get the player links using the first table.
    We then traverse the player links and get the player data using the scrape_fbref function.
"""

"""
    ?DATA CLEANING and METRICS:
    We would need to calculate the similarity index between players to cluster them.
    We can use the following features to calculate the similarity index:
    1. Age
    2. Position
    3. National
    4. Club
    5. Minutes Played
    6. Goals
    7. Assists
    8. Yellow Cards
    9. Red Cards
    10. Shots per 90
    11. Key Passes per 90
    12. Dribbles per 90
    13. Tackles per 90
    14. Interceptions per 90
    15. Blocks per 90
    16. xG per 90
    17. xA per 90
    18. xG+xA per 90
    19. xGChain per 90
    20. xGBuildup per 90
    21. Player Value

    For goalkepeers, the following features can be used:
    1. Age
    2. National
    3. Club
    4. Minutes Played
    5. Goals Conceded
    6. Clean Sheets
    7. Saves
    8. Save %
    9. Yellow Cards
    10. Red Cards
    11. Player Value

    We can use the following clustering algorithms:
    1. KMeans
    2. DBSCAN
    3. Agglomerative Clustering
    4. Spectral Clustering
    5. Gaussian Mixture Model
    6. Affinity Propagation
    7. Mean Shift
    8. Birch
    9. OPTICS
    10. HDBSCAN

    ?DIMENSIONALITY REDUCTION:
    We can use the following dimensionality reduction techniques:
    1. PCA
    2. LDA
    3. t-SNE
    4. UMAP
    5. Autoencoder
    6. Isomap
    7. MDS
    8. LLE
    9. Laplacian Eigenmaps
    10. Hessian Eigenmaps
    11. Diffusion Maps

    ?EVALUATION METRICS:
    We can use the following evaluation metrics:
    1. Silhouette Score
    2. Davies-Bouldin Index
    3. Dunn Index
    4. Calinski-Harabasz Index
    5. Homogeneity Score
    6. Completeness Score
    7. V-Measure
    8. Adjusted Rand Index
    9. Adjusted Mutual Information
    10. Fowlkes-Mallows Index

    ?METHOD TO DECIDE THE NUMBER OF CLUSTERS:
    We can use the following methods to decide the number of clusters:
    1. Elbow Method
    2. Silhouette Method
    3. Gap Statistics
    4. Davies-Bouldin Index

    ?How to decide which players to use in the similarity index calculation:
    We can use the following methods:
    1. Use all players
    2. Use players from the same position
    3. Use players from the same club ->
    4. Use players from the same league -> Useful for team building in the same league
    5. Use players from the same national team
    6. Use players from the same age group -> Useful for young players
    8. Use players from the same minutes played group -> Useful for goalkeepers
    9. Use players from the same goals group -> Useful for forwards
    10. Use players from the same assists group
    13. Use players from the same shots per 90 group
    14. Use players from the same key passes per 90 group
    19. Use players from the same xG per 90 group

"""




import logging
from typing import List
import requests
from bs4 import BeautifulSoup
import pandas as pd
import numpy as np
import re
import json
class FbRefScrapper:
    def __init__(self):
        self.base_url = "https://fbref.com/"
        self.leagues = ["Premier League", "La Liga",
                        "Serie A", "Bundesliga", "Ligue 1"]
        self.seasons_ids = [9, 12, 11, 20, 13]
        self.seasons = ["2023-2024", "2022-2023", "2021-2022", "2020-2021", "2019-2020",
                        "2018-2019", "2017-2018", "2016-2017"]
        self.player_data = []
        self.team_data = []
        self.league_data = []
        self.player_links = []
        self.team_links = []
        self.league_links = []
        self.club_icons = []

        logger = logging.getLogger(__name__)
        logging.basicConfig(level=logging.INFO)

    def get_league_links(self) -> List:
        for j, season in enumerate(self.seasons):
            for i, league in enumerate(self.leagues):
                self.league_links.append(f"{self.base_url}/en/comps/{self.seasons_ids[i]}/{
                    season}/{season}-{league.replace(' ', '-')}-Stats")
            break
        return self.league_links

    def get_team_links(self, league_link: str) -> List:
        response = requests.get(league_link)
        soup = BeautifulSoup(response.content, 'html.parser')
        container = soup.find("div", class_="table_container")
        if not container:
            return self.team_links
        table = container.find("table") if container else None
        if table:
            # Gets the club image and club link
            links = table.find_all(  # type: ignore
                "td", {"data-stat": "team"})
            if links:
                for link in links:
                    self.team_links.append(
                        f"{self.base_url}{link.find("a")["href"]}")
                    self.club_icons.append(link.find("img")["src"])
        return self.team_links

    def get_player_links(self, team_link: str) -> List:
        response = requests.get(team_link)
        soup = BeautifulSoup(response.content, 'html.parser')
        container = soup.find("div", class_="table_container")
        if not container:
            return self.player_links
        table = container.find("table") if container else None
        if table:
            links = table.find_all(  # type: ignore
                "td", {"data-stat": "player"})
            if links:
                for link in links:
                    self.player_links.append(
                        f"{self.base_url}{link.find('a')['href']}")
        return self.player_links


scraper = FbRefScrapper()
league_links = scraper.get_league_links()
if not league_links:
    print("No league links found!")
else:
    for league_link in league_links:
        team_links = scraper.get_team_links(league_link)
        if not team_links:
            print("No team links found!")
        else:
            for team_link in team_links:
                player_links = scraper.get_player_links(team_link)
                if not player_links:
                    print("No player links found!")
                else:
                    print(player_links)
                    break
                break
            break
