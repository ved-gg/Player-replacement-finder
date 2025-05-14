import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import os
import matplotlib.ticker as mticker


def plot_squad_playing_time(league_name: str, squad_name: str):
    file_path = f"../../assets/data/playerdata/Players_Leaguewise/{league_name}_players.csv"

    if not os.path.exists(file_path):
        print(f"Error: Data file not found at {file_path}")
        return

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print(f"Error reading data file {file_path}: {e}")
        return

    df_squad = df[df['Squad'] == squad_name].copy()
    if df_squad.empty:
        print(
            f"No data found for squad: {squad_name} in league: {league_name}")
        return

    required_cols = ['name', 'Min', 'age']
    if not all(col in df_squad.columns for col in required_cols):
        missing = [col for col in required_cols if col not in df_squad.columns]
        print(
            f"Required column(s) {missing} not found in the data for squad: {squad_name} in league: {league_name}")
        return

    df_squad.rename(columns={'name': 'Player',
                             'Min': 'Playing Time', 'age': "Player Age"}, inplace=True)

    max_minutes_squad = df_squad['Playing Time'].max()
    df_squad['Percentage Minutes'] = (
        df_squad['Playing Time'] / max_minutes_squad) * 100 if max_minutes_squad > 0 else 0

    df_squad['Player Age'] = pd.to_numeric(
        df_squad['Player Age'], errors='coerce')
    df_squad.dropna(subset=['Player Age'], inplace=True)

    plt.style.use('seaborn-v0_8-whitegrid')
    plt.rcParams['figure.facecolor'] = 'white'
    plt.rcParams['axes.facecolor'] = 'white'
    plt.rcParams['text.color'] = 'black'
    plt.rcParams['axes.labelcolor'] = 'black'
    plt.rcParams['xtick.color'] = 'black'
    plt.rcParams['ytick.color'] = 'black'
    plt.rcParams['grid.color'] = '#eeeeee'

    fig, ax = plt.subplots(figsize=(14, 9))

    youth_end = 24
    peak_end = 29

    ax.axvspan(youth_end, peak_end, color='#d6a4a4', alpha=0.6, zorder=0)
    ax.axvspan(peak_end, df_squad['Player Age'].max(
    ) + 2, color='#ddc88b', alpha=0.5, zorder=0)

    # something like iqr
    ax.axhline(50, color='#aaaaaa', linestyle='--', alpha=0.5)
    ax.axhline(75, color='#aaaaaa', linestyle='--', alpha=0.5)

    # Scatter plot
    sns.scatterplot(x='Player Age', y='Percentage Minutes',
                    data=df_squad, ax=ax, color='#1f77b4', edgecolor="white", s=70, zorder=5)

    # name on dot
    for index, row in df_squad.iterrows():
        ax.text(row['Player Age'] + 0.4,
                row['Percentage Minutes'] + 0.5,
                row['Player'],
                horizontalalignment='left',
                verticalalignment='center',
                size='small',
                color='black',
                fontweight='light')

    # youth peak exp
    ax.text((df_squad['Player Age'].min() + youth_end) / 2,
            50,
            'YOUTH',
            color='black', rotation=90, fontsize='xx-large', alpha=0.2,
            horizontalalignment='center', verticalalignment='center')

    ax.text((youth_end + peak_end) / 2,
            50,
            'PEAK',
            color='black', rotation=90, fontsize='xx-large', alpha=0.2,
            horizontalalignment='center', verticalalignment='center')

    ax.text((peak_end + ax.get_xlim()[1]) / 2,
            50,
            'EXPERIENCE',
            color='black', rotation=90, fontsize='xx-large', alpha=0.2,
            horizontalalignment='center', verticalalignment='center')

    max_x = ax.get_xlim()[1]
    label_offset_x = (max_x - ax.get_xlim()[0]) * 0.01

    ax.text(max_x - label_offset_x, 50, '50% of minutes',
            verticalalignment='center', horizontalalignment='right',
            color='black', size='small', fontweight='light')

    ax.text(max_x - label_offset_x, 75, '75% of minutes',
            verticalalignment='center', horizontalalignment='right',
            color='black', size='small', fontweight='light')

    # Axis and title config
    ax.set_xlabel('Age')
    ax.set_ylabel('Percentage of minutes played')

    ax.set_xlim(df_squad['Player Age'].min() - 2,
                df_squad['Player Age'].max() + 2)

    # ax.xaxis.set_major_locator(mticker.MultipleLocator(1))

    ax.set_ylim(-5, 105)

    ax.set_yticks([0, 25, 50, 75, 100])
    ax.set_yticklabels(['0%', '25%', '50%', '75%', '100%'])

    ax.grid(True, linestyle='--', alpha=0.3)
    ax.tick_params(axis='both', which='both', length=0)

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_color('black')
    ax.spines['left'].set_color('black')

    ax.text(0, 1.05, f"{squad_name}'s squad minutes in 2024-25", transform=ax.transAxes,
            fontsize='x-large', color='black', weight='bold', va='bottom', ha='left')
    ax.text(0, 1.01, f"Squad playing time | {league_name}, 2024-25", transform=ax.transAxes,
            fontsize='medium', color='black', va='bottom', ha='left')

    plt.tight_layout(rect=[0, 0, 1, 0.98])
    # plt.savefig(f'squad_playing_time_{squad_name}.png',
    #             bbox_inches='tight', facecolor='white')

    # plt.show()

    return fig

# plot_squad_playing_time_styled('La Liga', 'Real Madrid')
