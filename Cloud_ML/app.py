from flask import Flask, request, jsonify

import json
import requests
from requests import get, post
import time
import os
import time
from bs4 import BeautifulSoup
import spacy
from decouple import config
from shortenIt import Bot


app = Flask(__name__)


@app.route('/hello')
def hello():
    return 'Hello World'


def recognize_lines(data):
    l = []
    items = data["analyzeResult"]["readResults"][0]["lines"]
    for x in items:
        l.append(x["text"])
    return l


def get_images(l):
    GOOGLE_IMAGE = \
        'https://www.google.com/search?site=&tbm=isch&source=hp&biw=1873&bih=990&'

    usr_agent = {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,/;q=0.8',
        'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
        'Accept-Encoding': 'none',
        'Accept-Language': 'en-US,en;q=0.8',
        'Connection': 'keep-alive',
    }
    Dict = {}

    for i in l:
        searchurl = GOOGLE_IMAGE + 'q=' + i

        response = requests.get(searchurl, headers=usr_agent)
        html = response.text

        # find all divs where class='rg_meta'
        hello = []
        soup = BeautifulSoup(html, 'html.parser')
        for item in soup.find_all('img', limit=3):
            hello.append(item['src'])
        hello.pop(0)
        Dict[i] = hello
        hello = []

    return Dict


def summarize_text(text_corpus):
    t = Bot()
    summary = t.final(text_corpus)
    return summary


def main(url):
    results = {}
    nlp = spacy.load("en_core_web_sm")
    endpoint = config('COMPUTER_VISION_ENDPOINT')

    subscription_key = config('COMPUTER_VISION_SUBSCRIPTION_KEY')
    text_recognition_url = endpoint + "/vision/v3.1/read/analyze"

    # Set image_url to the URL of an image that you want to recognize.
    image_url = url

    headers = {'Ocp-Apim-Subscription-Key': subscription_key}
    data = {'url': image_url}
    print("1")
    response = requests.post(
        text_recognition_url, headers=headers, json=data)
    response.raise_for_status()

    # Extracting text requires two API calls: One call to submit the
    # image for processing, the other to retrieve the text found in the image.

    # Holds the URI used to retrieve the recognized text.
    operation_url = response.headers["Operation-Location"]
    print("2")
    # The recognized text isn't immediately available, so poll to wait for completion.

    analysis = {}
    poll = True
    while (poll):
        response_final = requests.get(
            response.headers["Operation-Location"], headers=headers)
        analysis = response_final.json()

        if ("analyzeResult" in analysis):
            poll = False
        if ("status" in analysis and analysis['status'] == 'failed'):
            poll = False
    unwanted = [
        "DATE",
        "TIME",
        "MONEY",
        "QUANTITY",
        "ORDINAL",
        "CARDINAL",
        "LANGUAGE",
        "LOC",
    ]
    k = recognize_lines(analysis)
    text_corpus = " ".join(k)
    doc = nlp(text_corpus)
    ents_list = []
    for ent in doc.ents:
        if ent.label_ in unwanted:
            pass
        else:
            if(ent.text == 'Conclusion'):
                pass
            else:
                ents_list.append(ent.text)
    summary = summarize_text(text_corpus)
    images = get_images(ents_list)
    results["Entities"] = ents_list
    results["Recognized Lines"] = k
    results["Entity_Images"] = images
    results["Summary"] = summary
    return results


@app.route('/extract_data', methods=['POST'])
def get_data():
    url = request.form.get('url')
    result = main(url)
    return jsonify(result)
