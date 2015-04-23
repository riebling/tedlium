#!/bin/bash

gxmessage -center \
          -buttons "Yes":1,"No":2 \
          -title "Please confirm" 'Really Shutdown?'

answer=$?

case "$answer" in
  1)
    sudo shutdown -h now
    ;;
  *)
    gxmessage -center "I agree, no shutdown."
    ;;
esac
