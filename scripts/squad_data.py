
from io import StringIO
import re
import requests
import pandas as pd
from bs4 import BeautifulSoup as bs


stats_list = {'standard': 'standard', 'keepers': 'keeper', 'keepersadv': "keeper_adv", 'shooting': "shooting", 'passing': "passing", 'passing_types': "passing_types",
              'gca': "gca", 'defense': "defense", 'possession': "possession", 'playingtime': "playing_time", 'misc': "misc"}


def available_stats():
    """ Returns the available stats to scrape """
    return stats_list


def get_player_stats_from_URL(url: str, stat: str):
    """ Get player stats from FBref.com, using the given URL
    url: the url to get the stats from
    stat: the stat to get, must be one of the available stats

    returns: pandas dataframe of the stats
    """
    if stat not in stats_list.keys():
        raise ValueError(f'stat must be one of {stats_list}')

    table = _get_table_from_URL(url, stat)
    df = _get_dataframe(table.prettify())
    return df


def get_player_stats(stat: str, compid: str):
    """ Get player stats from FBref.com, URL is derived from the arguments
    stat: the stat to get, must be one of the available stats
    compid: the competition id, can be found in the url of the competition

    returns: pandas dataframe of the stats
    """

    if stat == 'standard':
        url = f'https://fbref.com/en/comps/{compid}/stats/'
    else:
        url = f'https://fbref.com/en/comps/{compid}/{stat}/'

    if compid == 'Big5':
        url += 'players/Big-5-European-Leagues-Stats/'

    df = get_player_stats_from_URL(url, stat)

    return df


def _get_table_from_URL(url, stat):
    print(f'Getting data from {url}...')
    res = requests.get(url, timeout=20)
    comm = re.compile('<!--|-->')
    soup = bs(comm.sub('', res.text), 'lxml')
    table = soup.find('table', {'id': f'stats_{stats_list[stat]}'})
    print(f'Done. {stat}')
    return table


def _get_dataframe(table):
    df = pd.read_html(StringIO(table))
    df = df[0]

    # delete the first and last column (Rk, Match)
    df = df.iloc[:, 1:-1]

    # keep only the second value for the headers
    df.columns = [h[1] for h in df.columns]

    # only keep the part after space for 'Nation'
    df['Nation'] = df['Nation'].apply(
        lambda x: str(x).rsplit(' ', maxsplit=1)[-1])

    # delete rows with the column names
    df = df[df[df.columns[0]] != df.columns[0]]
    df.reset_index(drop=True, inplace=True)

    # convert all numeric columns to numeric
    df = df.apply(pd.to_numeric, errors='ignore')

    return df


df = get_player_stats('playingtime', 'Big5')
print(df.head())
df.to_csv("data/season wise data/2024-2025/playingtime.csv")
