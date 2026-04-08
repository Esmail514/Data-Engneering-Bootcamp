from bs4 import BeautifulSoup
import requests
from urllib.parse import urljoin

raw_books = []
current_page = 1

base_url = f"https://books.toscrape.com/catalogue/page-{current_page}.html"

while current_page and current_page < 5:

    response = requests.get(base_url)

    soup = BeautifulSoup(response.text, "html.parser")

    articles = soup.find_all("article", class_="product_pod")
    for article in articles:
        title = article.h3.a["title"][:50].replace(":", "",).replace("/", "").replace("?", "").replace(".", "")
        price = article.find("p", class_="price_color").text
        star_rating = article.find('p', class_ = 'star-rating')['class'][1]
        img_src = urljoin(base_url ,article.find("img")["src"])
        img_path = requests.get(img_src)
        with open(f"./images/{title}.png", "wb") as f:
            f.write(img_path.content)

        raw_books.append({
            "title": title,
            "price": price,
            "star_rating": star_rating,
            "img_path": f"./images/{title}.png",
            })

    next_button = soup.find("li", class_="next")
    if next_button:
        current_page += 1
        base_url = f"https://books.toscrape.com/catalogue/page-{current_page}.html"
    else:
        None
