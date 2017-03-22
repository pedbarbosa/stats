#!/usr/bin/env bash

echo "==> Installing or update local influxdb docker image"
docker pull influxdb

echo "==> Checking influxdb instance"
INSTANCE=influxdb
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name influxdb \
        -p 38083:8083 -p 38086:8086 -p 25827:25826/udp \
        -v $PWD/influxdb:/var/lib/influxdb \
        -v $PWD/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
        -v $PWD/collectd/types.db:/usr/share/collectd/types.db:ro \
        --restart=always \
        influxdb:latest
fi