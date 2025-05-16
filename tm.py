import pandas as pd
import requests

# Base URL of your local server
base_url = "http://localhost:8000"


def get_competition_id(competition_name):
    url = f"{base_url}/competitions/search/{competition_name}"
    response = requests.get(url)
    # print("COmp id response: ", response.json())
    if response.status_code == 200:
        return response.json().get("results")[0].get("id")
    else:
        print(f"Error fetching competition data: {response.status_code}")
        return None


def get_clubs(competition_id):
    url = f"{base_url}/competitions/{competition_id}/clubs"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()  # Assuming the response contains a list of clubs
    else:
        print(f"Error fetching clubs data: {response.status_code}")
        return None


def get_players(club_id):
    url = f"{base_url}/clubs/{club_id}/players"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()  # Assuming the response contains a list of players
    else:
        print(f"Error fetching players data: {response.status_code}")
        return None


def get_player_profile(player_id):
    url = f"{base_url}/players/{player_id}/profile"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()  # Assuming the response contains player profile data
    else:
        print(f"Error fetching player profile: {response.status_code}")
        return None


def get_player_market_value(player_id):
    url = f"{base_url}/players/{player_id}/market_value"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()  # Assuming the response contains market value data
    else:
        print(f"Error fetching player market value: {response.status_code}")
        return None


def main():
    for name in ["Serie A", "Premier League", "La Liga", "Bundesliga", "Ligue 1"]:
        competition_name = name 
        competition_id = get_competition_id(competition_name)
        player_data = []
        if competition_id:
            print(f"Competition ID: {competition_id}")

            clubs = get_clubs(competition_id)
            if clubs:
                # print(f"Clubs: {clubs}")
                club_ids = []
                for club in clubs.get("clubs"):
                    # club_ids.append(club['id'])
                    players = get_players(club["id"])
                    if players:
                        for player in players.get("players"):
                            player_data.append(player)

                df = pd.DataFrame(player_data)
                print(df)
                df.to_csv(f"data/tm data/2024-2025/{name}.csv")


        else:
            print("No comp id")


if __name__ == "__main__":
    main()
