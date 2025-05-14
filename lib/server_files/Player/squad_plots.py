import numpy as np
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import os
import matplotlib.ticker as mticker


def set_plot_style():
    plt.style.use('seaborn-v0_8-whitegrid')
    plt.rcParams['figure.facecolor'] = 'white'
    plt.rcParams['axes.facecolor'] = 'white'
    plt.rcParams['text.color'] = 'black'
    plt.rcParams['axes.labelcolor'] = 'black'
    plt.rcParams['xtick.color'] = 'black'
    plt.rcParams['ytick.color'] = 'black'
    plt.rcParams['grid.color'] = '#eeeeee'
    plt.rcParams['font.family'] = 'sans-serif'
    # Or your preferred sans-serif font
    plt.rcParams['font.sans-serif'] = ['Arial', 'DejaVu Sans']


set_plot_style()


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
            color='black', rotation=90, fontsize='40', alpha=0.1,
            horizontalalignment='center', verticalalignment='center')

    ax.text((youth_end + peak_end) / 2,
            50,
            'PEAK',
            color='black', rotation=90, fontsize='40', alpha=0.1,
            horizontalalignment='center', verticalalignment='center')

    ax.text((peak_end + ax.get_xlim()[1]) / 2,
            50,
            'EXPERIENCE',
            color='black', rotation=90, fontsize='40', alpha=0.1,
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
    ax.text(-0.1, 1.01, f"Squad playing time | {league_name}, 2024-25", transform=ax.transAxes,
            fontsize='medium', color='black', va='bottom', ha='left')

    plt.tight_layout(rect=[0, 0, 1, 0.98])

    return fig


def plot_league_possession_style(league_name: str, squad_name_to_highlight: str = None):

    file_path = f"../../assets/data/playerdata/Players_Leaguewise/{league_name}_players.csv"

    if not os.path.exists(file_path):
        print(f"Error: Data file not found at {file_path}")
        return None

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print(f"Error reading data file {file_path}: {e}")
        return None

    required_cols = ['Squad', '90s', 'Att_passing', 'Cmp.1']
    if not all(col in df.columns for col in required_cols):
        missing = [col for col in required_cols if col not in df.columns]
        print(
            f"Required column(s) {missing} not found in the data for league: {league_name}. Available columns: {list(df.columns)}")
        return None

    df_teams = df.groupby('Squad').agg(
        Total_90s=('90s', 'sum'),
        Total_Att_Passing=('Att_passing', 'sum'),
        Total_Cmp_Passing=('Cmp.1', 'sum')
    ).reset_index()

    df_teams = df_teams[(df_teams['Total_90s'] > 100) & (
        df_teams['Total_Att_Passing'] > 0)].copy()

    if df_teams.empty:
        print(
            f"Not enough aggregated team data for league: {league_name} after filtering.")
        return None

    df_teams['Att_Passing_Per_90'] = df_teams['Total_Att_Passing'] / \
        df_teams['Total_90s']
    df_teams['Cmp_Percent'] = (
        df_teams['Total_Cmp_Passing'] / df_teams['Total_Att_Passing']) * 100

    set_plot_style()
    fig, ax = plt.subplots(figsize=(14, 9))

    sns.scatterplot(x='Att_Passing_Per_90', y='Cmp_Percent', data=df_teams, ax=ax,
                    color='#cccccc', alpha=0.8, s=100, edgecolor="white", label='Other Teams')

    if squad_name_to_highlight and squad_name_to_highlight in df_teams['Squad'].values:
        df_highlight = df_teams[df_teams['Squad'] == squad_name_to_highlight]
        sns.scatterplot(x='Att_Passing_Per_90', y='Cmp_Percent', data=df_highlight, ax=ax,
                        color='#ff7f0e', s=200, edgecolor="black", linewidth=1.5, zorder=5, label=squad_name_to_highlight)
        ax.text(df_highlight['Att_Passing_Per_90'].iloc[0] + 2,
                df_highlight['Cmp_Percent'].iloc[0],
                squad_name_to_highlight,
                horizontalalignment='left',
                verticalalignment='center',
                size='small',
                color='black',
                weight='bold')

    avg_att_passing_per_90 = df_teams['Att_Passing_Per_90'].mean()
    avg_cmp_percent = df_teams['Cmp_Percent'].mean()

    ax.axvline(avg_att_passing_per_90, color='#aaaaaa',
               linestyle='--', alpha=0.5, label='League Avg Att Pass/90')
    ax.axhline(avg_cmp_percent, color='#aaaaaa', linestyle='--',
               alpha=0.5, label='League Avg Cmp%')

    ax.set_xlabel('Passes Attempted per 90 (Team Total)')
    ax.set_ylabel('Pass Completion Percentage (%)')

    ax.set_title(f"{league_name} Teams: Passing Volume vs. Completion %",
                 fontsize='x-large', color='black', weight='bold')
    year_range = "2024-25"
    ax.text(-0.1, 1.01, f"Team Totals | {league_name}, {year_range}", transform=ax.transAxes,
            fontsize='medium', color='black', va='bottom', ha='left')

    if squad_name_to_highlight and squad_name_to_highlight in df_teams['Squad'].values:
        current_xlim = ax.get_xlim()
        highlight_x = df_teams[df_teams['Squad'] ==
                               squad_name_to_highlight]['Att_Passing_Per_90'].iloc[0]
        if highlight_x + 2 > current_xlim[1]:
            ax.set_xlim(current_xlim[0], highlight_x + 5)

    ax.grid(True, linestyle='--', alpha=0.3)
    ax.tick_params(axis='both', which='both', length=0)
    ax.spines[['top', 'right']].set_visible(False)
    ax.spines[['bottom', 'left']].set_color('black')

    ax.legend(loc='upper left', bbox_to_anchor=(1, 1), frameon=False)

    plt.tight_layout(rect=[0, 0, 0.85, 0.98])

    return fig


def plot_league_xg_comparison(league_name: str, squad_name_to_highlight: str = None):
    file_path = f"../../assets/data/playerdata/Players_Leaguewise/{league_name}_players.csv"

    if not os.path.exists(file_path):
        print(f"Error: Data file not found at {file_path}")
        return None

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print(f"Error reading data file {file_path}: {e}")
        return None

    required_cols = ['Squad', 'xG', 'onxGA', '90s']
    if not all(col in df.columns for col in required_cols):
        missing = [col for col in required_cols if col not in df.columns]
        print(
            f"Required column(s) {missing} not found in the data for league: {league_name}. Available columns: {list(df.columns)}")
        return None

    for col in ['xG', 'onxGA', '90s']:
        df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0)

    df_teams = df.groupby('Squad').agg(
        Total_xG=('xG', 'sum'),
        Total_xGA=('onxGA', 'sum'),
        Total_90s=('90s', 'sum')
    ).reset_index()

    df_teams = df_teams[df_teams['Total_90s'] > 100].copy()

    if df_teams.empty:
        print(
            f"Not enough aggregated team data for league: {league_name} after filtering.")
        return None

    avg_total_xG = df_teams['Total_xG'].mean()
    avg_total_xGA = df_teams['Total_xGA'].mean()

    fig, ax = plt.subplots(figsize=(14, 9))

    df_other_teams = df_teams[df_teams['Squad']
                              != squad_name_to_highlight].copy()
    sns.scatterplot(x='Total_xG', y='Total_xGA', data=df_other_teams, ax=ax,
                    color='#cccccc', alpha=0.8, s=100, edgecolor="white", label='Other Teams')

    df_highlight = df_teams[df_teams['Squad'] == squad_name_to_highlight]
    if squad_name_to_highlight and not df_highlight.empty:
        sns.scatterplot(x='Total_xG', y='Total_xGA', data=df_highlight, ax=ax,
                        color='#ff7f0e', s=200, edgecolor="black", linewidth=1.5, zorder=5, label=squad_name_to_highlight)

    text_offset_x = (df_teams['Total_xG'].max() -
                     df_teams['Total_xG'].min()) * 0.005
    text_offset_y = (df_teams['Total_xGA'].max(
    ) - df_teams['Total_xGA'].min()) * 0.005

    for index, row in df_teams.iterrows():
        squad = row['Squad']
        x_pos = row['Total_xG']
        y_pos = row['Total_xGA']
        text_weight = 'bold' if squad == squad_name_to_highlight else 'light'
        text_color = 'black'
        ax.text(x_pos + text_offset_x,
                y_pos + text_offset_y,
                squad,
                horizontalalignment='left',
                verticalalignment='bottom',
                size='xx-small',
                color=text_color,
                fontweight=text_weight)

    ax.axvline(avg_total_xG, color='#aaaaaa', linestyle='--',
               alpha=0.5, label='League Avg Total xG')
    ax.axhline(avg_total_xGA, color='#aaaaaa', linestyle='--',
               alpha=0.5, label='League Avg Total xGA')

    min_x_plot, max_x_plot = ax.get_xlim()
    min_y_plot, max_y_plot = ax.get_ylim()

    ax.text(max_x_plot * 0.98, avg_total_xGA, 'Good Defense', va='bottom',
            ha='right', color='#555555', fontsize='small', alpha=0.7)
    ax.text(min_x_plot * 1.02, avg_total_xGA, 'Poor Defense', va='bottom',
            ha='left', color='#555555', fontsize='small', alpha=0.7)
    ax.text(avg_total_xG, max_y_plot * 0.98, 'Good Offense', va='top',
            ha='left', color='#555555', fontsize='small', alpha=0.7, rotation=90)
    ax.text(avg_total_xG, min_y_plot * 1.02, 'Poor Offense', va='bottom',
            ha='left', color='#555555', fontsize='small', alpha=0.7, rotation=90)

    ax.set_xlabel('Total Expected Goals (xG For)')
    ax.set_ylabel('Total Expected Goals Against (xGA)')

    ax.set_title(f"{league_name} Teams: Offensive vs. Defensive xG",
                 fontsize='x-large', color='black', weight='bold')
    year_range = "2024-25"
    ax.text(0, 1.01, f"Team Totals | {league_name}, {year_range}", transform=ax.transAxes,
            fontsize='medium', color='black', va='bottom', ha='left')

    min_x_data, max_x_data = df_teams['Total_xG'].min(
    ), df_teams['Total_xG'].max()
    min_y_data, max_y_data = df_teams['Total_xGA'].min(
    ), df_teams['Total_xGA'].max()

    padding_x = (max_x_data - min_x_data) * 0.05
    padding_y = (max_y_data - min_y_data) * 0.05

    ax.set_xlim(min_x_data - padding_x, max_x_data + padding_x +
                text_offset_x * 5)
    ax.set_ylim(min_y_data - padding_y, max_y_data + padding_y +
                text_offset_y * 5)

    ax.grid(True, linestyle='--', alpha=0.3)
    ax.tick_params(axis='both', which='both', length=0)
    ax.spines[['top', 'right']].set_visible(False)
    ax.spines[['bottom', 'left']].set_color('black')

    ax.legend(loc='upper left', bbox_to_anchor=(1.02, 1), frameon=False)

    plt.tight_layout(rect=[0, 0, 0.85, 0.98])

    return fig

