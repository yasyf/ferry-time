import os
from flask import Flask
from bcferries import BCFerries
from apscheduler.schedulers.background import BackgroundScheduler

DEV = os.environ.get('DEV') == 'true'
app = Flask(__name__)
bc = BCFerries()
scheduler = BackgroundScheduler()
