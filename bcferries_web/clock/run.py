from bcferries_web import scheduler, lock
import lockfile

from clock import *

try:
  lock.acquire(timeout=1)
  scheduler.start()
except lockfile.LockTimeout:
  print "Could not aquire scheduler lock!"
finally:
  if lock.i_am_locking():
    lock.release()

