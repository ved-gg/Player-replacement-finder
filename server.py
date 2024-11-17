from flask import request, jsonify, make_response
from flask import Flask
import json
import pandas as pd

from fbref_scrapper import scrape_fbref

app = Flask(__name__)


@app.route('/scrape', methods=['POST'])
def scrape():
    try:
        player_name = request.json['player_name']
        data = scrape_fbref(player_name)
        return jsonify({"data": data})

    # except KeyError as e:
    #     return make_response(jsonify({'error': f'Missing key: {e}'}), 400)
    except Exception as e:
        return make_response(jsonify({'error': str(e)}))


if __name__ == '__main__':
    app.run(debug=True)
