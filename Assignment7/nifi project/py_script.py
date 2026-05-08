import json
import os
import time
import random
from datetime import datetime

DATA_DIR = "./nifi_input"
if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)

def generate_messy_data():
    user_ids = [101, 102, 103, 104, 105, None] 
    actions = ["user", "User", "Admin", "admin", "asdf"] 
    
    data = {
        "transaction_id": random.randint(1000, 1010), 
        "user_id": random.choice(user_ids),
        "action": random.choice(actions),
        "amount": random.choice([round(random.uniform(5, 500), 2), "N/A", None]), 
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
    return data

try:
    while True:
        current_time = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
        file_name = f"Transaction_{current_time}.json"
        file_path = os.path.join(DATA_DIR, file_name)
        
        record = generate_messy_data()
        with open(file_path, 'w') as f:
            json.dump(record, f)
            
        print(f"Generated: {file_name} | Content: {record}")
        
        time.sleep(2)  
        
except KeyboardInterrupt:
    print("\nSimulation stopped by user.")