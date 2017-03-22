#!/usr/bin/env bash

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
        -p 30000:3000 \
        -v $PWD/etc/grafana:/etc/grafana \
        -v /opt/grafana:/var/lib/grafana \
        -e "GF_INSTALL_PLUGINS=grafana-piechart-panel" \
        --link influxdb \
        grafana/grafana
fi