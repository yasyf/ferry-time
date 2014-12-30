from flask import render_template, request, make_response, redirect
from bcferries_web import app, DEV
from bcferries_web.helpers.prerender import *

@app.before_request
def preprocess_request():
  if not DEV and not request.is_secure:
    https_indicators = ['CF-Visitor', 'X-Forwarded-Proto']
    if not any(['https' in request.headers.get(x, '') for x in https_indicators]):
      url = request.url.replace('http://', 'https://', 1)
      return redirect(url, code=301)
  if should_prerender_request():
    return prerender_request()

@app.after_request
def postprocess_request(response):
  if not DEV:
    response.headers.setdefault('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
  return response

@app.errorhandler(404)
def missing_page_hangler(error):
  return index_view()

@app.route('/')
def index_view():
  return render_template('index.html')

@app.route('/sitemap.xml')
def sitemap_view():
  xml = render_template('sitemap.xml')
  response = make_response(xml)
  response.headers["Content-Type"] = "application/xml"
  return response

@app.route('/robots.txt')
def robots_view():
  text = render_template('robots.txt')
  response = make_response(text)
  response.headers["Content-Type"] = " text/plain"
  return response

@app.route('/template/<name>')
def terminal_view(name):
  return render_template('fragments/_{}.html'.format(name))
