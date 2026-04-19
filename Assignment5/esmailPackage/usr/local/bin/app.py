import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import pandas as pd


current_page = 1
raw_data = []
while current_page <= 1:
    base_url = f"https://news.ycombinator.com/?p={current_page}"
    response = requests.get(base_url)
    soup = BeautifulSoup(response.text, "html.parser")
    news = soup.find_all('tr', class_='athing')

    for data in news:
        rank = data.find('span', class_='rank').text.replace(".", "")
        title_node = data.find('span', class_='titleline').find('a')
        title = title_node.text
        link = title_node['href']

        sub_row = data.find_next_sibling('tr')
        
        score_tag = sub_row.find('span', class_='score')
        points = score_tag.text if score_tag else "0 points"
        
        author_tag = sub_row.find('a', class_='hnuser')
        author = author_tag.text if author_tag else "N/A"

        age_tag = sub_row.find('span', class_='age')
        age = age_tag.text if age_tag else "N/A"

        raw_data.append({
            'rank': rank,
            'title': title,
            'link': link,
            'points': points,
            'author': author,
            'age': age,
        })

    next_page = soup.find('a', class_='morelink')
    if next_page:
        current_page += 1
    else:
        current_page = None


df = pd.DataFrame(raw_data)

df["title"] = df["title"].str.strip().str.replace(r'[,()/:\n]', ' ', regex=True).str.lower()
df['points'] = df['points'].str.replace(r' points?', '', regex=True)

df['rank'] = df['rank'].astype(int)
df['points'] = df['points'].astype(int)


df.to_json('/usr/local/bin/data.json', orient='records', index=False)