from pymongo import MongoClient
import os

client = MongoClient(os.environ.get('MONGOLAB_URI'))
db = client[os.environ.get('MONGOLAB_URI').split('/')[-1]]
sms_queue = db.sms_queue

def clean_objects(objects):
  properties = ['_id']
  for o in objects:
    for p in properties:
      if p in o:
        del o[p]
  return objects