def plot_squad_top_performers_bar(league_name: str, squad_name: str, metric_col: str = "xG.1", metric_label: str = "xG Per 90", min_90s: int = 5):
    file_path = f"../../assets/data/playerdata/Players_Leaguewise/{league_name}_players.csv"

    if not os.path.exists(file_path):
        print(f"Error: Data file not found at {file_path}")
        return None

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print(f"Error reading data file {file_path}: {e}")
        return None

    df_squad = df[df['Squad'] == squad_name].copy()
    if df_squad.empty:
        print(f"No data found for squad: {squad_name} in league: {league_name}")
        return None

    required_cols = {'name', 'Squad', '90s'}
    calculation_type = None

    if metric_col == 'xG.1 + xAG.1':
        required_cols.update(['xG.1', 'xAG.1'])
        calculation_type = 'calc_sum_per_90'
    elif metric_col == 'Tkl + Int':
        required_cols.update(['Tkl', 'Int'])
        calculation_type = 'calc_div_90s'
    elif metric_col == 'Gls + Ast':
        required_cols.update(['Gls', 'Ast'])
        calculation_type = 'calc_div_90s'
    elif metric_col == 'G-PK + Ast':
        required_cols.update(['G-PK', 'Ast'])
        calculation_type = 'calc_div_90s'
    elif metric_col == 'xG + xAG':
        required_cols.update(['xG', 'xAG'])
        calculation_type = 'calc_div_90s'

    direct_per_90_metrics = {
        'GA90', 'Save%.1', 'PPM', '+/-90', 'xG+/-90', 'SCA90', 'GCA90',
        'PSxG+/-/90', '#OPA/90', 'Sh/90', 'SoT/90', 'G/Sh', 'G/SoT',
        'npxG/Sh', 'G-xG', 'np:G-xG', 'PSxG/SoT', 'Cmp%_keepersadv', 'Launch%',
        'AvgLen', 'Launch%.1', 'AvgLen.1', 'Stp%', '#OPA/90', 'AvgDist',
        'Succ%', 'Gls.1', 'Ast.1', 'G+A.1', 'G-PK.1', 'G+A-PK',
        'xG.1', 'xAG.1', 'xG+xAG', 'npxG.1', 'npxG+xAG.1'
    }
    if metric_col in direct_per_90_metrics:
        required_cols.add(metric_col)
        calculation_type = 'direct_per_90'

    needs_div_90s_metrics = {
        'Gls', 'Ast', 'G+A', 'G-PK', 'G+A-PK',
        'xG', 'xAG', 'npxG',
        'PrgP', 'PrgC', 'KP', 'SCA', 'GCA', 'Touches',
        'Att_passing', 'Cmp_passing', 'Tkl', 'Int', 'Clr',
        'Sh_shooting', 'SoT', 'Recov', 'Won', 'Lost', 'Blocks',
        'Compl', 'Subs', 'UnSub',
        'CrdY', 'CrdR', '2CrdY', 'Fls', 'Fld', 'Off', 'Crs', 'PKwon', 'PKcon',
        'Carries', 'TotDist_possession', 'PrgDist_possession', '1/3_possession',
        'CPA', 'Mis', 'Dis', 'Rec', 'Att_possession', 'Succ', 'Tkld', 'Tkld%'
    }
    if metric_col in needs_div_90s_metrics:
        required_cols.add(metric_col)
        calculation_type = 'calc_div_90s'

    if calculation_type is None:
        print(f"Metric '{metric_col}' not recognized for calculation logic.")
        print(f"Supported metrics: {list(direct_per_90_metrics | needs_div_90s_metrics)} and calculated metrics ('xG.1 + xAG.1', 'Tkl + Int', 'Gls + Ast', 'G-PK + Ast', 'xG + xAG')")
        return None

    if not all(col in df_squad.columns for col in required_cols):
        missing = [col for col in required_cols if col not in df_squad.columns]
        print(f"Required column(s) {missing} not found for metric '{metric_label}' in data for squad: {squad_name}. Available columns: {list(df_squad.columns)}")
        return None

    numeric_cols_for_calc = [col for col in required_cols if col not in ['name', 'Squad']]
    for col in numeric_cols_for_calc:
        df_squad[col] = pd.to_numeric(df_squad[col], errors='coerce').fillna(0)

    try:
        if calculation_type == 'calc_sum_per_90':
            if metric_col == 'xG.1 + xAG.1':
                df_squad['Calculated_Metric'] = df_squad['xG.1'] + df_squad['xAG.1']
            elif metric_col == 'Gls + Ast':
                df_squad['Calculated_Metric'] = df_squad['Gls.1'] + df_squad['Ast.1']
            elif metric_col == 'G-PK + Ast':
                df_squad['Calculated_Metric'] = df_squad['G-PK.1'] + df_squad['Ast.1']
            elif metric_col == 'xG + xAG':
                df_squad['Calculated_Metric'] = df_squad['xG.1'] + df_squad['xAG.1']
        elif calculation_type == 'calc_div_90s':
            if metric_col == 'Tkl + Int':
                df_squad['Calculated_Metric'] = (df_squad['Tkl'] + df_squad['Int']) / df_squad['90s']
            elif metric_col == 'Gls + Ast':
                df_squad['Calculated_Metric'] = (df_squad['Gls'] + df_squad['Ast']) / df_squad['90s']
            elif metric_col == 'G-PK + Ast':
                df_squad['Calculated_Metric'] = (df_squad['G-PK'] + df_squad['Ast']) / df_squad['90s']
            elif metric_col == 'xG + xAG':
                df_squad['Calculated_Metric'] = (df_squad['xG'] + df_squad['xAG']) / df_squad['90s']
            else:
                df_squad['Calculated_Metric'] = df_squad[metric_col] / df_squad['90s']
            df_squad['Calculated_Metric'] = df_squad['Calculated_Metric'].replace([np.inf, -np.inf], np.nan)
        elif calculation_type == 'direct_per_90':
            df_squad['Calculated_Metric'] = df_squad[metric_col]
    except Exception as e:
        print(f"Error during metric calculation for '{metric_col}': {e}")
        return None

    df_squad_filtered = df_squad[df_squad['90s'] >= min_90s].copy()
    df_squad_filtered = df_squad_filtered.dropna(subset=['Calculated_Metric'])

    if df_squad_filtered.empty:
        print(f"No players with at least {min_90s} 90s and valid data for metric '{metric_label}' found for squad: {squad_name}")
        return None

    sort_ascending = metric_col in ['GA90', 'AvgLen', 'AvgLen.1', 'AvgDist', 'Err', 'OG', 'Dis']
    df_squad_sorted = df_squad_filtered.sort_values('Calculated_Metric', ascending=sort_ascending)

    if sort_ascending:
        df_squad_sorted = df_squad_sorted.iloc[::-1]

    max_players_to_show = 25
    if len(df_squad_sorted) > max_players_to_show:
        df_squad_sorted = df_squad_sorted.head(max_players_to_show)

    fig, ax = plt.subplots(figsize=(12, max(6, len(df_squad_sorted) * 0.4)))

    cmap = 'coolwarm' if df_squad_sorted['Calculated_Metric'].min() < 0 or df_squad_sorted['Calculated_Metric'].max() < 0 else 'viridis'

    sns.barplot(x='Calculated_Metric', y='name', data=df_squad_sorted, ax=ax, palette=cmap, orient='h')

    for i, (value, name) in enumerate(zip(df_squad_sorted['Calculated_Metric'], df_squad_sorted['name'])):
        ha_align = 'left' if value >= 0 else 'right'
        offset = (ax.get_xlim()[1] - ax.get_xlim()[0]) * 0.005 * np.sign(value) if value != 0 else (ax.get_xlim()[1] - ax.get_xlim()[0]) * 0.005
        text_x_pos = value + offset
        text_color = 'black'
        if value >= 0 and text_x_pos > ax.get_xlim()[1]:
            text_x_pos = ax.get_xlim()[1]
            ha_align = 'right'
        elif value < 0 and text_x_pos < ax.get_xlim()[0]:
            text_x_pos = ax.get_xlim()[0]
            ha_align = 'left'
        ax.text(text_x_pos, i, f'{value:.2f}', va='center', ha=ha_align, fontsize='small', color=text_color, weight='semibold')

    ax.set_xlabel(metric_label)
    ax.set_ylabel('Player')

    ax.set_title(f"{squad_name}'s Top Players by {metric_label}", fontsize='x-large', color='black', weight='bold')
    year_range = "2024-25"
    ax.text(0, 1.01, f"Min. {min_90s} 90s | {league_name}, {year_range}", transform=ax.transAxes, fontsize='medium', color='black', va='bottom', ha='left')

    ax.grid(axis='x', linestyle='--', alpha=0.3)
    ax.tick_params(axis='both', which='both', length=0)
    ax.spines[['top', 'right']].set_visible(False)
    ax.spines[['bottom', 'left']].set_color('black')

    ax.set_yticklabels(df_squad_sorted['name'])
    ax.tick_params(axis='y', which='both', length=0, pad=5)

    min_val, max_val = df_squad_sorted['Calculated_Metric'].min(), df_squad_sorted['Calculated_Metric'].max()

    if min_val < 0 or max_val < 0:
        x_min = min(0, min_val - abs(min_val) * 0.1)
        x_max = max(0, max_val + abs(max_val) * 0.1)
    else:
        x_min = 0
        x_max = max_val + max_val * 0.1

    ax.set_xlim(x_min, x_max)

    plt.tight_layout()

    return fig


