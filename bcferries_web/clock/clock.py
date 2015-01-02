from bcferries_web.helpers.mongo import sms_queue
from bcferries_web.helpers.sms import send_sms
from bcferries_web import bc, scheduler
import datetime

def get_scheduled(user):
  terminal, route, time = user['terminal'], user['route'], user['time']
  return bc.terminal(terminal).route(route).scheduled(time)

def get_offset(user):
  scheduled = get_scheduled(user)
  if scheduled.actual_departure and scheduled.actual_departure  < datetime.datetime.now():
    return False
  return scheduled.delta_from_schedule()

def send_user_sms(user, offset):
  scheduled, offset = get_scheduled(user), get_offset(user)
  number = user['number']
  minutes = int(offset.seconds / 60.)
  if minutes == 0:
    fragment = "on time"
  else:
    off = 'early' if scheduled.is_early() else 'late'
    fragment = "{minutes} minutes {off}".format(minutes=minutes, off=off)
  message = "[FerryTime] {} Ferry at {} is now {}".format(user['route'], user['time'], fragment)
  send_sms(number, message)

@scheduler.scheduled_job('interval', minutes=1, id='setup_pending_sms')
def setup_pending_sms():
  for user in sms_queue.find({'pending': True}):
    offset = get_offset(user)
    update = {'pending': False, 'done': False, 'last_processed': datetime.datetime.utcnow(), 'offset': offset.seconds}
    sms_queue.update({'_id': user['_id']}, {'$set': update})
    message = "[FerryTime] Notifications enabled for {} Ferry at {}!".format(user['route'], user['time'])
    send_sms(user['number'], message)
    print 'Setup completed for {}'.format(user['_id'])

@scheduler.scheduled_job('interval', minutes=5, id='process_sms')
def process_sms():
  now = datetime.datetime.utcnow()
  local_now = datetime.datetime.now()
  cutoff =  now - datetime.timedelta(minutes=10)
  for user in sms_queue.find({'pending': False, 'done': False, 'last_processed': {'$lte': cutoff}}):
    search = {'_id': user['_id']}
    scheduled = get_scheduled(user)
    if scheduled.actual_departure and scheduled.actual_departure < local_now:
      update = {'last_processed': now, 'done': True}
      sms_queue.update(search, {'$set': update})
      continue
    offset = get_offset(user)
    update = {'last_processed': now, 'offset': offset.seconds}
    sms_queue.update(search, {'$set': update})
    if offset.seconds != user['offset']:
      send_user_sms(user, offset)
    print 'Process completed for {}'.format(user['_id'])
