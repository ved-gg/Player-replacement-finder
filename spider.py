import requests
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import logging

class CustomSpider2023:

    def __init__(self):
        self.names = []
        self.numbers = []
        self.positions = []
        self.ages = []
        self.nationalities = []
        self.current_clubs = []
        self.market_values = []
        self.dobs = []        

    def get_data(self, team_url: str) -> None:
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
            "Accept-Language": "en-US,en;q=0.9",
        }

        logging.info(f"Sending request to {team_url}.")

        response = requests.get(team_url, headers = headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.content, "html.parser")

        table = soup.find("table", class_="items")
        if not table:
            logging.error("Player table not found on the page. Check if the structure has changed.")
            return 

        logging.info("Player table found on the page.")
        self.table = table        

    def convert_market_value(self, value: str) -> float:
        # Function to convert market value to float, returns value in millions
        
        if 'm' in value:
            return float(value.replace('€', '').replace('m', '').strip())
        elif 'k' in value:
            return float(value.replace('€', '').replace('k', '').strip()) / 1000
        else:
            return float(value.replace('€', '').strip())

    def scrap_data(self) -> pd.DataFrame:
        
        # Table data was split into two classes, odd and even, so we need to scrape them separately
        for table_data in self.table.find_all('tr', class_='odd'):
            
            # Test print statements
            # print(table_data.find('td')) #Get position and number of player
            # print(table_data.find_all('img', class_='bilderrahmen-fixed')) #get name of player
            # print(table_data.find_all('td', class_='zentriert')[3]) #get age/dob of player by using index 1, country by using index 2, current club by using index 3
            # print(table_data.find_all('td', class_='rechts hauptlink')) #get market value of player

           self.scrape_row(table_data)

        for table_data in self.table.find_all('tr', class_='even'):
            self.scrape_row(table_data)

        df = pd.DataFrame({
            'Number': self.numbers,
            'Name': self.names,
            'Position': self.positions,
            'Age': self.ages,
            'Date of Birth': self.dobs,
            'Market Value(in Millions)': self.market_values, 
            'Nationality': self.nationalities,
            'Current Club': self.current_clubs
            }, 
        )

        logging.info("Data scraped successfully.")
        return df
    
    def scrape_row(self, table_data) -> None:
        try: 
            player_name = table_data.find_all('img', class_='bilderrahmen-fixed')[0]['title']
            self.names.append(player_name)

            player_number_position = table_data.find_all('td')[0].get_text().strip()
            self.numbers.append(player_number_position)

            player_position = table_data.find_all('td')[1].get_text().strip().split(' ')[-1]
            self.positions.append(player_position)
            
            player_age = table_data.find_all('td', class_ = 'zentriert')[1].get_text().strip()
            date, age = player_age.rsplit("(", 1)
            self.ages.append(age.strip(')'))
            self.dobs.append(date)

            # Some players have more than one nationality so we use a for loop to get all of them and join them with a '/'
            nat = []
            for nationality in table_data.find_all('td', class_ = 'zentriert')[2].find_all('img'):
                nat.append(nationality['title'])
            self.nationalities.append(' / '.join(nat))

            club = table_data.find_all('td', class_='zentriert')[3].find('img')['alt']
            self.current_clubs.append(club)

            player_market_value = table_data.find('td', class_='rechts hauptlink').get_text().strip()
            self.market_values.append(self.convert_market_value(player_market_value))

        except Exception as e:
            logging.error(f"Error scraping row: {e}")

class FBrefSpider:
    
    def __init__(self):
        self.df = df

    def scrape_fbref(player_name: str) -> pd:
        # TODO: Get data from other tables. Also get the table name.

        first_name, last_name = player_name.split()
        player_url = f"https://fbref.com/en/search/search.fcgi?hint={first_name}+{last_name}&search={first_name}+{last_name}" 

        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
            "Accept-Language": "en-US,en;q=0.9",
        }

        response = requests.get(player_url, headers = headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.content, "html.parser")

        table = soup.find("table")
        df = pd.read_html(StringIO(str(table)))[0]
        print(df.columns)
        stats_dict = {}
        for index, row in df.iterrows():
            stats_dict[f"{row['Statistic']} (Per 90)"] = row['Per 90']
            stats_dict[f"{row['Statistic']} (Percentile)"] = row['Percentile']
        


""" 
URLS:
https://www.transfermarkt.com/real-madrid/kader/verein/418/saison_id/2023/plus/1
https://www.transfermarkt.com/fc-barcelona/kader/verein/131/saison_id/2024/plus/1
https://www.transfermarkt.com/manchester-city/kader/verein/281/saison_id/2023/plus/1

https://www.transfermarkt.com/manchester-city/kader/verein/281/saison_id/2023 -> compact table
adding '/plus/1' to the end of the url will give the full table (valid for all clubs)
"""

team_url = "https://www.transfermarkt.com/manchester-city/startseite/verein/281/saison_id/2023"

cs = CustomSpider2023()
cs.get_data(team_url)
df = cs.scrap_data()
df
