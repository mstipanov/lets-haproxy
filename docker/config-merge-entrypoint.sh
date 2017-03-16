#!/usr/bin/env bash
set -e

/config-merge.sh /usr/local/etc/haproxy/haproxy.cfg.new

haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg.new

rm -f /usr/local/etc/haproxy/haproxy.cfg
mv /usr/local/etc/haproxy/haproxy.cfg.new /usr/local/etc/haproxy/haproxy.cfg

/docker-entrypoint.sh "$@"
