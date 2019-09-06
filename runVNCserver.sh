#!/bin/bash

export DISPLAY=:20
Xvfb :20 -screen 0 1920x1080x24 &
x11vnc -display :20 -N -forever -shared -rfbport $VNCPORT &
/usr/share/novnc/utils/launch.sh --listen $LISTENPORT --vnc localhost:$VNCPORT &
nohup /usr/local/bin/pgmodeler > /dev/null &
sleep 2

xdotool search --name pgmodeler windowsize 1920 1080
tail -f /dev/null
