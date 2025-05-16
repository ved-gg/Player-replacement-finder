# import json
# from urllib.request import urlopen, Request
# import pandas as pd
# from bs4 import BeautifulSoup
# import time


# def scrape(player_url):
#     parts = player_url.split("/")
#     url = f"https://fbref.com{'/'.join(parts[:-1])}/all_comps/{parts[-1]}-Stats---All-Competitions"
#     # print(url)
#     headers = {
#         "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.11"
#     }

#     req = Request(url, headers=headers)

#     try:
#         response = urlopen(req)
#     except:
#         print(
#             f"Failed to fetch data for {url}")
#         return -1

#     if response.status_code != 200:
#         print(f"Failed to fetch data for {url}. Got {response}")
#         return -1

#     soup = BeautifulSoup(response.text, "html.parser")
#     # print(soup)
#     tables = soup.find_all("table")
#     if not tables:
#         print(f"No table found for {url}")
#         return -1, -1

#     # Standard Stats
#     def get_stats(table):
#         # print(table.caption.text)
#         tr = table.find("tfoot").find_all("tr")[1]
#         headers = [d.text for d in tr.find_all("th")]
#         data = []
#         row = table.find("tfoot").find("tr")
#         seasons = row.find("th")
#         stats = [d.text for d in row.find_all("td")]
#         combined_data = {"header": headers, "stats": stats}
#         return combined_data

#     data = {}
#     for i, table in enumerate(tables[1:]):
#         if table.caption.text not in data:
#             try:
#                 data[table.caption.text] = get_stats(table)
#             except:
#                 break
#     return data


# all_data = {}
# df = pd.read_csv("data/urls-Ligue-1.csv")
# for i, url in enumerate(df["urls"]):
#     print(i)
#     time.sleep(6)
#     data = scrape(url)
#     if data == -1:
#         continue
#     all_data[url.split("/")[-1]] = data

# # Save data
# with open("data/ligue_1_data.json", "w") as f:
#     json.dump(all_data, f)
# print("Data saved!")


from io import StringIO
import re
import requests
import pandas as pd
from bs4 import BeautifulSoup as bs
import time
import warnings
import os
import glob

warnings.filterwarnings('ignore')

stats_list = ('standard', 'goalkeeping', 'advanced goalkeeping', 'shooting', 'passing', 'pass types',
              'goal and shot creation', 'defensive actions', 'possession', 'playing time', 'miscellaneous stats')


def available_stats():
    """ Returns the available stats to scrape """
    return stats_list


def get_player_stats_from_URL(url: str, stat: str):
    """ Get player stats from FBref.com, using the given URL
    url: the url to get the stats from
    stat: the stat to get, must be one of the available stats

    returns: pandas dataframe of the stats
    """
    if stat not in stats_list:
        raise ValueError(f'stat must be one of {stats_list}')

    table, row = _get_table_from_URL(url, stat)
    df = _get_dataframe(table, row)
    return df


def _get_table_from_URL(url, stat):
    print(f'Getting data from {url}...')
    res = requests.get(url, timeout=10)
    comm = re.compile('<!--|-->')
    soup = bs(comm.sub('', res.text))
    table = soup.find('div', {'id': f'all_stats_{stat}'}).find("table")
    tbod = table.find("tbody").find_all("tr")
    print(len(tbod))
    print('Done.')
    # print(table)
    return table.prettify(), len(tbod)


def get_all_player_stats_from_URL(url: str):
    """ Get player stats from FBref.com, using the given URL

    url: the url to get the stats from 
    returns: pandas dataframe of the stats
    """
    tables = _gel_all_tables_from_URL(url)
    if tables == -1:
        return -1
    dfs = {}
    for table in tables:
        if table.caption.text.lower().split(":")[0] not in stats_list:
            continue
        df = _get_dataframe(table.prettify(), len(
            table.find("tbody").find_all("tr")), url.split("/")[-1])
        dfs[table.caption.text.lower().split(":")[0]] = df
    # print(f"Processed {url.split("/")[-1]}.")
    return dfs


def _gel_all_tables_from_URL(url):
    try:
        res = requests.get(url, timeout=20)
    except requests.ReadTimeout as e:
        print(f"ReadTimeout: {e}")
        time.sleep(10)
        return _gel_all_tables_from_URL(url)
    comm = re.compile('<!--|-->')
    soup = bs(comm.sub('', res.text))
    tables = soup.find_all('table', {'class': 'stats_table'})
    if not tables:
        print("No tables found for {}. Got error - {}".format(url, res.status_code))
        return -1
    return tables


def _get_dataframe(table, row, name):
    df = pd.read_html(StringIO(table))
    df = df[0]

    # delete the last column (Rk, Match)
    df = df.iloc[:, :-1]

    # keep only the second value for the headers

    df.columns = [h[1] for h in df.columns]

    # only keep the part after space for 'Nation'
    df['Country'] = df['Country'].apply(
        lambda x: str(x).rsplit(' ', maxsplit=1)[-1])

    # delete rows with the column names
    df = df[df[df.columns[0]] != df.columns[0]]
    df.reset_index(drop=True, inplace=True)
    df.drop(["Age", "Squad", "Country", "Comp", "LgRank"], axis=1, inplace=True)

    # convert all numeric columns to numeric
    df = df.apply(pd.to_numeric, errors='ignore')
    df = df.iloc[[row]]
    df.insert(0, "Player Name", name)

    return df
