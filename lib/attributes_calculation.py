import pandas as pd
import numpy as np


def attributes_calculation(pos,player):
    csv_path = f"D:\\College\\Final Year Project\\Front end\\player_replacement\\assets\\data\\playerdata\\{pos}.csv"
    df = pd.read_csv(csv_path)
    df = df.fillna(0)
    player_row = df[df["name"]==player]
    if(pos=='CB'):
        cb_attributes = {
            "Defensive Actions": player_row["Defensive Actions"].values[0].item(),
            "Aerial Duels": player_row["Aerial Duels"].values[0].item(),
            "Passing and Build-up": player_row["Passing and Build-up"].values[0].item(),
            "Defensive Awareness": player_row["Defensive Awareness"].values[0].item(),
            "Discipline": player_row["Discipline"].values[0].item(),
        }
        return cb_attributes
    if(pos=='LB'):
        lb_attributes = {
            "Defensive Duties" : player_row["Defensive Duties"].values[0].item(),
            "Offensive Contributions": player_row["Offensive Contributions"].values[0].item(),
            "Final Third Play": player_row["Final Third Play"].values[0].item(),
            "Possession Play": player_row["Possession Play"].values[0].item(),
            "Dribbling": player_row["Dribbling"].values[0].item(),
        }
        return lb_attributes
    if(pos=='RB'):
        rb_attributes = {
            "Defensive Duties" : player_row["Defensive Duties"].values[0].item(),
            "Offensive Contributions": player_row["Offensive Contributions"].values[0].item(),
            "Final Third Play": player_row["Final Third Play"].values[0].item(),
            "Possession Play": player_row["Possession Play"].values[0].item(),
            "Dribbling": player_row["Dribbling"].values[0].item(),
        }  
        return rb_attributes
    elif(pos=='CDM'):
        cdm_attributes = {
            "Defensive Contributions" : player_row["Defensive Contributions"].values[0].item(),
            "Passing Ability": player_row["Passing Ability"].values[0].item(),
            "Build-Up Play" :player_row["Build-Up Play"].values[0].item(),
            "Ball Recovery": player_row["Ball Recovery & Defensive Work"].values[0].item(),
            "Line Breaking Passes": player_row["Line Breaking Passes"].values[0].item(),
        }  
        return cdm_attributes
    elif(pos=='CM'):
        cm_attributes = {
            "Passing": player_row["Passing"].values[0].item(),
            "Ball Carrying": player_row["Ball Carrying"].values[0].item(),
            "Defensive Work":player_row["Defensive Work"].values[0].item(),
            "Chance Creation": player_row["Chance Creation"].values[0].item(),
            "Possession Retention": player_row["Possession Retention"].values[0].item(),
        }
        return cm_attributes
    elif(pos=='CAM'):        
        cam_attributes = {
            "Playmaking": player_row["Playmaking"].values[0].item(),
            "Ball Progression":player_row["Ball Progression"].values[0].item(),
            "Final Third Impact": player_row["Final Third Impact"].values[0].item(),
            "Goal Threat": player_row["Goal Threat"].values[0].item(),
            "Final Ball Efficiency": player_row["Final Ball Efficiency"].values[0].item(),
        }
        return cam_attributes
    elif(pos=="LW"):
        lw_attributes = {
            "Dribbiling": player_row["Dribbling"].values[0].item(),
            "Crosses": player_row["Crosses and Playmaking"].values[0].item(),
            "Goal Threat": player_row["Goal Threat"].values[0].item(),
            "Final Third Impact": player_row["Final Third Impact"].values[0].item(),
            "Ball Carrying" : player_row["Ball Carrying"].values[0].item(),
        }
        return lw_attributes
    elif(pos=='RW'):
        rw_attributes = {
            "Dribbiling": player_row["Dribbling"].values[0].item(),
            "Crosses": player_row["Crosses and Playmaking"].values[0].item(),
            "Goal Threat": player_row["Goal Threat"].values[0].item(),
            "Final Third Impact": player_row["Final Third Impact"].values[0].item(),
            "Ball Carrying" : player_row["Ball Carrying"].values[0].item(),
        }
        return rw_attributes
    elif(pos=='CF'):
        cf_attributes = {
            "Goal Threat": player_row["Goal Threat"].values[0].item(),
            "Chance Conversion": player_row["Chance Conversion"].values[0].item(),
            "Link-Up Play": player_row["Link-Up Play"].values[0].item(),
            "Shooting Accuracy": player_row["Shooting Accuracy"].values[0].item(),
            "Penalty Box Presence": player_row["Penalty Box Presence"].values[0].item()
        }
        return cf_attributes
    elif(pos=='GK'):
        gk_attributes = {
            "Shot Stopping":player_row["Shot Stopping"].values[0].item(),
            "Expected Goals Prevented": player_row["Expected Goals Prevented"].values[0].item(),
            "Cross and Aerial Control": player_row["Cross and Aerial Control"].values[0].item(),
            "Sweeper Keeper Activity": player_row["Sweeper Keeper Activity"].values[0].item(),
            "Passing": player_row["Passing"].values[0].item()
        }
        return gk_attributes
    else:
        error = {
            "Error": "Given Position Not Found"
        }
        return error
