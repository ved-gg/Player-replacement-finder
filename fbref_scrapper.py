# import requests
from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import os
import json


def scrape_fbref(player_name: str) -> dict:
    name = '-'.join(player_name.split())
    player_url = f"https://fbref.com/en/search/search.fcgi?hint={
        name}&search={name}"

    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
    }

    response = Request(player_url, headers=headers)
    query = urlopen(response).read()
    soup = BeautifulSoup(query, "html.parser")

    table = soup.find("table")
    df = pd.read_html(StringIO(str(table)))[0]

    # Convert the df into a json format
    # df = df.to_json()

    # Get personal info
    personal_info = {}
    info = soup.find("div", {"id": "meta"})
    for p in info.find_all("p"):
        parts = [part.text.strip()
                 for part in p.children if p.string is not True]
        key = parts[0].replace(':', '').strip() if parts else 'Other'
        value = ' '.join(parts[1:]).strip() if len(parts) > 1 else ''
        personal_info[key] = value

    df_json = df.to_dict(orient='records')

    restructured_data = {
        "Statistic": df["Statistic"].tolist(),
        "Per 90": df["Per 90"].tolist(),
        "Percentile": df["Percentile"].tolist(),
        "Personal Info": personal_info
    }

    print(restructured_data)
    return restructured_data


print(scrape_fbref("Aaron-Wan-Bissaka"))  # Test

