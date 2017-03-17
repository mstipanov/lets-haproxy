FROM haproxy:1.7.3-alpine

ENTRYPOINT ["/config-merge-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg", "-V"]

RUN apk add --update  \
   python python-dev py-pip \
   gcc musl-dev linux-headers \
   augeas-dev openssl-dev libffi-dev ca-certificates dialog \
   openssl bash \
   && pip install --upgrade pip && pip install -U letsencrypt \
   && mkdir -p /var/lib/haproxy/webroot \
   && apk del gcc musl-dev linux-headers augeas-dev openssl-dev libffi-dev \
   && rm -rf /var/cache/apk/*

COPY docker/config-merge.sh             /config-merge.sh
COPY docker/config-merge-entrypoint.sh  /config-merge-entrypoint.sh
COPY docker/config                      /usr/local/etc/haproxy-internal
COPY docker/add-site.sh                 /add-site.sh
COPY docker/datediff.py                 /datediff.py
COPY docker/renew-certs.sh              /renew-certs.sh

ENV TEMPLATES_DIR="/usr/local/etc/haproxy-internal/templates"
ENV CONFIG_DIR="/usr/local/etc/haproxy/haproxy.cfg.d"
ENV WEBROOT_DIR="/var/lib/haproxy/webroot"
ENV LETSENCRYPT_LIVE_DIR="/etc/letsencrypt/live"
ENV GRACEDAYS=15
