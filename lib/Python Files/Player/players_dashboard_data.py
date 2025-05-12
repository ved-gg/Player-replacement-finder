from flask import jsonify
import numpy as np
import pandas as pd

position_columns = {
    'LB': ['90s','TklW','Int','Crs','PrgP','Blocks','Clr','Recov','Def Pen','Def 3rd_possession','Mid 3rd_possession','Att 3rd_possession','Att Pen','SCA','Final Third','KP'],
    'RB': ['90s','TklW','Int','Crs','PrgP','Blocks','Clr','Recov','Def Pen','Def 3rd_possession','Mid 3rd_possession','Att 3rd_possession','Att Pen','SCA','Final Third','KP'],
    'CB': ['Tkl','TklW','Won','Clr','Blocks','Int','PrgP','Cmp','Cmp.3','90s','Lost','Cmp%'],
    'CDM': ['90s','Tkl','Int','Cmp','Blocks','Recov','Cmp.1','Cmp.2','Cmp.3','Final Third','PrgP','PrgC','1/3_possession'], 
    'CM': ['90s','Tkl','Cmp','KP','PrgP','Int','xA','Final Third','PrgC','Sh','SCA','Touches','1/3_possession'],
    'CAM': ['90s','KP','xA','Succ','G+A','SoT','SCA'],
    'LW': ['90s','KP','xA','Succ','G+A','SoT','SCA','PrgC','PrgP'],
    'RW': ['90s','KP','xA','Succ','G+A','SoT','SCA','PrgC','PrgP'],
    'CF': ['90s','xG','SoT','Won','Gls','Att Pen','PrgP','Cmp','Final Third','KP','SCA','1/3_possession'],
}

def send_dashboard_data(position, player_name):
    df = pd.read_csv(f'assets/data/playerdata/{position}.csv')
    player_df = df.loc[df["name"] == player_name, position_columns[position]]
    if(position == "CB"):
        player_df['Cmp.3Per90'] = player_df['Cmp.3']/100
        player_df["Aerial Duels"] = (player_df["Won"]+player_df["Lost"])
        player_df["Aerial Duels Per 90"] = (player_df["Won"]+player_df["Lost"])/player_df["90s"]
        player_df["Aerial Duels Won Per 90"] = player_df["Won"]/player_df["90s"]
        player_df["PrgP Per 90"] = player_df["PrgP"]/player_df["90s"]
        player_data = player_df.iloc[0].to_dict() 
        return player_data
    else:
        for col in position_columns[position]:
            if col == '90s':
                continue
            player_df[col] = player_df[col]/player_df["90s"]
        print(player_df)
        player_data = player_df.iloc[0].to_dict() 
        return player_data

    
# send_dashboard_data("CB", "William Saliba")