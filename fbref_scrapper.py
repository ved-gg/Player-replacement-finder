import requests
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import os


def scrape_fbref(player_name: str) -> pd.DataFrame:
    name = '-'.join(player_name.split())
    player_url = f"https://fbref.com/en/search/search.fcgi?hint={
        name}&search={name}"

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
    }

    response = requests.get(player_url, headers=headers)
    response.raise_for_status()
    soup = BeautifulSoup(response.content, "html.parser")

    table = soup.find("table")
    df = pd.read_html(StringIO(str(table)))[0]

    # Convert the df into a json format
    # df = df.to_json()

    # Get personal info
    personal_info = ' '
    info = soup.find("div", {"id": "meta"})
    for p in info.find_all("p"):
        parts = [part.text.strip()
                 for part in p.children if p.string is not True]
        personal_info += ' '.join(parts) + '\n'

    df_json = df.to_dict(orient='records')
    personal_info = personal_info.strip()

    restructured_data = {
        "Statistic": df["Statistic"].tolist(),
        "Per 90": df["Per 90"].tolist(),
        "Percentile": df["Percentile"].tolist(),
        "Personal Info": personal_info
    }

    print(restructured_data)
    return restructured_data
    # return df_json, personal_info


# print(scrape_fbref("Aaron-Wan-Bissaka"))  # Test
