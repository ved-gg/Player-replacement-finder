import re
import pandas as pd
import requests
from bs4 import BeautifulSoup

# Base URL for FBref
BASE_URL = "https://fbref.com/en/comps/{}/{}/stats/players/{}-{}-Stats"

# Dictionary for league IDs on FBref
LEAGUES = {
    "Premier League": 9,
    "La Liga": 12,
    "Bundesliga": 20,
    "Serie A": 11,
    "Ligue 1": 13,
}


def get_league_data(league_name, league_id, season):
    """Scrape player statistics for a given league."""
    url = BASE_URL.format(league_id, season, season,
                          league_name.replace(" ", "-"))
    response = requests.get(url)
    if response.status_code != 200:
        print(f"Failed to fetch data for {league_name}")
        return None

    soup = BeautifulSoup(response.text, "html.parser")
    comments = re.findall(r"<!--\s*([\s\S]*?)\s*-->", str(soup), re.DOTALL)

    if not comments:
        print(f"No comments found for {league_name}")
        return None

    table_html = "".join(comments)
    table_soup = BeautifulSoup(table_html, "html.parser")
    table = table_soup.find("table")

    if not table:
        print(f"No table found for {league_name}")
        return None

    headers = [th.text.strip() for th in table.find("thead").find_all("th")]
    data = []
    headers = headers[7:]
    for row in table.find("tbody").find_all("tr", class_=lambda x: x != "thead"):
        cells = row.find_all("td")
        if cells:
            data.append([cell.text.strip() for cell in cells])

    df = pd.DataFrame(data, columns=headers[1:])
    return df


def scrape_player_data(player_url):
    parts = player_url.split("/")
    url = f"https://fbref.com{'/'.join(parts[:-1])}/scout/365_m1/{parts[-1]}-Scouting-Report"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.11"
    }
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        print(f"Failed to fetch data for {url}. Got {response}")
        return -1, -1

    soup = BeautifulSoup(response.text, "html.parser")
    tables = soup.find_all("table")
    if not tables:
        print(f"No table found for {url}")
        return -1, -1
    table = tables[2]
    headers = [th.text.strip() for th in table.find("thead").find_all("th")]
    data = []
    headers = []
    for row in table.find("tbody").find_all("tr"):
        cells = row.find_all("td")
        head = row.find("th").text
        if cells:
            row_data = [cell.text.strip() for cell in cells]
            data.append(row_data[0])
            headers.append(head)
    return headers, data


def main():
    all_leagues_data = {}
    year = "2024-2025"
    for league, league_id in LEAGUES.items():
        print(f"Scraping {league} {year}...")
        df = get_league_data(league, league_id, year)
        if df is not None:
            all_leagues_data[league] = df
    # Save data
    for league, df in all_leagues_data.items():
        df.to_csv(
            f"../data/{league.replace(' ', '_')}_stats-{year}.csv", index=False)
        print(f"Saved {league} data to CSV.")


if __name__ == "__main__":
    main()
