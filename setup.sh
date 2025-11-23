#!/usr/bin/env bash
set -euo pipefail

# Create venv and install deps
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "---------------------------------------"
echo "Place Kaggle Titanic 'train.csv' as data/raw_dataset.csv"
echo "Then run: jupyter lab"
