import pandas as pd

# Configuration
player_name = 'Alejandro Balde'
player_pos = 'LB'

position_cols = {
    'LB': ['Min', 'Tkl', 'Int', 'Crs', 'PrgP'],
    'RB': ['Min', 'Tkl', 'Int', 'Crs', 'PrgP'],
    'CB': ['Min', 'Tkl', 'Won', 'Clr', 'Blocks', 'Int'],
    'CDM': ['Min', 'Tkl', 'Int', 'Cmp%', 'Blocks'],
    'CM': ['Min', 'Tkl', 'Cmp%', 'KP', 'PrgP', 'Int', 'xA'],
    'CAM': ['Min', 'KP', 'xA', 'Succ%', 'G+A', 'SoT', 'SCA'],
    'LW': ['Min', 'KP', 'xA', 'Succ%', 'G+A', 'SoT', 'SCA', 'PrgC', 'PrgP'],
    'RW': ['Min', 'KP', 'xA', 'Succ%', 'G+A', 'SoT', 'SCA', 'PrgC', 'PrgP'],
    'CF': ['Min', 'xG', 'SoT', 'Won', 'Gls', 'Att Pen'],
}

# Complete formation requirements using only available attributes
formation_requirements = {
    '4-4-2': {
        'style': 'balanced',
        'position_needs': {
            'LB': {'Tkl': 6, 'Int': 5, 'Crs': 6, 'PrgP': 5},
            'RB': {'Tkl': 6, 'Int': 5, 'Crs': 6, 'PrgP': 5},
            'CB': {'Tkl': 7, 'Won': 7, 'Clr': 6, 'Int': 5},
            'CM': {'Cmp%': 7, 'Tkl': 5, 'KP': 6, 'PrgP': 6},
            'LW': {'KP': 7, 'Crs': 6, 'PrgP': 5, 'G+A': 6},
            'RW': {'KP': 7, 'Crs': 6, 'PrgP': 5, 'G+A': 6},
            'CF': {'xG': 7, 'SoT': 6, 'Gls': 7, 'Att Pen': 5}
        },
        'secondary_positions': {
            'LB': ['LWB', 'CB'],
            'RB': ['RWB', 'CB'],
            'LW': ['RW', 'CAM'],
            'RW': ['LW', 'CAM'],
            'CM': ['CDM', 'CAM'],
            'CDM': ['CM', 'CB'],
            'CAM': ['CM', 'LW', 'RW', 'CF'],
            'CF': ['CAM']
        }
    },
    '4-3-3': {
        'style': 'attacking',
        'position_needs': {
            'LB': {'Tkl': 5, 'Crs': 7, 'PrgP': 6, 'Int': 4},
            'RB': {'Tkl': 5, 'Crs': 7, 'PrgP': 6, 'Int': 4},
            'CB': {'Tkl': 6, 'Won': 7, 'Clr': 6, 'Pass': 5},
            'CDM': {'Tkl': 7, 'Int': 7, 'Cmp%': 7, 'Blocks': 5},
            'CM': {'Cmp%': 8, 'KP': 7, 'PrgP': 7, 'xA': 6},
            'LW': {'KP': 8, 'PrgC': 7, 'G+A': 7, 'xA': 6},
            'RW': {'KP': 8, 'PrgC': 7, 'G+A': 7, 'xA': 6},
            'CF': {'xG': 8, 'SoT': 7, 'Gls': 8, 'Att Pen': 6}
        },
        'secondary_positions': {
            'LW': ['RW', 'CF'],
            'RW': ['LW', 'CF'],
            'CM': ['CDM', 'CAM'],
            'CDM': ['CM', 'CB'],
            'CAM': ['CM', 'CF']
        }
    },
    '4-2-3-1': {
        'style': 'possession',
        'position_needs': {
            'LB': {'Tkl': 6, 'Crs': 6, 'PrgP': 6, 'Int': 5},
            'RB': {'Tkl': 6, 'Crs': 6, 'PrgP': 6, 'Int': 5},
            'CB': {'Tkl': 6, 'Won': 7, 'Clr': 6, 'Pass': 6},
            'CDM': {'Tkl': 7, 'Int': 7, 'Cmp%': 8, 'Blocks': 5},
            'CM': {'Cmp%': 8, 'KP': 7, 'PrgP': 7, 'xA': 6},
            'CAM': {'KP': 9, 'xA': 8, 'Succ%': 7, 'SCA': 7},
            'LW': {'KP': 8, 'xA': 7, 'Succ%': 6, 'PrgP': 6},
            'RW': {'KP': 8, 'xA': 7, 'Succ%': 6, 'PrgP': 6},
            'CF': {'xG': 8, 'SoT': 7, 'Gls': 8, 'Att Pen': 6}
        },
        'secondary_positions': {
            'LW': ['RW', 'CAM'],
            'RW': ['LW', 'CAM'],
            'CM': ['CDM', 'CAM'],
            'CAM': ['CM', 'CF']
        }
    },
    '3-5-2': {
        'style': 'wingplay',
        'position_needs': {
            'CB': {'Tkl': 7, 'Won': 8, 'Clr': 7, 'Int': 6},
            'LWB': {'Tkl': 6, 'Crs': 8, 'PrgP': 7, 'Int': 5},
            'RWB': {'Tkl': 6, 'Crs': 8, 'PrgP': 7, 'Int': 5},
            'CM': {'Cmp%': 7, 'Tkl': 6, 'KP': 6, 'PrgP': 6},
            'CAM': {'KP': 8, 'xA': 7, 'Succ%': 7, 'SCA': 7},
            'CF': {'xG': 8, 'SoT': 7, 'Gls': 8, 'Att Pen': 6}
        },
        'secondary_positions': {
            'LB': ['LWB', 'CB'],
            'RB': ['RWB', 'CB'],
            'LW': ['LWB', 'CAM'],
            'RW': ['RWB', 'CAM'],
            'CM': ['CDM', 'CAM'],
            'CDM': ['CM', 'CB']
        }
    },
    '4-1-4-1': {
        'style': 'defensive',
        'position_needs': {
            'LB': {'Tkl': 7, 'Int': 6, 'Crs': 5, 'PrgP': 5},
            'RB': {'Tkl': 7, 'Int': 6, 'Crs': 5, 'PrgP': 5},
            'CB': {'Tkl': 8, 'Won': 8, 'Clr': 7, 'Int': 7},
            'CDM': {'Tkl': 8, 'Int': 8, 'Cmp%': 7, 'Blocks': 6},
            'CM': {'Cmp%': 7, 'Tkl': 6, 'KP': 5, 'PrgP': 6},
            'LW': {'KP': 6, 'PrgP': 6, 'Tkl': 5, 'Int': 4},
            'RW': {'KP': 6, 'PrgP': 6, 'Tkl': 5, 'Int': 4},
            'CF': {'xG': 7, 'SoT': 6, 'Gls': 7, 'Att Pen': 5}
        },
        'secondary_positions': {
            'LW': ['RW', 'CM'],
            'RW': ['LW', 'CM'],
            'CM': ['CDM', 'CAM'],
            'CAM': ['CM', 'CF']
        }
    },
    '3-4-3': {
        'style': 'counter',
        'position_needs': {
            'CB': {'Tkl': 7, 'Won': 7, 'Clr': 7, 'Int': 6},
            'CM': {'Cmp%': 7, 'Tkl': 6, 'KP': 6, 'PrgP': 7},
            'LW': {'PrgC': 8, 'G+A': 7, 'SoT': 6, 'Succ%': 6},
            'RW': {'PrgC': 8, 'G+A': 7, 'SoT': 6, 'Succ%': 6},
            'CF': {'xG': 8, 'SoT': 7, 'Gls': 8, 'Att Pen': 6}
        },
        'secondary_positions': {
            'LB': ['CB'],
            'RB': ['CB'],
            'LW': ['RW', 'CF'],
            'RW': ['LW', 'CF'],
            'CAM': ['CM', 'CF'],
            'CDM': ['CM', 'CB']
        }
    },
    '5-3-2': {
        'style': 'ultra_defensive',
        'position_needs': {
            'CB': {'Tkl': 8, 'Won': 8, 'Clr': 8, 'Int': 7},
            'LWB': {'Tkl': 7, 'Int': 6, 'Crs': 6, 'PrgP': 5},
            'RWB': {'Tkl': 7, 'Int': 6, 'Crs': 6, 'PrgP': 5},
            'CM': {'Cmp%': 7, 'Tkl': 7, 'KP': 5, 'PrgP': 5},
            'CF': {'xG': 7, 'SoT': 6, 'Gls': 7, 'Att Pen': 5}
        },
        'secondary_positions': {
            'LB': ['LWB', 'CB'],
            'RB': ['RWB', 'CB'],
            'LW': ['LWB', 'CF'],
            'RW': ['RWB', 'CF'],
            'CDM': ['CM', 'CB'],
            'CAM': ['CM', 'CF']
        }
    }
}


