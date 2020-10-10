#!env/bin/python3

from flask import Flask, request
from ncn.data import get_datasets
from ncn.evaluation import Evaluator
import json
import numpy as np
import pickle
import psycopg2
import psycopg2.extras
import nltk
from nltk.corpus import stopwords
from datetime import datetime

print('Setting up neural network...')

# Das tranierte Modell und die Daten mÃ¼ssen separat runter geladen werden, und bei ./dataset gespeichert werden

path_to_weights = "./dataset/NCN_5_27_11_embed_128_hid_256_1_GRU.pt"
path_to_data = "./ncn/input/mag_data.csv"
data = get_datasets(path_to_data, 20000, 20000, 20000)
nltk.download('stopwords')
sw = stopwords.words("english")
evaluator = Evaluator([4, 4, 5, 6, 7], [1, 2], 256, 128, 1,
                      path_to_weights, data, evaluate=False, show_attention=True)

with open("assets/title_tokenized_to_full.pkl", "rb") as fp:
    title_to_full = pickle.load(fp)
with open("assets/title_to_aut_cited.pkl", "rb") as fp:
    title_to_aut = pickle.load(fp)
with open("assets/title_tokenized_to_paper_id.pkl", "rb") as fp:
    title_to_paperid = pickle.load(fp)

app = Flask(__name__)

@app.route('/api/recommendation', methods=['POST'])
def get_recommendations():
    jsonData = request.get_json()
    context = jsonData.get('query')
    authors = 'Sebastian Celis, Vinzenz Zinecker, Isabella Bragaglia Cartus'
    scores, a = evaluator.recommend(context, authors, 20)

    # Connect to Postgres
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print(current_time + "  -  " + "connecting to postgres")
    conn = psycopg2.connect(
        "dbname=MAG19 user=mag password=1maG$ host=localhost port=8888")
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    papers = []

    index = 0
    for v in scores.values():
        paperid = title_to_paperid.get(v)
        if paperid is not None:
            paper = getPaperData(paperid, cur)
        else:
            paper = {'title': v, "paperid": -1}

        for k, v2 in title_to_full.items():
            if v2 == v:
                authors = title_to_aut.get(tuple(k.split(' ')))
                break

        if authors is None:
            authors = 'Unknown authors'
        
        decisiveWords = getDecisiveWords(scores, a, index)

        paper['authors'] = authors
        paper['decisive_words'] = decisiveWords

        papers.append(paper)
        index += 1

    results = {'papers': papers}
    cur.close()
    conn.close()

    return app.make_response(json.dumps(results))


def getPaperData(paperid, cur):
    query = 'SELECT sourceurl FROM paperurls where paperid='+str(paperid)
    cur.execute(query)
    row = cur.fetchone()
    url = row['sourceurl']

    query = 'SELECT originaltitle, publishedyear, citationcount, originalvenue, publisher FROM papers where paperid='+str(paperid)
    cur.execute(query)
    row = cur.fetchone()

    return {'paperid': paperid, 'title': row['originaltitle'], 'url':url, 'year': row['publishedyear'], 'citationcount': row['citationcount'], 'venue': row['originalvenue'], 'publisher': row['publisher']}

def getDecisiveWords(scores, a, index):
    seq = data.cntxt.tokenize(scores[index])
    tensor = a[1:len(seq)+1, index, :]
    tensor = tensor.numpy()
    decisivewords = []
    bestRow = 0
    bestRowVal = 0.0
    secondBestRow = 0
    for x in range(len(tensor)):
        if seq[x] in sw:
            continue
        currentVal = 0.0
        for y in range(len(tensor[x])):
            #currentVal += tensor[x][y]
            if tensor[x][y] > currentVal:
                # print('')
                currentVal = tensor[x][y]

        if currentVal > bestRowVal:
            bestRowVal = currentVal
            bestRow = x

    decisivewords.append(seq[bestRow])
    bestRowVal = 0.0

    for x in range(len(tensor)):
        if seq[x] in sw or x == bestRow:
            continue
        currentVal = 0.0
        for y in range(len(tensor[x])):
            #currentVal += tensor[x][y]
            if tensor[x][y] > currentVal:
                # print('')
                currentVal = tensor[x][y]

        if currentVal > bestRowVal:
            bestRowVal = currentVal
            secondBestRow = x

    decisivewords.append(seq[secondBestRow])
    return decisivewords

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers',
                         'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods',
                         'GET,PUT,POST,DELETE,OPTIONS')
    return response


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', use_reloader=False)
