# import requests
from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import os
import json


def scrape_fbref(player_url: str) -> dict:
    # name = '-'.join(player_name.split())
    # player_url = f"https://fbref.com/en/search/search.fcgi?hint={
    #     name}&search={name}"

    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
    }

    response = Request(player_url, headers=headers)
    query = urlopen(response).read()
    soup = BeautifulSoup(query, "html.parser")

    # Get player statistics table
    table = soup.find("table")
    df = pd.read_html(StringIO(str(table)))[0]
    df = df.dropna()

    # Get personal info
    personal_info = {}
    info = soup.find("div", {"id": "meta"})
    if not info:
        return {"error": "Player not found"}
    for p in info.find_all("p"):
        # print("Original text: {}".format(p.text))
        # parts = [part.text.strip()
        #          for part in p.children if p.string is not True]
        parts = p.text.replace('\n', '').replace('  ', '').replace(':', ' ').replace('\n', '').strip().split()
        if 'cm' in parts[0]:
            personal_info['Height'] = parts[0]
            personal_info['Weight'] = parts[1] if parts[1] != ',' else parts[2]
        elif 'position' in parts[0]:
            personal_info['Position'] = parts[1]
            if 'Footed' in parts[1]:
                personal_info['Footed'] = parts[1].split()[-1]
        else:
            personal_info[parts[0]] = ' '.join(parts[1:]) if len(parts) > 2 else parts[1]

    name_tag = info.find('h1') if info.find('h1') else None
    if not name_tag:
        return {"error": "Player not found"}
    personal_info['name'] = name_tag.text.replace('\n', '') if name_tag else 'Unknown'
    personal_info['image'] = info.find(
        'div', {'class': 'media-item'}).find('img')['src'] if info.find('div', {'class': 'media-item'}) else 'Unknown'

    statistics = {
        "per_90": {stat: float(value.replace('%', '').strip()) if value.replace('.', '', 1).replace('%', '').isdigit() else value
                   for stat, value in zip(df["Statistic"].tolist(), df["Per 90"].tolist())},
        "percentiles": {stat: float(percentile) for stat, percentile in zip(df["Statistic"].tolist(), df["Percentile"].tolist())}
    }

    restructured_data = {
        "player_id": player_url.split('/')[-1],
        "Statistic": statistics,
        "Personal Info": personal_info
    }

    return restructured_data

# print(scrape_fbref("https://fbref.com/en/players/2f965a72/Alphonse-Areola"))  # Test
