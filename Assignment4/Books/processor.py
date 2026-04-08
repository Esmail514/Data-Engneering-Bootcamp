from scraper import raw_books
import pandas as pd

df = pd.DataFrame(raw_books)

# first saving the raw data
df.to_csv("./data/raw/raw_books.csv", index=True)

# cleaning data
df['price'] = df['price'].str.replace('£', '')
df['price'] = df['price'].str.replace('Â', '')

df['star_rating'] = df['star_rating'].map({
    'One' : 1,
    'Two' : 2,
    'Three': 3,
    'Four': 4,
    'Five':5,
})

# changing type
df['price'] = df['price'].astype(float)
df['star_rating'] = df['star_rating'].astype('Int64')


df.dropna(inplace=True)
df.drop_duplicates(inplace=True)



