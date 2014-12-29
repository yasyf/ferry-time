from flask import jsonify, request
from app import app
from bcferries import BCFerries

bc = BCFerries()

@app.route('/api/terminals')
def terminals_view():
  return jsonify({'terminals': {'name':x for x in bc.terminals()}})

@app.route('/api/nearest_terminal')
def nearest_terminal_view():
  loc = request.values.get('loc')
  return jsonify({'nearest_terminal': {'name':x for x in bc.nearest_terminal(loc)}})

@app.route('/api/terminal/<terminal>')
def terminal_view(terminal):
  return jsonify({'terminal': bc.terminal(terminal).to_dict()})

@app.route('/api/terminal/<terminal>/next_crossing')
def terminal_next_crossing_view(terminal):
  return jsonify({'next_crossing': bc.terminal(terminal).next_crossing().to_dict()})

@app.route('/api/terminal/<terminal>/updated_at')
def terminal_updated_at_view(terminal):
  return jsonify({'updated_at': bc.terminal(terminal).updated_at()})

@app.route('/api/terminal/<terminal>/location')
def terminal_location_view(terminal):
  return jsonify({'location': list(bc.terminal(terminal).location())})

@app.route('/api/terminal/<terminal>/routes')
def terminal_routes_view(terminal):
  return jsonify({'routes': {'name':x for x in bc.routes()}})

@app.route('/api/terminal/<terminal>/route/<route>')
def terminal_route_view(terminal, route):
  return jsonify({'route': bc.terminal(terminal).route(route).to_dict()})

@app.route('/api/terminal/<terminal>/route/<route>/car_waits')
def terminal_route_car_waits_view(terminal, route):
  return jsonify({'car_waits': bc.terminal(terminal).route(route).car_waits})

@app.route('/api/terminal/<terminal>/route/<route>/oversize_waits')
def terminal_route_oversize_waits_view(terminal, route):
  return jsonify({'oversize_waits': bc.terminal(terminal).route(route).oversize_waits})

@app.route('/api/terminal/<terminal>/route/<route>/distance')
def terminal_route_distance_view(terminal, route):
  return jsonify({'distance': bc.terminal(terminal).route(route).distance().km})

@app.route('/api/terminal/<terminal>/route/<route>/next_crossing')
def terminal_route_next_crossing_view(terminal, route):
  return jsonify({'next_crossing': bc.terminal(terminal).route(route).next_crossing().to_dict()})

@app.route('/api/terminal/<terminal>/route/<route>/crossings')
def terminal_route_crossings_view(terminal, route):
  return jsonify({'crossings': {'name':x for x in bc.terminal(terminal).route(route).crossings()}})

@app.route('/api/terminal/<terminal>/route/<route>/crossing/<crossing>')
def terminal_route_crossing_view(terminal, route, crossing):
  return jsonify({'crossing': bc.terminal(terminal).route(route).crossing(crossing).to_dict()})

@app.route('/api/terminal/<terminal>/route/<route>/schedule')
def terminal_route_schedule_view(terminal, route):
  return jsonify({'schedule': {'name':x for x in bc.terminal(terminal).route(route).schedule()}})

@app.route('/api/terminal/<terminal>/route/<route>/schedule/<scheduled>')
def terminal_route_scheduled_view(terminal, route, scheduled):
  return jsonify({'scheduled': bc.terminal(terminal).route(route).scheduled(scheduled).to_dict()})
