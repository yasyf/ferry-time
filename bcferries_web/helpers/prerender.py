import requests, os
from flask import Response, request

IGNORED_HEADERS = [
    'connection', 'keep-alive', 'proxy-authenticate',
    'proxy-authorization', 'te', 'trailers', 'transfer-encoding',
    'upgrade', 'content-length', 'content-encoding'
]

USER_AGENTS = [
    "Googlebot",
    "Yahoo",
    "bingbot",
    "Badiu",
    "Ask Jeeves"
]

BASE_URL = 'http://service.prerender.io/'

def prerender_request():
  headers = {'X-Prerender-Token': os.getenv('PRERENDER_TOKEN')}
  url = "{}{}".format(BASE_URL, request.url)
  r = requests.get(url, headers=headers)
  response = Response(r.content)
  for k,v in r.headers.items():
    if k not in IGNORED_HEADERS:
      response.headers.add(k, v)
  return response

def should_prerender_request():
  if 'PhantomJS' in request.user_agent.string:
    return False
  return request.args.get('_escaped_fragment_') != None or \
    any([x in request.user_agent.string for x in USER_AGENTS])
