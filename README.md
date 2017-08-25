# docker-pgmodeler

pgmodeler in a container

To run this image, share the X11 socket or use any
of the other methods to run X11 Apps in Docker.

For example, you can run the image like this:

```
docker run -it -u 1000:1000 --rm -e HOME \
  -e DISPLAY=unix:0 -e XAUTHORITY=/tmp/xauth \
  -v $XAUTHORITY:/tmp/xauth -v $HOME:$HOME \
  -v /tmp/.X11-unix:/tmp/.X11-unix kayvan/pgmodeler
```

## MacOS: Using this image

On MacOS, if you wish to run this image instead of the native
`SCID vs Mac` port, you need to install `XQuartz` and `socat`.
With `brew` installed, do this:

```
brew cask install xquartz
brew install socat
```

Then you can place this bash snippet in your `~/.bash_profile`:

```sh
__my_ip=$(ifconfig|grep 'inet '|grep -v '127.0.0.1'| \
            head -1|awk '{print $2}')
pgmodeler() {
  killall -0 quartz-wm > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR: Quartz is not running. Start Quartz and try again."
  else
    socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    SOCAT_SCID_PID=$!
    docker run --rm \
      -e HOME \
      -e XAUTHORITY=/tmp/xauth -v ~/.Xauthority:/tmp/xauth \
      -e DISPLAY=$__my_ip:1 --net host -v $HOME:$HOME kayvan/pgmodeler
    kill $SOCAT_SCID_PID
  fi
}
```

Now, `pgmodeler` should launch the application.

# Reference

- https://www.pgmodeler.com.br
