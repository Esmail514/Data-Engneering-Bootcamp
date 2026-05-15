import csv
import time
import random
from datetime import datetime
import os

OUTPUT_DIRECTORY = "mobile_logs_input"

if not os.path.exists(OUTPUT_DIRECTORY):
    os.makedirs(OUTPUT_DIRECTORY)

previous_logs = []

def generate_log():

    log_id = random.randint(1000, 9999)

    device_id = random.choice([
        "SM-G991",
        "IPHONE-13",
        "PIXEL-6",
        "SM-A52",
        "ONEPLUS-11"
    ])

    log_level = random.choice([
        "INFO",
        "DEBUG",
        "WARNING",
        "ERROR"
    ])

    event_name = random.choice([
        "app_open",
        "login_attempt",
        "api_call",
        "button_click",
        "logout",
        "purchase",
        "notification_click"
    ])

    response_time = random.randint(10, 1500)

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    r = random.random()

    # ===== 60% CLEAN =====
    if r < 0.60:
        return [log_id, device_id, log_level, event_name, response_time, timestamp]

    # ===== 40% MESSY TOTAL =====

    elif r < 0.70:  # missing values (10%)
        device_id = None

    elif r < 0.78:  # invalid types (8%)
        response_time = "NaN"

    elif r < 0.85:  # negative values (7%)
        response_time = -random.randint(1, 500)

    elif r < 0.92:  # invalid timestamp (7%)
        timestamp = "INVALID_TIMESTAMP"

    elif r < 0.97:  # empty event (5%)
        event_name = ""

    else:  # duplicates (3%)
        if previous_logs:
            return random.choice(previous_logs)

    return [log_id, device_id, log_level, event_name, response_time, timestamp]


def start_streaming():

    print("=" * 60)
    print("[*] Starting Mobile Logs Streaming Generator")
    print(f"[*] Output Directory: {os.path.abspath(OUTPUT_DIRECTORY)}")
    print("[*] Press CTRL+C to stop")
    print("=" * 60)

    try:

        while True:

            file_name = (
                f"mobile_logs_"
                f"{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
            )

            file_path = os.path.join(
                OUTPUT_DIRECTORY,
                file_name
            )

            total_records = random.randint(300, 700)

            with open(
                file_path,
                mode='w',
                newline='',
                encoding='utf-8'
            ) as f:

                writer = csv.writer(f)

                writer.writerow([
                    'log_id',
                    'device_id',
                    'log_level',
                    'event_name',
                    'response_time_ms',
                    'timestamp'
                ])

                for _ in range(total_records):

                    corruption_chance = random.random()

                    # فقط 5% corrupted rows
                    if corruption_chance < 0.02:
                        f.write("CORRUPTED_ROW\n")

                    elif corruption_chance < 0.04:
                        f.write("1001,BROKEN_DEVICE\n")

                    elif corruption_chance < 0.05:
                        f.write(
                            "@@@@@INVALID_LOG@@@@@\n"
                        )

                    else:
                        writer.writerow(
                            generate_log()
                        )

            print(
                f"[{datetime.now().strftime('%H:%M:%S')}] "
                f"Generated {file_name} "
                f"with {total_records} records"
            )

            time.sleep(
                random.uniform(1, 3)
            )

    except KeyboardInterrupt:
        print("\n[!] Streaming Generator Stopped")


if __name__ == "__main__":
    start_streaming()