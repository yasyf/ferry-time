import os
from flask import Flask

app = Flask(__name__)

DEV = os.environ.get('DEV') == 'true'
