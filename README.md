# Football Transfer Fees

## Overview

This project analyzes football player data to calculate a Tactical Impact Score (TIS) and find similar players. Additionally, it predicts player prices using data from Transfermarkt and league statistics.

## Directory Structure

```
/home/vedant/football-transfer-fees/
├── data/
│   ├── combined.csv
│   ├── urls-Ligue-1.csv
│   └── TIS_results.csv
│   ├── tm-Premier-League.csv
│   ├── tm-La-Liga.csv
│   ├── tm-Bundesliga.csv
│   ├── tm-Serie-A.csv
│   ├── tm-Ligue-1.csv
│   └── predicted_prices.csv
├── models/
│   ├── tis_model.pkl
│   └── scaler.pkl
│   ├── price_model.pkl
│   └── price_scaler.pkl
├── scripts/
│   ├── scrape_fbref.py
│   ├── process_data.py
│   ├── calculate_tis.py
│   ├── find_similar_players.py
│   ├── train_tis_model.py
│   └── predict_tis.py
│   └── train_and_predict_price.py
├── notebooks/
│   └── player_tables.ipynb
├── app/
│   └── main.py
├── README.md
├── tm.py
└── tempCodeRunnerFile.py
```

## Setup

1. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

2. Run the scripts to scrape data, process it, and calculate TIS.

## Running the FastAPI Application

1. Navigate to the `app` directory:

   ```bash
   cd app
   ```

2. Start the FastAPI application:

   ```bash
   uvicorn main:app --reload
   ```

3. Access the API documentation at `http://127.0.0.1:8000/docs`.

## Available Endpoints

- `GET /`: Welcome message.
- `POST /run/{script_name}`: Run a specific script.
- `GET /scripts`: List all available scripts.

## Training the TIS Model

1. Train the model:

   ```bash
   python scripts/train_tis_model.py
   ```

2. The trained model and scaler will be saved in the `models` directory.

## Predicting TIS

1. Predict TIS using the trained model:

   ```bash
   python scripts/predict_tis.py
   ```

2. The predicted TIS scores will be saved in the `data` directory as `predicted_tis.csv`.

## Training and Predicting Player Prices

1. Train the model:

   ```bash
   python scripts/train_and_predict_price.py train
   ```

2. Predict player prices using the trained model:

   ```bash
   python scripts/train_and_predict_price.py predict
   ```

3. The predicted player prices will be saved in the `data` directory as `predicted_prices.csv`.

## Project Structure

## Notebooks

- [player_tables.ipynb](http://_vscodecontentref_/6): Analysis and processing of player data.

## Tests

- Run tests using:
  ```sh
  pytest tests/
  ```

This structure and organization will help you manage your project more efficiently.
