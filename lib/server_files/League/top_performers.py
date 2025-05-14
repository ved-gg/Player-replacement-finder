import pandas as pd
import numpy as np


def get_top_performers(league):
    csv_path = f"../../assets/data/{league}/{league}_TopPerformers.csv"
    df = pd.read_csv(csv_path)
    print(df)
    best_performers = {
        'Top Scorer': str(df['Top Scorer'][0]),
        'Scorer Image': str(df['Scorer Image'][0]),
        'Goals Scored': str(df['Goals Scored'][0]),
        'Top Scorer Team': str(df['Top Scorer Team'][0]),
        'Top Assister': str(df['Top Assister'][0]),
        'Assister Image': str(df['Assister Image'][0]),
        'Assists Provided': str(df['Assists Provided'][0]),
        'Top Assister Team': str(df['Top Assister Team'][0]),
        'Most Clean Sheets': str(df['Most Clean Sheets'][0]),
        'Clean Sheets Image': str(df['Clean Sheets Image'][0]),
        'Clean Sheets': str(df['Clean Sheets'][0]),
        'Most CS Team': str(df['Most CS Team'][0]),
    }
    return best_performers
