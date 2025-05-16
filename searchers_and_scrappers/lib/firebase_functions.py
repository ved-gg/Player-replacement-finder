import firebase_admin
from firebase_admin import credentials, firestore
import warnings

warnings.filterwarnings('ignore')

cred = credentials.Certificate('env/player-finder-7c285-firebase-adminsdk-jrbc9-3175df2610.json')
firebase_admin.initialize_app(cred)

store = firestore.client()
players = store.collection('players')


def get_player_data():
    try:
        docs = players.get()
        for doc in docs:
            print('Doc data: {}'.format(doc.to_dict()))
    except Exception as e:
        print('No such document! {}'.format(e))

def add_player(data: dict) -> int:
    if ((players.where('player_id', '==', data['player_id']).get()) or (players.where('player_name', '==', data['player_name']).get())):
        return 303
    players.add(data)
    print('Player added!')
    return 201

def check_exists(player_id):
    if (players.where('player_id', '==', player_id).get()):
        return True