def load_data(player_name, player_pos):
    """Load player data from CSV"""
    df = pd.read_csv(f'./assets/data/playerdata/{player_pos}.csv')
    return df[df['name'] == player_name].iloc[0] if player_name in df['name'].values else None


def normalize_stat(value, stat_name):
    """Normalize different stats appropriately"""
    if stat_name in ['Cmp%', 'Succ%']:
        return min(10, value / 10)  # Percentage stats
    elif stat_name in ['Tkl', 'Int', 'Blocks']:
        return min(10, value / 2)    # Defensive actions per game
    elif stat_name in ['KP', 'Crs']:
        return min(10, value / 3)    # Creative actions per game
    elif stat_name in ['G+A', 'SoT']:
        return min(10, value)       # Direct goal contributions
    else:
        return min(10, value / 5)   # Catch-all for other stats


def evaluate_position_fit(player_stats, requirements):
    """Evaluate how well player fits position requirements"""
    score = 0
    max_score = sum(requirements.values())
    missing_attrs = []
    strong_attrs = []

    for attr, req_score in requirements.items():
        player_val = player_stats.get(attr, 0)
        if player_val >= req_score * 0.9:
            strong_attrs.append(attr)
        elif player_val < req_score * 0.7:
            missing_attrs.append((attr, req_score))
        score += min(player_val, req_score)

    # Convert to 0-10 scale
    final_score = (score / max_score) * 10

    # Generate explanation
    explanation_parts = []
    if strong_attrs:
        explanation_parts.append(f"Excels in {', '.join(strong_attrs)}")
    else:
        explanation_parts.append("Meets basic requirements")

    if missing_attrs:
        missing_str = ", ".join(
            [f"{attr} ({req} needed)" for attr, req in missing_attrs])
        explanation_parts.append(f"needs improvement in {missing_str}")

    return round(final_score, 1), " ".join(explanation_parts)


