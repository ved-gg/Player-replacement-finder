import traceback
from flask import request, jsonify, make_response
from flask import Flask
from flask_cors import CORS
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from League.standings_getter import standings_getter
# from standings_getter import fetch_top_performers
from League.leagues_plot_data import attack_vs_defence
from League.leagues_plot_data import defensive_solidity
from Player.attributes_calculation import attributes_calculation
from League.top_performers import get_top_performers
from Player.formation_fit_analysis import analyze_formations, formation_fitness_score, load_data
from Player.players_dashboard_data import send_dashboard_data


app = Flask(__name__)
CORS(app)


@app.route('/scrape', methods=['POST'])
def scrape():
    try:
        player_name = request.json['player_name']
        data = scrape_fbref(player_name)
        return jsonify({"data": data})

    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


# @app.route('/report', methods=['POST'])
# def report():
#     try:
#         player1 = request.json['player1']
#         player2 = request.json['player2']
#         report = generate_report(player1, player2)
#         print(report)
#         return jsonify({"report": report})

#     except Exception as e:
#         return make_response(jsonify({'error': str(e)}))

@app.route('/standings', methods=['GET'])
def standings():
    try:
        league = request.headers.get('league')
        data = standings_getter(league)
        return jsonify(data)

    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


@app.route('/top_performers', methods=['GET'])
def top_performers():
    try:
        league = request.headers.get('league')
        data = get_top_performers(league)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


@app.route('/attack_vs_defence_charts_data', methods=["GET"])
def attack_vs_defensive_chart_data():
    try:
        league = request.headers.get('league')
        data = attack_vs_defence(league)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


@app.route('/defensive_solidity', methods=["GET"])
def defensive_solidity_chart_data():
    try:
        league = request.headers.get("league")
        data = defensive_solidity(league)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


@app.route('/player_attributes', methods=["GET"])
def get_player_attributes():
    try:
        pos = request.headers.get("position")
        player = request.headers.get("player")
        data = attributes_calculation(pos, player)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'Error': str(e)}))


@app.route('/fitness_score', methods=["GET"])
def get_formation_fitness_score():
    try:
        player_name = request.headers.get("player")
        player_pos = request.headers.get("position")
        if not player_name or not player_pos:
            return make_response(jsonify({'error': 'Missing player name or position in headers'}), 400)

        def load_data(player_name, player_pos):
            try:
                df = pd.read_csv(f'./assets/data/playerdata/{player_pos}.csv')
                # Reset index to ensure alignment
                df = df.reset_index(drop=True)
                # Case-insensitive comparison and exact match
                match = df[df['name'].str.lower() == player_name.lower()]
                return match.iloc[0] if not match.empty else None
            except Exception as e:
                print(f"Error loading data: {str(e)}")
                return None

        player_data = load_data(player_name, player_pos)
        if player_data is None:
            return make_response(jsonify({
                'error': f'Player {player_name} not found in position {player_pos} data',
                'available_players': list(pd.read_csv(f'./assets/data/playerdata/{player_pos}.csv')['name'])
            }), 404)
        if not isinstance(player_data, pd.Series):
            return make_response(jsonify({'error': 'Data loading format incorrect'}), 500)
        results = analyze_formations(player_data, player_pos)
        formatted_results = []
        for res in results:
            if res['score'] > 0:
                formatted_results.append({
                    'formation': res['formation'],
                    'score': float(res['score']),
                    'style': res['style'],
                    'position': res['position'],
                    'explanation': res['explanation']
                })

        return jsonify({
            'player': player_name,
            'position': player_pos,
            'results': formatted_results
        })

    except Exception as e:
        return make_response(jsonify({
            'error': str(e),
            'traceback': traceback.format_exc()
        }), 500)


@app.route('/player_dashboard_data', methods=["GET"])
def player_dashboard():
    try:
        pos = request.headers.get("position")
        player = request.headers.get("player")
        data = send_dashboard_data(pos, player)
        print(data)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'Error': str(e)}))


if __name__ == '__main__':
    app.run(debug=True)
