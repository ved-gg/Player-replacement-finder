from flask import request, jsonify, make_response
from flask import Flask
from flask_cors import CORS
from lib.fbref_searcher import scrape_fbref
from lib.report_maker import generate_report

app = Flask(__name__)
CORS(app)

@app.route('/scrape', methods=['POST'])
def scrape():
    try:
        if not request.json or 'player_name' not in request.json:
            raise ValueError("Missing 'player_name' in request data")
        player_name = request.json['player_name']
        data = scrape_fbref(player_name)
        return jsonify({"data": data})

    except Exception as e:
        return make_response(jsonify({'error': str(e)}), 400)


@app.route('/report', methods=['POST'])
def report():
    try:
        if not request.json or 'player1' not in request.json or 'player2' not in request.json:
            raise ValueError("Missing 'player1' or 'player2' in request data")
        player1 = request.json['player1']
        player2 = request.json['player2']
        report = generate_report(player1, player2)
        return jsonify({"report": report})

    except Exception as e:
        return make_response(jsonify({'error': str(e)}), 400)

@app.route('/', methods = ['GET'])
def open():
    return jsonify({"OH there you are!": "Welcome to the API"})


if __name__ == '__main__':
    app.run(debug=True)
