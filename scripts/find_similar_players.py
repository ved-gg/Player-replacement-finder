from glob import glob
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.impute import SimpleImputer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.preprocessing import StandardScaler

numeric_columns = [
    "Age", "MP", "Starts", "Min", "90s", "Gls", "Ast", "G+A", "G-PK", "PK", "PKatt",
    "CrdY", "CrdR", "xG", "npxG", "xAG", "npxG+xAG", "PrgC", "PrgP", "PrgR"
]


def recommend_similar_players_by_position(player_name, df, df_scaled):
    player_row = df[df["Player"] == player_name]
    if player_row.empty:
        return f"Player '{player_name}' not found in dataset."

    player_pos = player_row["Pos"].values[0]
    df_filtered = df[df["Pos"] == player_pos].reset_index(drop=True)
    df_scaled_filtered = df_scaled.loc[df_filtered.index]
    player_index = df_filtered[df_filtered["Player"] == player_name].index[0]
    cosine_sim = cosine_similarity(df_scaled_filtered)
    player_similarities = cosine_sim[player_index]

    similarity_df = pd.DataFrame(
        {"Player": df_filtered["Player"], "Similarity": player_similarities})
    similarity_df = similarity_df[similarity_df["Player"] != player_name]
    similarity_df = similarity_df.sort_values(by="Similarity", ascending=False)
    return similarity_df


def find_similar_players(player_name, df, df_scaled, top_n=10):
    if player_name not in df["Player"].values:
        return f"❌ Player '{player_name}' not found in dataset."

    player_row = df[df["Player"] == player_name]
    player_cluster = player_row["Cluster"].values[0]
    player_pos = player_row["Pos"].values[0]
    df_filtered = df[(df["Cluster"] == player_cluster) & (
        df["Pos"] == player_pos)].reset_index(drop=True)
    df_scaled_filtered = df_scaled.loc[df_filtered.index]
    cosine_sim = cosine_similarity(df_scaled_filtered)
    player_index = df_filtered[df_filtered["Player"] == player_name].index[0]
    player_similarities = cosine_sim[player_index]

    similarity_df = pd.DataFrame(
        {"Player": df_filtered["Player"], "Similarity": player_similarities})
    similarity_df = similarity_df[similarity_df["Player"] != player_name]
    similarity_df = similarity_df.sort_values(by="Similarity", ascending=False)
    return similarity_df.head(top_n)


def combine_data():
    files = [f for f in glob("data/*.csv")]
    final_df = pd.concat([pd.read_csv(file)
                         for file in files], ignore_index=True)
    final_df = final_df.drop_duplicates()
    final_df.to_csv("data/similar.csv", index=False)
    return final_df


def preprocess_data(df):
    df[numeric_columns] = df[numeric_columns].apply(
        pd.to_numeric, errors="coerce")
    for col in df.columns:
        df[col] = pd.to_numeric(df[col], errors="ignore")
    imputer = SimpleImputer(strategy="mean")
    df[numeric_columns] = imputer.fit_transform(df[numeric_columns])
    df = df.drop(["Nation"], axis=1)
    return df


def main():
    player_name = "Harry Kane"
    df = combine_data()
    df = preprocess_data(df)
    num_clusters = 10
    kmeans = KMeans(n_clusters=num_clusters, random_state=42, n_init=10)
    scaler = StandardScaler()
    df_scaled = pd.DataFrame(scaler.fit_transform(
        df[numeric_columns]), columns=numeric_columns)
    df["Cluster"] = kmeans.fit_predict(df_scaled)
    recommended_players = find_similar_players(player_name, df, df_scaled)
    print(f"Players similar to {player_name}:\n")
    print(recommended_players[:10])
    print(df["Pos"].unique())


if __name__ == "__main__":
    main()
