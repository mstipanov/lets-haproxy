#!/bin/sh
set -e

append_haproxy_conf () {
    echo "  Appending: $1"
    echo "##### Start $1 #####" >> /usr/local/etc/haproxy/haproxy.cfg
    echo "" >> /usr/local/etc/haproxy/haproxy.cfg
    cat $1 >> /usr/local/etc/haproxy/haproxy.cfg
    echo "" >> /usr/local/etc/haproxy/haproxy.cfg
    echo "##### End $1 #####" >> /usr/local/etc/haproxy/haproxy.cfg
}

rm -f /usr/local/etc/haproxy/haproxy.cfg
append_haproxy_conf /usr/local/etc/haproxy/config/templates/global.cfg
append_haproxy_conf /usr/local/etc/haproxy/config/templates/defaults.cfg
append_haproxy_conf /usr/local/etc/haproxy/config/templates/frontend_http.cfg
https_exists=0
if [ "$(ls -A /usr/local/etc/haproxy/haproxy.cfg.d/)" ]; then
    for i in `ls -v /usr/local/etc/haproxy/haproxy.cfg.d/`; do
        dir=${i##*/}
        if [ "$https_exists" -eq "0" ]; then
            if [ -f "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/frontend_https.cfg" ]; then
                https_exists=1
            fi
        fi
        if [ -f "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/frontend_http.cfg" ]; then
            echo "  Appending http: $dir"
            append_haproxy_conf "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/frontend_http.cfg"
        fi
    done;
fi
append_haproxy_conf /usr/local/etc/haproxy/config/templates/http_frontend_default.cfg

if [ "$https_exists" -eq "1" ]; then
    if [ "$(ls -A /usr/local/etc/haproxy/haproxy.cfg.d/)" ]; then
        append_haproxy_conf /usr/local/etc/haproxy/config/templates/frontend_https.cfg
        for i in `ls -v /usr/local/etc/haproxy/haproxy.cfg.d/`; do
            dir=${i##*/}
            if [ -f "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/frontend_https.cfg" ]; then
                echo "  Appending https: $dir"
                sed -i -- "s/<https_frontend_certs>/crt ${dir}\/haproxy.pem <https_frontend_certs>/g" /usr/local/etc/haproxy/haproxy.cfg
                append_haproxy_conf "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/frontend_https.cfg"
            fi
        done;
        sed -i -- 's/<https_frontend_certs>//g' /usr/local/etc/haproxy/haproxy.cfg
    fi
    append_haproxy_conf /usr/local/etc/haproxy/config/templates/https_frontend_default.cfg
fi

for i in `ls -v /usr/local/etc/haproxy/haproxy.cfg.d/`; do
    dir=${i##*/}
    if [ -f "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/backends.cfg" ]; then
        echo "  Appending backends: $dir"
        append_haproxy_conf "/usr/local/etc/haproxy/haproxy.cfg.d/$dir/backends.cfg"
    fi
done;

append_haproxy_conf /usr/local/etc/haproxy/config/templates/backend_default.cfg
