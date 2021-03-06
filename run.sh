#!/usr/bin/env bash

CONFIG_DIR=$1
if [[ -z "${CONFIG_DIR}" ]]; then
    echo "No config dir defined. Pass config dir as first argument!"
    exit 1
fi

HTTP_PORT=$2
if [[ -z "${HTTP_PORT}" ]]; then
    HTTP_PORT=80
fi

HTTPS_PORT=$3
if [[ -z "${HTTPS_PORT}" ]]; then
    HTTPS_PORT=443
fi

docker rm -f lets-haproxy; echo ""

mkdir -p ${CONFIG_DIR}/etc/
mkdir -p ${CONFIG_DIR}/webroot/
mkdir -p ${CONFIG_DIR}/letsencrypt/

docker run --restart=unless-stopped \
    -v ${CONFIG_DIR}/etc/:/usr/local/etc/haproxy/ \
    -v ${CONFIG_DIR}/webroot/:/var/lib/haproxy/webroot/ \
    -v ${CONFIG_DIR}/letsencrypt/:/etc/letsencrypt/ \
    -p ${HTTP_PORT}:80 \
    -p ${HTTPS_PORT}:443 \
    --name lets-haproxy \
    -d lets-haproxy:latest
