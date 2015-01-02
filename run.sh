#!/bin/bash

export PYTHONPATH=$(pwd)

if [ "$DEV" == "true" ]
then
  python bcferries_web/app.py
else
  python bcferries_web/clock/run.py &
  gunicorn -b "0.0.0.0:$PORT" -w 5 -k eventlet bcferries_web.app:app
fi
