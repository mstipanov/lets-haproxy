#!/usr/bin/env sh

CONFIG_DIR=$1

if [[ -z "${CONFIG_DIR}" ]]; then
    echo "No config dir defined. Pass config dir as first argument!"
    exit 1
fi

docker rm -f lets-haproxy; echo ""

docker run --restart=unless-stopped \
    -v ${CONFIG_DIR}/haproxy.cfg.d/:/usr/local/etc/haproxy/haproxy.cfg.d/:ro \
    -v ${CONFIG_DIR}/webroot/:/var/lib/haproxy/webroot/ \
    -p 8980:80 \
    -p 8943:443 \
    --name lets-haproxy \
    -d lets-haproxy:latest
