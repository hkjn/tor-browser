# tor-browser

This repo defines the `hkjn/tor-browser` Docker image.

You can run tor-browser in a container with a command like:

```
docker run -it --rm --name tor-browser \
           -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
           -e DISPLAY=unix$DISPLAY \
           hkjn/tor-browser
```

If you want to specify a custom `torrc` file, that can be done with:
```
docker run -it --rm --name tor-browser \
           -v /host/dir/containing/torrc:/conf \
           -e TORRC_PATH=/conf/torrc \
           -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
           -e DISPLAY=unix$DISPLAY \
           hkjn/tor-browser
```