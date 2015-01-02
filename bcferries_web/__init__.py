import os
from flask import Flask
from bcferries import BCFerries
from apscheduler.schedulers.background import BackgroundScheduler
from lockfile import LockFile

DEV = os.environ.get('DEV') == 'true'
app = Flask(__name__)
bc = BCFerries()
scheduler = BackgroundScheduler()
lock = LockFile('/tmp/lock')
