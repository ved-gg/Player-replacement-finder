import pandas as pd
import os

# Path to the folder containing all position CSVs
input_folder = "D:\\College\\Final Year Project\\Front end\\player_replacement\\assets\\data\\playerdata"
output_folder = "D:\\College\\Final Year Project\\Front end\\player_replacement\\assets\\data\\playerdata\\Players_Leaguewise"

# List of position CSV filenames
positions = ["CB", "LB", "RB", "CDM", "CAM", "CM", "LW", "RW", "CF", "GK"]

# League mapping and empty DataFrames for each
leagues = {
    "fr  Ligue 1": pd.DataFrame(),
    "eng  Premier League": pd.DataFrame(),
    "it  Serie A": pd.DataFrame(),
    "de  Bundesliga": pd.DataFrame(),
    "es  La Liga": pd.DataFrame()
}

# Iterate over all position files
for pos in positions:
    csv_path = os.path.join(input_folder, f"{pos}.csv")
    df = pd.read_csv(csv_path)

    for league in leagues.keys():
        league_df = df[df["Comp"] == league]
        leagues[league] = pd.concat([leagues[league], league_df], ignore_index=True)

# Save each league DataFrame to its own CSV file
for league, league_df in leagues.items():
    league_name = league.split(' ', 1)[1]   # extract "Ligue", "Premier", etc.
    output_path = os.path.join(output_folder, f"{league_name}_players.csv")
    league_df.to_csv(output_path, index=False)

print("Players segregated and saved by league.")
