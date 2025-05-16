import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from glob import glob


def preprocess_data(df):
    df["Min"] = df["Min"].astype(str).str.replace(",", "").astype(float)
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    df[numeric_cols] = df[numeric_cols].fillna(df[numeric_cols].median())

    df["PrgC_90"] = df["PrgC"] / (df["Min"] / 90)
    df["PrgP_90"] = df["PrgP"] / (df["Min"] / 90)
    df["PrgR_90"] = df["PrgR"] / (df["Min"] / 90)
    df["xG_90"] = df["xG"] / (df["Min"] / 90)
    df["xAG_90"] = df["xAG"] / (df["Min"] / 90)
    df["npxG_90"] = df["npxG"] / (df["Min"] / 90)
    df["npxG+xAG_90"] = df["npxG+xAG"] / (df["Min"] / 90)

    df["Possession_Influence"] = df["PrgC_90"] + df["PrgP_90"] + df["PrgR_90"]
    df["Defensive_Contribution"] = -0.5 * df["CrdY"] - df["CrdR"]
    df["Final_Third_Impact"] = df["xG_90"] + df["xAG_90"] + df["npxG_90"]
    df["Tactical_Adaptability"] = df["npxG+xAG_90"]

    scaler = MinMaxScaler(feature_range=(0, 100))
    df[["Possession_Influence", "Defensive_Contribution", "Final_Third_Impact", "Tactical_Adaptability"]] = scaler.fit_transform(
        df[["Possession_Influence", "Defensive_Contribution",
            "Final_Third_Impact", "Tactical_Adaptability"]]
    )

    W1, W2, W3, W4 = 0.3, 0.25, 0.35, 0.10
    df["TIS"] = W1 * df["Possession_Influence"] + W2 * df["Defensive_Contribution"] + \
        W3 * df["Final_Third_Impact"] + W4 * df["Tactical_Adaptability"]

    df = df.sort_values(by="TIS", ascending=False)
    return df


def main():
    files = glob("data/position data/24-25/*.csv")
    for file in files:
        df = pd.read_csv(file)
        df = preprocess_data(df)
        small_df = df[["name", "Squad", "position", "TIS"]]
        small_df.to_csv(
            f"data/position data/TIS_24-25/TIS_{file.split("/")[-1].split(".")[0].split("_")[-1]}.csv", index=False)
        print(small_df[["name", "Squad", "position", "TIS"]].head(10))


if __name__ == "__main__":
    main()
