#!/bin/bash

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
        -p 8083:8083 -p 8086:8086 -p 25827:25826/udp \
        -v $PWD/influxdb:/var/lib/influxdb \
        -v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
        -v $PWD/types.db:/usr/share/collectd/types.db:ro \
        --restart=always \
        influxdb:latest
fi

echo "==> Updating local telegraf docker image"
docker pull telegraf

echo "==> Checking telegraf instance"
INSTANCE=telegraf
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name telegraf \
        -v $PWD/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
        telegraf
fi


echo "==> Updating local grafana docker image"
docker pull grafana/grafana

echo "==> Checking grafana instance"
INSTANCE=grafana
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name grafana \
        -p 3000:3000 \
        -v $PWD/grafana_etc:/etc/grafana \
        -v $PWD/grafana_lib:/var/lib/grafana \
        -e "GF_INSTALL_PLUGINS=grafana-piechart-panel" \
        --link influxdb \
        grafana/grafana
fi
