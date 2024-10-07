import requests
from bs4 import BeautifulSoup
import pandas as pd
from io import StringIO
import os

def get_player_data(player_name):

    first_name, last_name = player_name.split()
    player_page_url = f"https://fbref.com/en/search/search.fcgi?hint={first_name}+{last_name}&search={first_name}+{last_name}" 

    response = requests.get(player_page_url)

    if response.status_code != 200:
        print(f"Player '{player_name}' not found on FBref.")
        return None

    soup = BeautifulSoup(response.content, "html.parser")

    player_data = {}
    for table in soup.find_all("table", class_="min_width"):
        caption = table.find("caption")
        if caption:
            table_title = caption.text.strip()
            df = pd.read_html(StringIO(str(table)))[0]
            player_data[table_title] = df
    print(player_data) 

    personal_info = ' '
    info = soup.find("div", {"id" : "meta"})
    for p in info.find_all("p"):
         parts = [part.text.strip() for part in p.children if p.string is not True]
         personal_info += ' '.join(parts)  + '\n'  

    return player_data, personal_info

player_name = "Cristiano Ronaldo"
player_data, player_info = get_player_data(player_name)
print(player_info)

if player_data:
    if not os.path.exists(player_name):
        os.makedirs(player_name)

    for title, df in player_data.items():
        title = title.replace(":", " -").replace("/", "-").replace("\\", "-")  
        filename = f"{player_name}/{player_name}_{title}.csv"

        try:
            with open(filename, 'w', encoding='utf-8') as f:
                df.to_csv(f, sep='\t', index=False, header=True)
            print(f"Saved '{filename}' successfully!")
        except Exception as e:
            print(f"Error saving '{filename}': {e}")
else:
    print('Not found')
