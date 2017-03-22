#!/usr/bin/env bash
INSTANCE=kapacitor

echo "==> Updating local $INSTANCE docker image"
docker pull $INSTANCE

echo "==> Checking $INSTANCE instance"
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name $INSTANCE \
        -p 9092:9092 \
        -v $PWD/$INSTANCE:/var/lib/$INSTANCE \
        --link influxdb \
        $INSTANCE
fi