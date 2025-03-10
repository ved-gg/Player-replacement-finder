from flask import request, jsonify, make_response
from flask import Flask
from flask_cors import CORS
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from standings_getter import standings_getter
from standings_getter import fetch_top_performers
from plot_data import attack_vs_defence
from plot_data import defensive_solidity



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


@app.route('/report', methods=['POST'])
def report():
    try:
        player1 = request.json['player1']
        player2 = request.json['player2']
        report = generate_report(player1, player2)
        print(report)
        return jsonify({"report": report})
    
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))

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
        data = fetch_top_performers(league)
        return jsonify({"data": data})
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))
    
@app.route('/attack_vs_defence_charts_data', methods=["GET"])
def attack_vs_defensive_chart_data():
    try:
        league = request.headers.get('league')
        data = attack_vs_defence(league)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'error':str(e)}))
    
@app.route('/defensive_solidity',methods=["GET"])
def defensive_solidity_chart_data():
    try:
        league = request.headers.get("league")
        data = defensive_solidity(league)
        return jsonify(data)
    except Exception as e:
        return make_response(jsonify({'error':str(e)}))

if __name__ == '__main__':
    app.run(debug=True)