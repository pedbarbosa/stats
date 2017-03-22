#!/usr/bin/env bash
echo "==> Checking telegraf instance"
TELEGRAF_HOSTNAME=ewe-ecs-agent.$CLUSTER_NAME.$HOSTNAME
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
        -e OUTPUTS_INFLUXDB_URLS='["http://10.38.95.206:8086"]' \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /etc:/rootfs/etc:ro \
        -v /sys:/rootfs/sys:ro \
        --restart=always \
        pedbarbosa/docker-telegraf:1.2.1
fi
