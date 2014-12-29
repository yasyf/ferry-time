from flask import render_template
from bcferries_web import app

@app.before_request
def preprocess_request():
  pass

@app.after_request
def postprocess_request(response):
  return response

@app.route('/')
def index_view():
  return render_template('index.html')

@app.route('/template/<name>')
def terminal_view(name):
  return render_template('fragments/_{}.html'.format(name))
