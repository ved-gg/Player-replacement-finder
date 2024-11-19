from flask import request, jsonify, make_response
from flask import Flask
from flask_cors import CORS, cross_origin
import json
import pandas as pd

from fbref_searcher import scrape_fbref
from report_maker import generate_report

app = Flask(__name__)
CORS(app)


@app.route('/scrape', methods=['POST'])
def scrape():
    try:
        if request.json is None:
            return make_response(jsonify({'error': 'Invalid JSON payload'}), 400)
        player_name = request.json.get('player_name')
        if not player_name:
            return make_response(jsonify({'error': 'player_name is required'}), 400)
        data = scrape_fbref(player_name)
        return jsonify({"data": data})

    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


def generate_report(player1, player2):
    report = generate_report(player1, player2)
    return report


if __name__ == '__main__':
    app.run(debug=True)
