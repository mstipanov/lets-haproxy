#!/bin/sh
set -e

if [ -d "/usr/local/etc/haproxy/haproxy.cfg.d/" ]; then
    echo "Generating haproxy.cfg from parts:"
    echo "" > /usr/local/etc/haproxy/haproxy.cfg
    for i in `ls -v /usr/local/etc/haproxy/haproxy.cfg.d/*.cfg`; do
        echo "  Appending: $i"
        echo "##### Start $i #####" >> /usr/local/etc/haproxy/haproxy.cfg
        echo "" >> /usr/local/etc/haproxy/haproxy.cfg
        cat $i >> /usr/local/etc/haproxy/haproxy.cfg
        echo "" >> /usr/local/etc/haproxy/haproxy.cfg
        echo "##### End $i #####" >> /usr/local/etc/haproxy/haproxy.cfg
    done;
else
    echo "WARNING /usr/local/etc/haproxy/haproxy.cfg.d dosn't exist, can't generate haproxy.cfg!"
fi
