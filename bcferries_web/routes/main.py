from flask import render_template, request, redirect
from bcferries_web import app, DEV

@app.before_request
def preprocess_request():
  if not DEV and not request.is_secure:
    https_indicators = ['CF-Visitor', 'X-Forwarded-Proto']
    if not any(['https' in x for x in https_indicators]):
      url = request.url.replace('http://', 'https://', 1)
      return redirect(url, code=301)

@app.after_request
def postprocess_request(response):
  if not DEV:
    response.headers.setdefault('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
  return response

@app.route('/')
def index_view():
  return render_template('index.html')

@app.route('/template/<name>')
def terminal_view(name):
  return render_template('fragments/_{}.html'.format(name))
