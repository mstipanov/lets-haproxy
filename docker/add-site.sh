#!/usr/bin/env bash
set -e

E_MAIL=$1
if [ -z ${E_MAIL} ]; then
    echo "E_MAIL must be the first parameter!"
    exit 2
fi

DOMAIN=$2
if [ -z ${DOMAIN} ]; then
    echo "DOMAIN must be the second parameter!"
    exit 1
fi

if [ ! -d "${LETSENCRYPT_LIVE_DIR}/$DOMAIN" ]; then
    echo "Generating new certificate for $DOMAIN"
    letsencrypt certonly -n --text --webroot --webroot-path $WEBROOT_DIR -d $DOMAIN --renew-by-default --agree-tos --email $E_MAIL
else
    echo "Certificate exists for $DOMAIN"
fi

if [ ! -d "${CONFIG_DIR}/$DOMAIN" ]; then
    echo "Generating new config for $DOMAIN"

    mkdir -p "${CONFIG_DIR}/$DOMAIN"

    cp -f ${TEMPLATES_DIR}/* ${CONFIG_DIR}/$DOMAIN/

    i=0
    for var in "$@"
    do
        i=$((i+1))
        sed -i -- "s/<param_${i}>/${var}/g" ${CONFIG_DIR}/$DOMAIN/*
        rm -f ${CONFIG_DIR}/$DOMAIN/*-
    done
else
    echo "Config exists for $DOMAIN"
fi

/config-merge.sh /usr/local/etc/haproxy/haproxy.cfg.new

haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg.new

rm -f /usr/local/etc/haproxy/haproxy.cfg
mv /usr/local/etc/haproxy/haproxy.cfg.new /usr/local/etc/haproxy/haproxy.cfg

echo "Soft reloading haproxy by sending SIGHUP"
kill -1 1
