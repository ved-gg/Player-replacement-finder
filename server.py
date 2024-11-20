from flask import request, jsonify, make_response
from flask import Flask
from flask_cors import CORS
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from report_maker import generate_report

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
        return jsonify({"report": report})

    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


if __name__ == '__main__':
    app.run(debug=True)
