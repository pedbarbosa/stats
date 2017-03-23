#!/usr/bin/env bash
if [ -z $STACKNAME ]; then
    TELEGRAF_HOSTNAME=$HOSTNAME
else
    TELEGRAF_HOSTNAME=$CLUSTER_NAME.$HOSTNAME
fi

INSTANCE=telegraf
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name telegraf \
        --hostname="$TELEGRAF_HOSTNAME" \
        -e HOST_ETC=/rootfs/etc \
        -e HOST_SYS=/rootfs/sys \
        -e OUTPUTS_INFLUXDB_URLS='["http://ecs-influxdb:8086"]' \
        -e OUTPUTS_GRAPHITE_PREFIX="ecs-cluster" \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /etc:/rootfs/etc:ro \
        -v /sys:/rootfs/sys:ro \
        --restart=always \
        pedbarbosa/docker-telegraf:1.2.1b
fi
