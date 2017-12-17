import pandas as pd
# noinspection PyUnresolvedReferences
from extractor import FeaturesExtractor
from flask import Flask, render_template, request
from sklearn.externals import joblib

app = Flask(__name__)

model = joblib.load('model.pkl')


@app.route('/', methods=['GET', 'POST'])
def index_page(text='', label='', color='orange'):
    if request.method == "POST":
        text = request.form["text"]
    if len(text):
        X = pd.DataFrame([['', text]], columns=['title', 'text'])
        label = model.predict(X)[0]
    if not isinstance(label, str):
        if label < 3:
            color = 'red'
        elif label > 3:
            color = 'green'
    return render_template('hello.html', text=text, label=label, color=color)


if __name__ == '__main__':
    app.run()
