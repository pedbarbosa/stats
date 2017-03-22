#!/usr/bin/env bash
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
        --hostname=$HOSTNAME \
        -e "HOST_SYS=/rootfs/sys" \
        -e "HOST_PROC=/rootfs/proc" \
        -e "HOST_ETC=/rootfs/etc" \
        -v $PWD/etc/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /sys:/rootfs/sys:ro \
        -v /proc:/roots/proc:ro \
        -v /etc:/rootfs/etc:ro \
        --link influxdb \
        telegraf
        #-e "HOST_PROC=/rootfs/proc" \
        #-v /proc:/roots/proc:ro \
fi
