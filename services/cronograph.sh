#!/usr/bin/env bash

echo "==> Updating local cronograph docker image"
docker pull cronograph

echo "==> Checking cronograph instance"
INSTANCE=cronograph
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name cronograph \
        -p 10000:10000 \
        -v /opt/cronograph:/var/lib/cronograph \
        --link influxdb \
        --restart=always \
        cronograph
fi