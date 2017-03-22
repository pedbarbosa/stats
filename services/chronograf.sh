#!/usr/bin/env bash

echo "==> Updating local chronograf docker image"
docker pull chronograf

echo "==> Checking chronograf instance"
INSTANCE=chronograf
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name chronograf \
        -p 8080:10000 \
        -v /opt/chronograf:/var/lib/chronograf \
        --link influxdb \
        --restart=always \
        chronograf
fi
