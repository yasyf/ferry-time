from flask import jsonify, request
from bcferries_web import app, bc
from bcferries_web.helpers.mongo import sms_queue

@app.route('/api/all')
def terminals_api_view():
  return jsonify({'all': bc.to_dict(json=True)})

@app.route('/api/nearest_terminal')
def nearest_terminal_api_view():
  loc = request.values.get('location')
  return jsonify({'nearest_terminal': bc.nearest_terminal(loc).to_dict(json=True)})

@app.route('/api/terminal/<terminal>')
def terminal_api_view(terminal):
  return jsonify({'terminal': bc.terminal(terminal).to_dict(json=True)})

@app.route('/api/terminal/<terminal>/next_crossing')
def terminal_next_crossing_api_view(terminal):
  return jsonify({'next_crossing': bc.terminal(terminal).next_crossing().to_dict(json=True)})

@app.route('/api/terminal/<terminal>/route/<route>')
def terminal_route_api_view(terminal, route):
  return jsonify({'route': bc.terminal(terminal).route(route).to_dict(json=True)})

@app.route('/api/terminal/<terminal>/route/<route>/next_crossing')
def terminal_route_next_crossing_api_view(terminal, route):
  return jsonify({'next_crossing': bc.terminal(terminal).route(route).next_crossing().to_dict(json=True)})

@app.route('/api/terminal/<terminal>/route/<route>/crossing/<crossing>')
def terminal_route_crossing_api_view(terminal, route, crossing):
  return jsonify({'crossing': bc.terminal(terminal).route(route).crossing(crossing).to_dict(json=True)})

@app.route('/api/terminal/<terminal>/route/<route>/scheduled/<scheduled>')
def terminal_route_scheduled_api_view(terminal, route, scheduled):
  return jsonify({'scheduled': bc.terminal(terminal).route(route).scheduled(scheduled).to_dict(json=True)})

@app.route('/api/terminal/<terminal>/route/<route>/subscribe/<time>', methods=['POST'])
def terminal_route_subscribe_view(**kwargs):
  insert = {'number': request.json['number'], 'done': False}
  insert.update(kwargs)
  if not sms_queue.find_one(insert):
    insert.update({'pending': True})
    sms_queue.insert(insert)
    return jsonify({'status': 'success'})
