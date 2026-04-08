import os


os.makedirs("./data/processed", exist_ok=True)
os.makedirs("./data/processed/1_star", exist_ok=True)
os.makedirs("./data/processed/2_star", exist_ok=True)
os.makedirs("./data/processed/3_star", exist_ok=True)
os.makedirs("./data/processed/4_star", exist_ok=True)
os.makedirs("./data/processed/5_star", exist_ok=True)

os.makedirs("./data/raw", exist_ok=True)

os.makedirs("./images", exist_ok=True)
os.makedirs("./images/1_star", exist_ok=True)
os.makedirs("./images/2_star", exist_ok=True)
os.makedirs("./images/3_star", exist_ok=True)
os.makedirs("./images/4_star", exist_ok=True)
os.makedirs("./images/5_star", exist_ok=True)

print("Scraping the website")
os.system("python scraper.py")

print("Processing data")
os.system("python processor.py")

print("Organizing data")
os.system("python organizer.py")

print("Done")
