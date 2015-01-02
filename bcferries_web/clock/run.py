from bcferries_web import scheduler, lock
import lockfile, threading

from clock import *

try:
  lock.acquire(timeout=1)
  print "Running scheduler in thread {}".format(threading.current_thread().ident)
  scheduler.start()
except lockfile.LockTimeout:
  print "Could not aquire scheduler lock on thread {}".format(threading.current_thread().ident)
finally:
  if lock.i_am_locking():
    lock.release()