def analyze_formations(player_data, player_pos):
    """Analyze player's fit across all formations"""
    results = []

    # Normalize player stats
    player_stats = {
        col: normalize_stat(player_data[col], col)
        for col in position_cols[player_pos]
        if col != 'Min' and col in player_data
    }

    for formation, data in formation_requirements.items():
        primary_pos = player_pos if player_pos in data['position_needs'] else None
        secondary_pos = data['secondary_positions'].get(player_pos, [])

        if primary_pos:
            # Evaluate primary position
            score, explanation = evaluate_position_fit(
                player_stats,
                data['position_needs'][primary_pos]
            )
            position_played = primary_pos
        elif secondary_pos:
            # Evaluate best secondary position
            best_score = 0
            best_explanation = ""
            for pos in secondary_pos:
                if pos in data['position_needs']:
                    score, explanation = evaluate_position_fit(
                        player_stats,
                        data['position_needs'][pos]
                    )
                    score *= 0.8  # 20% penalty for secondary position
                    if score > best_score:
                        best_score = score
                        best_explanation = f"As {pos}: {explanation}"
                        position_played = pos
            score, explanation = best_score, best_explanation
        else:
            score, explanation = 0, "No suitable position"
            position_played = None

        results.append({
            'formation': formation,
            'score': score,
            'position': position_played,
            'explanation': explanation,
            'style': data['style']
        })

    return sorted(results, key=lambda x: x['score'], reverse=True)


def print_results(results, player_name):
    """Display formatted results"""
    print(f"\nFormation Fit Analysis for {player_name}")
    print("=" * 85)
    print(f"{'Formation':<10} {'Score':<6} {'Style':<15} {'Position':<10} {'Explanation':<40}")
    print("-" * 85)

    for res in results:
        if res['score'] > 0:
            print(f"{res['formation']:<10} {res['score']:<6.1f} {res['style']:<15} "
                  f"{res['position'] or '-':<10} {res['explanation']:<40}")


def formation_fitness_score(player_name, player_pos):
    player_data = load_data(player_name, player_pos)
    if player_data is not None:
        results = analyze_formations(player_data, player_pos)
        print_results(results, player_name)
    else:
        print(f"Player {player_name} not found in position {player_pos} data")
    return results
