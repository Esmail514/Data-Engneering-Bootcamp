from fastapi import FastAPI
import json
import os

app = FastAPI()

DATA_FILE = '/usr/local/bin/data.json'

def load_data():
    if not os.path.exists(DATA_FILE):
        return {"error": "data.json not found", "status": "scraper has not run yet"}
    try:
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        return {"error": f"Failed to load data: {str(e)}"}

@app.get('/')
def home():
    return load_data()
