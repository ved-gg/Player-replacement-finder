from fastapi import jsonify
import pandas as pd
import numpy as np


def attack_vs_defence(league):
    attack_vs_defence_data = {}
    try:
        standings = pd.read_csv(
            f"../../assets/data/{league}/{league}_Standings.csv")
        matches_played = np.array(standings["MP"])
        goals_scored = np.array(standings["GF"])
        goals_per_match = goals_scored/matches_played
        goals_conceded = np.array(standings["GA"])
        goals_conceded_per_match = goals_conceded/matches_played
        for i in range(len(standings["Rk"])):
            attack_vs_defence_data[standings["Squad"][i]] = {
                "Goals Per Game": goals_per_match[i], "Goals Conceded Per Game": goals_conceded_per_match[i]}
        return attack_vs_defence_data
    except Exception as e:
        print("Something Went Wrong:", e)


def defensive_solidity(league):
    defensive_solidity_data = {}
    try:
        defensive_actions = pd.read_csv(
            f"../../assets/data/{league}/{league}_Squad_Defensive_Actions.csv")
        defensive_actions.columns = defensive_actions.iloc[0]
        defensive_actions = defensive_actions[1:].reset_index(drop=True)
        nineties = np.array(defensive_actions["90s"])
        col_list = defensive_actions.columns.tolist()
        first_tkl_index = col_list.index("Tkl")
        tackles = np.array(defensive_actions.iloc[:, first_tkl_index])
        tackles_won = np.array(defensive_actions["TklW"])
        for i in range(len(nineties)):
            nineties[i] = float(nineties[i])
            tackles[i] = float(tackles[i])
            tackles_won[i] = float(tackles_won[i])
        tackles_p90 = tackles/nineties
        tackles_won_p90 = tackles_won/nineties
        for i in range(len(defensive_actions["Squad"])):
            defensive_solidity_data[defensive_actions["Squad"][i]] = {
                "Tackles Per 90": tackles_p90[i], "Tackles Won Per 90": tackles_won_p90[i]}
        return defensive_solidity_data
    except Exception as e:
        print("Something went wrong:", e)


# defensive_solidity("La Liga")
