#!/bin/bash

export PYTHONPATH=$(pwd)

if [ "$DEV" == "true" ]
then
  python bcferries_web/app.py
else
  gunicorn -b "0.0.0.0:$PORT" -w 5 bcferries_web.app:app
fi
