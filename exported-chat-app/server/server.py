from flask import Flask
import pandas as pd
import re
import os
import glob
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

path_ = './chats/'

others = sorted(os.listdir(path_))
others_paths = [path_ + other + '/' for other in others]
print(others_paths)

split_texts = {}
for i, others_path in enumerate(others_paths):
    files = os.listdir(others_path)
    text = ""
    for f in files:
        with open(others_path + f, 'r') as f:  # read files sequentially
            text += f.read()
    split_text = re.split('(\d+/\d+/\d+), (\d{2}:\d{2}) - (.+): ', text)
    split_text.pop(0)
    others[i] = split_text[2]  # rename to actual chat names
    #! assuming the first message is from the other
    split_texts[others[i]] = split_text


def display(split_text):
    for i in range(0, len(split_text), 4):
        if 'yeet' in split_text[i-1]:
            print('\x1b[31m', end='')
            # print(split_text[i-1].strip(), ': ', end='')
            print(split_text[i].strip())
            print('\x1b[0m', end='')
        else:
            # print(split_text[i-1].strip(), ': ', end='')
            print(split_text[i].strip())


@app.route('/chats')
def contacts_route():
    return {"you": "You", "available_contacts": list(split_texts.keys())}


@app.route('/chats/<username>')
def chat_route(username):
    if username not in split_texts.keys():
        raise ValueError

    split_text = split_texts[username]
    reformat_text = []
    for i in range(0, len(split_text)-1, 4):
        # remove redundancy?
        if ('<Media' or 'Your message was deleted') in split_text[i+3]:
            continue
        chat = split_text[i+3][:-1]
        reformat_text.append(
            {
                'date': split_text[i],
                'time': split_text[i+1],
                'name': split_text[i+2],
                'chat': chat
            })
    print(f"-{split_text[2]}-")
    return {"contact": split_text[2], "chats": reformat_text, "available_contacts": list(split_texts.keys())}


if __name__ == '__main__':
    app.run(debug=True, port=3001)
