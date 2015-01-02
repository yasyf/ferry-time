from bcferries_web import app, DEV
from werkzeug.contrib.fixers import ProxyFix
from flask.ext import assets
import os, glob, bugsnag

bugsnag.configure(api_key = os.getenv('BUGSNAG_KEY'), project_root = "/app")

if not DEV:
  from bugsnag.flask import handle_exceptions
  handle_exceptions(app)

app.secret_key = os.environ.get('SK')
app.wsgi_app = ProxyFix(app.wsgi_app)

env = assets.Environment(app)
env.load_path = [os.path.join(os.path.dirname(__file__), os.path.pardir)]

js = []
coffee = []
js_order = ['vendor', 'services', 'filters', 'directives', 'controllers']
css_order = ['vendor']

for x in js_order:
  js.extend(glob.glob('bcferries_web/static/js/{}/*.js'.format(x)))
  coffee.extend(glob.glob('bcferries_web/static/js/{}/*.js.coffee'.format(x)))

coffee_bundle = assets.Bundle(*coffee, filters=['coffeescript'])
js.append(coffee_bundle)

css = glob.glob('bcferries_web/static/css/*.css')
less = glob.glob('bcferries_web/static/css/*.less')
for x in css_order:
  css.extend(glob.glob('bcferries_web/static/css/{}/*.css'.format(x)))
  less.extend(glob.glob('bcferries_web/static/css/{}/*.less'.format(x)))

less_bundle = assets.Bundle(*less, filters=['less'])
css.append(less_bundle)

js_filters = []
css_filters = []

if not DEV:
  js_filters.append('rjsmin')
  css_filters.append('cssmin')

env.register('js_app', assets.Bundle('bcferries_web/static/js/app.js.coffee', filters=['coffeescript'] + js_filters,
                                     output='js/min/app.min.js'))
env.register('js_all', assets.Bundle(*js, filters=js_filters, output='js/min/scripts.min.js'))
env.register('css_all', assets.Bundle(*css, filters=css_filters, output='css/min/styles.min.css'))

from routes import *

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=int(os.environ.get('PORT') or 5000), debug=DEV)
