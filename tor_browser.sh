#!/bin/bash
#
# Runs Tor browser in a Docker container.
#
docker run -it --rm \
  --name tor-browser \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY=unix$DISPLAY \
  hkjn/tor-browser
