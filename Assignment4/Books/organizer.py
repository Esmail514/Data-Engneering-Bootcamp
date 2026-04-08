import shutil
from processor import df
import pandas as pd


# organizing data
star_1_books = df[df['star_rating'] == 1]
star_2_books = df[df['star_rating'] == 2]
star_3_books = df[df['star_rating'] == 3]
star_4_books = df[df['star_rating'] == 4]
star_5_books = df[df['star_rating'] == 5]

# orgnizing imgs
def sorting_imgs(books):
    for i in range(len(books)):
        img_path = books.iloc[i]['img_path']
        title = books.iloc[i]['title']
        star_rating = books.iloc[i]['star_rating']
        shutil.move(img_path, f"./images/{star_rating}_star/{title}.png")
        books.iloc[i, 3] = f"./images/{star_rating}_star/{title}.png"

sorting_imgs(star_1_books)
sorting_imgs(star_2_books)
sorting_imgs(star_3_books)
sorting_imgs(star_4_books)
sorting_imgs(star_5_books)

star_1_books.to_csv("./data/processed/1_star/1_star_books.csv", index=True)
star_2_books.to_csv("./data/processed/2_star/2_star_books.csv", index=True)
star_3_books.to_csv("./data/processed/3_star/3_star_books.csv", index=True)
star_4_books.to_csv("./data/processed/4_star/4_star_books.csv", index=True)
star_5_books.to_csv("./data/processed/5_star/5_star_books.csv", index=True)

