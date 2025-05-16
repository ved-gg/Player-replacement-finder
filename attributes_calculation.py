import pandas as pd
import numpy as np


def attributes_calculation(pos, player):
    csv_path = f"data/position data/24-25/{pos}.csv"
    df = pd.read_csv(csv_path)
    df = df.fillna(0)
    name = np.array(df["name"])
    # print(name)
    player_row = df[df["name"] == player]
    print(f"Player row: {player_row.name}")
    if (pos == 'CB'):
        # Defensive Actions
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Actions"] = (
            tackles+interceptions+blocks+clearances+recoveries)/90
        # Aerial Duels
        df["Aerial Duels"] = np.array(df["Won%"])/90
        # Passing and Build-up Play
        key_passes = np.array(df["KP"])
        pass_cmp = np.array(df["Cmp%"])
        df["Passing and Build-up"] = (key_passes+pass_cmp)/90
        # Positioning and Defensive Awarness
        df["Defensive Awareness"] = (clearances+blocks)/90
        # Defensive Contributions
        yellow_cards = np.array(df["CrdY"])
        second_yellow_card = np.array(df["2CrdY"])
        red_cards = np.array(df["CrdR"])
        fouls = np.array(df["Fls"])
        df["Discipline"] = (yellow_cards+second_yellow_card+red_cards+fouls)/90
        player_row = df[df["name"] == player]
        cb_attributes = {
            "Defensive Actions": player_row["Defensive Actions"].values[0].item(),
            "Aerial Duels": player_row["Aerial Duels"].values[0].item(),
            "Passing and Build-up": player_row["Passing and Build-up"].values[0].item(),
            "Defensive Awareness": player_row["Defensive Awareness"].values[0].item(),
            "Discipline": player_row["Discipline"].values[0].item(),
        }
        print(f"cb_attributes: {cb_attributes}")
        return cb_attributes
    if (pos == 'LB' or pos == 'RB'):
        # Defensive Duties
        tackles_Def_3rd = np.array(df["Def 3rd"])
        interceptions = np.array(df["Int"])
        df["Defensive Duties"] = (tackles_Def_3rd+interceptions)/90
        # Offensive Contribution
        prg_carries = np.array(df["PrgC"])
        prg_passes = np.array(df["PrgP"])
        key_passes = np.array(df["KP"])
        xA = np.array(df["xA"])
        df["Offensive Contributions"] = (
            prg_carries+prg_passes+xA+key_passes)/90
        # Final Third Play
        crosses_attempted = np.array(df["Crs"])
        shot_creating_actions = np.array(df["SCA"])
        carries_penalty_area = np.array(df["CPA"])
        df["Final Third Play"] = (
            crosses_attempted+shot_creating_actions+carries_penalty_area)/90
        # Possession Play
        TAtt3rd = np.array(df["Att 3rd_possession"])
        carry_distance = np.array(df["TotDist"])
        df["Possession Play"] = (TAtt3rd+carry_distance)/90
        # Dribbling and Transition Play
        successful_take_ons = np.array(df["Succ"])
        df["Dribbling"] = successful_take_ons/90
        if (pos == "LB"):
            lb_attributes = {
                "Defensive Duties": list(df["Defensive Duties"]),
                "Offensive Contributions": list(df["Offensive Contributions"]),
                "Final Third Play": list(df["Final Third Play"]),
                "Possession Play": list(df["Possession Play"]),
                "Dribbling": list(df["Dribbling"]),
            }
            return lb_attributes
        else:
            rb_attributes = {
                "Defensive Duties": list(df["Defensive Duties"]),
                "Offensive Contributions": list(df["Offensive Contributions"]),
                "Final Third Play": list(df["Final Third Play"]),
                "Possession Play": list(df["Possession Play"]),
                "Dribbling": list(df["Dribbling"]),
            }
            return rb_attributes
    if (pos == 'CDM'):
        # Defensive Contributions
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Contributions"] = (
            tackles+interceptions+blocks+clearances+recoveries)/90
        # Passing Ability
        pass_cmp = np.array(df["Cmp%"])
        df["Passing Ability"] = pass_cmp/90
        # Build-up Play
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        npxG = np.array(df["npxG"])
        df["Build-Up Play"] = (xA+xAG+npxG)/90
        # Ball Recovery and Defensive Work
        recoveries = np.array(df["Recov"])
        interceptions = np.array(df["Int"])
        df["Ball Recovery & Defensive Work"] = (recoveries+interceptions)/90
        # Defensive Line Breaking Passes
        prg_passes = np.array(df["PrgP"])
        key_passes = np.array(df["KP"])
        passes_final_third = np.array(df["1/3_passing"])
        df["Line Breaking Passes"] = (
            key_passes+prg_passes+passes_final_third)/90
        cdm_attributes = {
            "Defensive Contributions": list(df["Defensive Contributions"]),
            "Passing Ability": list(df["Passing Ability"]),
            "Build-Up Play": list(df["Build-Up Play"]),
            "Ball Recovery": list(df["Ball Recovery & Defensive Work"]),
            "Line Breaking Passes": list(df["Line Breaking Passes"]),
        }
        return cdm_attributes
    if (pos == "CM"):
        # Passing and Vision
        prg_passes = np.array(df["PrgP"])
        passes_final_third = np.array(df["1/3_passing"])
        df["Passing"] = (prg_passes+passes_final_third)/90
        # Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Ball Carrying"] = (successful_take_ons+prg_carries+cpa)/90
        # Defensive Work
        tackles = np.array(df["Tkl"])
        interceptions = np.array(df["Int"])
        blocks = np.array(df["Blocks"])
        clearances = np.array(df["Clr"])
        recoveries = np.array(df["Recov"])
        df["Defensive Work"] = (tackles+interceptions +
                                blocks+clearances+recoveries)/90
        # Chance Creation
        sca = np.array(df["SCA"])
        xG = np.array(df["xG"])
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        df["Chance Creation"] = (sca+xG+xA+xAG)/90
        # Possession Retention
        pass_cmp = np.array(df["Cmp"])
        key_passes = np.array(df["KP"])
        passes_final_third = np.array(df["1/3_passing"])
        successful_take_ons = np.array(df["Succ"])
        df["Possession Retention"] = (
            pass_cmp+key_passes+passes_final_third+successful_take_ons)/90
        cdm_attributes = {
            "Passing": list(df["Passing"]),
            "Ball Carrying": list(df["Ball Carrying"]),
            "Defensive Work": list(df["Defensive Work"]),
            "Chance Creation": list(df["Chance Creation"]),
            "Possession Retention": list(df["Possession Play"]),
        }
        return cdm_attributes
    if (pos == "CAM"):
        # Creativity and Playmaking
        xA = np.array(df["xA"])
        sca = np.array(df["SCA"])
        passes_final_third = np.array(df["1/3_passing"])
        df["Playmaking"] = (xA+sca+passes_final_third)/90
        # Ball Progression
        prg_carries = np.array(df["PrgC"])
        prg_passes = np.array(df["PrgP"])
        df["Ball Progression"] = (prg_passes+prg_carries)/90
        # Final Third Impact
        TAtt3rd = np.array(df["Att 3rd_possession"])
        cpa = np.array(df["CPA"])
        ppa = np.array(df["PPA"])
        df["Final Third Impact"] = (TAtt3rd+cpa+ppa)/90
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/90
        # Final Ball Efficiency
        passes_final_third = np.array(df["1/3_possession"])
        ppa = np.array(df['PPA'])
        df["Final Ball Efficiency"] = (passes_final_third+ppa)/90
        cam_attributes = {
            "Playmaking": list(df["Playmaking"]),
            "Ball Progression": list(df["Ball Progression"]),
            "Final Third Impact": list(df["Final Third Impact"]),
            "Goal Threat": list(df["Goal Threat"]),
            "Final Ball Efficiency": list(df["Final Ball Efficiency"]),
        }
        return cam_attributes
    if (pos == "LW" or pos == "RW"):
        # Dribbling and Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Dribbling"] = (successful_take_ons+prg_carries+cpa)/90
        # Crossing and Playmaking
        xA = np.array(df["xA"])
        xAG = np.array(df["xAG"])
        crosses_attempted = np.array(df["Crs"])
        df["Crosses and Playmaking"] = (xA+xAG+crosses_attempted)/90
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/90
        # Final Third Involvement
        TAtt3rd = np.array(df["Att 3rd_possession"])
        cpa = np.array(df["CPA"])
        ppa = np.array(df["PPA"])
        df["Final Third Impact"] = (TAtt3rd+cpa+ppa)/90
        # Ball Carrying
        successful_take_ons = np.array(df["Succ"])
        prg_carries = np.array(df["PrgC"])
        cpa = np.array(df["CPA"])
        df["Ball Carrying"] = (successful_take_ons+prg_carries+cpa)/90
        if (pos == 'LW'):
            lw_attributes = {
                "Dribbiling": list(df["Dribbling"]),
                "Crosses": list(df["Crosses and Playmaking"]),
                "Goal Threat": list(df["Goal Threat"]),
                "Final Third Impact": list(df["Final Third Impact"]),
                "Ball Carrying": list(df["Ball Carrying"]),
            }
            return lw_attributes
        else:
            rw_attributes = {
                "Dribbiling": list(df["Dribbling"]),
                "Crosses": list(df["Crosses and Playmaking"]),
                "Goal Threat": list(df["Goal Threat"]),
                "Final Third Impact": list(df["Final Third Impact"]),
                "Ball Carrying": list(df["Ball Carrying"]),
            }
            return rw_attributes
    if (pos == 'CF'):
        # Goal Threat
        xG = np.array(df["xG"])
        npxG = np.array(df["npxG"])
        goal = np.array(df["Gls"])
        df["Goal Threat"] = (xG+npxG+goal)/90
        # Chance Conversion
        npGoals = np.array(df["G-PK"])/90
        xG = np.array(df["xG"])/90
        df["Chance Conversion"] = npGoals/xG
        # Link-up Play
        prg_received = np.array(df["PrgR"])
        passes_final_third = np.array(df["1/3_possession"])
        xA = np.array(df["xA"])
        ppa = np.array(df["PPA"])
        df["Link-Up Play"] = (prg_received+xA+ppa)/90
        # Shooting Accuracy
        SoT = np.array(df["SoT/90"])
        shots = np.array(df["Sh/90"])
        df["Shooting Accuracy"] = SoT+shots
        # Penalty Box Presence
        TAttPen = np.array(df["Att Pen"])
        df["Penalty Box Presence"] = TAttPen/90
        cf_attributes = {
            "Goal Threat": list(df["Goal Threat"]),
            "Chance Conversion": list(df["Chance Conversion"]),
            "Link-Up Play": list(df["Link-Up Play"]),
            "Shooting Accuracy": list(df["Shooting Accuracy"]),
            "Penalty Box Presence": list(df["Penalty Box Presence"])
        }
        return cf_attributes
    if (pos == "GK"):
        # Shot Stopping Ability
        saves = np.array(df["Saves"])
        df["Shot Stopping"] = saves/90
        # Expected Goals Prevented
        psxG = np.array(df["PSxG"]/90)
        ga = np.array(df["GA"]/90)
        df["Expected Goals Prevented"] = psxG-ga
        # Cross and Aerial Control
        crosses_stopped = np.array(df["Stp"])
        df["Cross and Aerial Control"] = crosses_stopped/90
        # Sweeper Keeper Activity
        sweeper = np.array(df["#OPA/90"])
        df["Sweeper Keeper Activity"] = sweeper
        # Passing and Distribution
        passes_cmp = np.array(df["Cmp"])
        df["Passing"] = passes_cmp/90
        gk_attributes = {
            "Shot Stopping": list(df["Shot Stopping"]),
            "Expected Goals Prevented": list(df["Expected Goals Prevented"]),
            "Cross and Aerial Control": list(df["Cross and Aerial Control"]),
            "Sweeper Keeper Activity": list(df["Sweeper Keeper Activity"]),
            "Passing": list(df["Passing"]),
        }
        return gk_attributes
    df.to_csv(csv_path, index=False)


attributes_calculation('CB', 'Abakar Sylla')
