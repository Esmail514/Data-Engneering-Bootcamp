from data_clean import load_articles, clean_and_tokenize, build_vocabulary, build_vectors, cosine_similarity_matrix, save_similarity_matrix, most_similar_articles, search_articles, save_clean_articles

def main():

    save_clean_articles("Articles.csv", "clean_articles.csv")

    articles = load_articles("clean_articles.csv")
    tokenized = []
    for a in articles:
        tokenized.append(clean_and_tokenize(a["content"]))

    vocab = build_vocabulary(tokenized)
    vectors = build_vectors(tokenized, vocab)
    sim_matrix = cosine_similarity_matrix(vectors)

    save_similarity_matrix(sim_matrix)

    while True:

        print("1 Show most similar articles")
        print("2 Search in articles")
        print("3 Exit")

        choice = input("Choose: ")

        if choice == "1":

            article_id = input("Enter article id:from 1 to 20 ")

            try:
                article_id = int(article_id)

                result = most_similar_articles(
                    article_id,
                    articles,
                    sim_matrix
                )

                print("Most similar articles:")
                for title in result:
                    print(title)

            except:
                print("Invalid article id")

        elif choice == "2":

            word = input("Enter a word to search: ")

            results = search_articles(articles, word)

            if len(results) == 0:
                print("No articles found.")
            else:
                print("\nFound articles:")
                for a in results:
                    print(a["title"])

        elif choice == "3":
            print("Logout")
            break

        else:
            print("Wrong choice")


if __name__ == "__main__":
    main()