import os
from flask import Flask
from bcferries import BCFerries
from apscheduler.schedulers.blocking import BlockingScheduler
from lockfile import LockFile

DEV = os.environ.get('DEV') == 'true'
app = Flask(__name__)
bc = BCFerries()
scheduler = BlockingScheduler()
lock = LockFile('/tmp/lock')