def plot_squad_shot_quality_volume_scatter(league_name: str, squad_name: str, min_90s: int = 5, min_shots: int = 5):
    """
    Plots player Shots per 90 vs. xG per Shot for a specific squad.

    Args:
        league_name (str): The name of the league.
        squad_name (str): The name of the squad to plot.
        min_90s (int): Minimum 90s played for a player to be included.
        min_shots (int): Minimum total shots for a player to be included.

    Returns:
        matplotlib.figure.Figure: The figure object, or None if data not found or invalid.
    """
    file_path = f"../../assets/data/playerdata/Players_Leaguewise/{league_name}_players.csv"

    if not os.path.exists(file_path):
        print(f"Error: Data file not found at {file_path}")
        return None

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print(f"Error reading data file {file_path}: {e}")
        return None

    df_squad = df[df['Squad'] == squad_name].copy()
    if df_squad.empty:
        print(
            f"No data found for squad: {squad_name} in league: {league_name}")
        return None

    required_cols = ['name', '90s', 'Sh_shooting', 'xG']
    if not all(col in df_squad.columns for col in required_cols):
        missing = [col for col in required_cols if col not in df_squad.columns]
        print(
            f"Required column(s) {missing} not found in the data for squad: {squad_name}. Available columns: {list(df_squad.columns)}")
        return None

    df_squad_filtered = df_squad[(df_squad['90s'] >= min_90s) & (
        df_squad['Sh_shooting'] >= min_shots)].copy()
    if df_squad_filtered.empty:
        print(
            f"No players with at least {min_90s} 90s AND {min_shots} shots found for squad: {squad_name}")
        return None

    df_squad_filtered['Sh_per_90'] = df_squad_filtered['Sh_shooting'] / \
        df_squad_filtered['90s']
    df_squad_filtered['xG_per_Shot'] = df_squad_filtered['xG'] / \
        df_squad_filtered['Sh_shooting']

    set_plot_style()
    fig, ax = plt.subplots(figsize=(14, 9))

    sns.scatterplot(x='Sh_per_90', y='xG_per_Shot', data=df_squad_filtered, ax=ax,
                    color='#1f77b4', edgecolor="white", s=100, zorder=5)

    for index, row in df_squad_filtered.iterrows():
        ax.text(row['Sh_per_90'],
                row['xG_per_Shot'] +
                (ax.get_ylim()[1] - ax.get_ylim()[0]) * 0.01,
                row['name'],
                horizontalalignment='center',
                verticalalignment='bottom',
                size='small',
                color='black',
                fontweight='semibold')

    avg_sh_per_90 = df_squad_filtered['Sh_per_90'].mean()
    avg_xg_per_shot = df_squad_filtered['xG_per_Shot'].mean()

    ax.axvline(avg_sh_per_90, color='#aaaaaa', linestyle='--',
               alpha=0.5, label=f'{squad_name} Avg Sh/90')
    ax.axhline(avg_xg_per_shot, color='#aaaaaa', linestyle='--',
               alpha=0.5, label=f'{squad_name} Avg xG/Shot')

    ax.text(ax.get_xlim()[1], avg_xg_per_shot, 'High Quality', va='bottom',
            ha='right', color='#555555', fontsize='small', alpha=0.7)
    ax.text(ax.get_xlim()[0], avg_xg_per_shot, 'Low Quality', va='bottom',
            ha='left', color='#555555', fontsize='small', alpha=0.7)
    ax.text(avg_sh_per_90, ax.get_ylim()[1], 'High Volume', va='top',
            ha='left', color='#555555', fontsize='small', alpha=0.7, rotation=90)
    ax.text(avg_sh_per_90, ax.get_ylim()[0], 'Low Volume', va='bottom',
            ha='left', color='#555555', fontsize='small', alpha=0.7, rotation=90)

    ax.set_xlabel('Shots Attempted per 90')
    ax.set_ylabel('Expected Goals per Shot (xG/Shot)')

    ax.set_title(f"{squad_name} Players: Shot Volume vs. Quality",
                 fontsize='x-large', color='black', weight='bold')
    year_range = "2024-25"
    ax.text(-0.1, 1.01, f"Min. {min_90s} 90s, {min_shots} Shots | {league_name}, {year_range}", transform=ax.transAxes,
            fontsize='medium', color='black', va='bottom', ha='left')

    current_ylim = ax.get_ylim()
    ax.set_ylim(current_ylim[0], current_ylim[1] +
                (current_ylim[1] - current_ylim[0]) * 0.05)

    ax.grid(True, linestyle='--', alpha=0.3)
    ax.tick_params(axis='both', which='both', length=0)
    ax.spines[['top', 'right']].set_visible(False)
    ax.spines[['bottom', 'left']].set_color('black')

    ax.legend(loc='upper left', bbox_to_anchor=(1, 1), frameon=False)

    plt.tight_layout(rect=[0, 0, 0.85, 0.98])

    return fig
