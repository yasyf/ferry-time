from app import app

__all__ = ['main', 'api']

@app.before_request
def preprocess_request():
  pass

@app.after_request
def postprocess_request(response):
  return response
