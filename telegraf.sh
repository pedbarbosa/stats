#!/bin/bash

echo "==> Checking telegraf instance"
INSTANCE=telegraf
if [ ! "$(docker ps -q -f name=$INSTANCE)" ]; then
    echo "==> No $INSTANCE instance found, starting..."
    if [ "$(docker ps -aq -f status=exited -f name=$INSTANCE)" ]; then
        docker rm $INSTANCE
    fi
    docker run -d --name telegraf \
        --hostname=$HOSTNAME \
        -e "HOST_SYS=/rootfs/sys" \
        -e "HOST_ETC=/rootfs/etc" \
        -v $PWD/telegraf/telegraf_agent.conf:/etc/telegraf/telegraf.conf:ro \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /etc:/rootfs/etc:ro \
        -v /etc:/rootfs/proc:ro \
        -v /sys:/rootfs/sys:ro \
        telegraf
fi
