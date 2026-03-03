import csv
import numpy as np
import re
import pickle


def load_articles(filename):
    articles = []

    with open(filename, newline='', encoding="utf-8") as f:
        reader = csv.DictReader(f)

        for row in reader:

            if "content" in row:
                text = row["content"]
            else:
                text = row["clean_content"]

            articles.append({
                "id": row["id"],
                "title": row["title"],
                "content": text
            })

    return articles

def save_clean_articles(input_file, output_file):

    articles = []

    with open(input_file, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            articles.append(row)

    with open(output_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["id", "title", "clean_content"])

        for a in articles:
            words = clean_and_tokenize(a["content"])
            clean_text = " ".join(words)

            writer.writerow([
                a["id"],
                a["title"],
                clean_text
            ])

def clean_and_tokenize(text):

    text = text.lower()

    clean_text = ""

    for ch in text:
        if ch.isalpha() or ch == " ":
            clean_text += ch

    words = clean_text.split()

    return words


def build_vocabulary(tokenized_articles):
    vocab = set()

    for words in tokenized_articles:
        for w in words:
            vocab.add(w)

    return sorted(list(vocab))


def build_vectors(tokenized_articles, vocab):
    vectors = []

    for words in tokenized_articles:
        vec = []
        word_set = set(words)

        for v in vocab:
            if v in word_set:
                vec.append(1)
            else:
                vec.append(0)

        vectors.append(vec)

    return np.array(vectors)

def search_articles(articles, word):

    word = word.lower()
    results = []

    for a in articles:
        title = a["title"].lower()
        content = a["content"].lower()

        if word in title or word in content:
            results.append(a)

    return results



#I couldn't know how to make it 
def cosine_similarity_matrix(vectors):
    n = vectors.shape[0]
    sim = np.zeros((n, n))

    for i in range(n):
        for j in range(n):
            a = vectors[i]
            b = vectors[j]

            dot = np.dot(a, b)
            norm = np.linalg.norm(a) * np.linalg.norm(b)

            if norm == 0:
                sim[i][j] = 0
            else:
                sim[i][j] = dot / norm

    return sim


def save_similarity_matrix(matrix, filename="similarities.pkl"):
    with open(filename, "wb") as f:
        pickle.dump(matrix, f)


#I couldn't know how to make it 
def most_similar_articles(article_id, articles, sim_matrix, top_n=3):

    index = None

    for i, a in enumerate(articles):
        if a["id"] == str(article_id):
            index = i
            break

    if index is None:
        return []

    scores = sim_matrix[index]

    pairs = []
    for i, score in enumerate(scores):
        if i != index:
            pairs.append((i, score))

    pairs.sort(key=lambda x: x[1], reverse=True)

    top = pairs[:top_n]

    result_titles = []
    for i, _ in top:
        result_titles.append(articles[i]["title"])

    return result_titles

