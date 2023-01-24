#!/bin/bash

nohup /usr/bin/Xvfb :99 -screen 0 $RESOLUTION -ac +extension GLX +render -noreset > /dev/null 2>&1 &
nohup startxfce4 > /dev/null 2>&1 &
nohup x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -rfbauth /home/alpine/.vnc/passwd -users alpine -rfbport 5900 > /dev/null 2>&1 &
/bin/bash
