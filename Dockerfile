FROM haproxy:1.7.3-alpine

COPY docker/config-merge.sh /config-merge.sh
COPY docker/config-merge-entrypoint.sh /config-merge-entrypoint.sh
COPY docker/acme-http01-webroot.lua /usr/local/etc/haproxy/acme-http01-webroot.lua

ENTRYPOINT ["/config-merge-entrypoint.sh"]

RUN apk add --update  \
  python python-dev py-pip \
  gcc musl-dev linux-headers \
  augeas-dev openssl-dev libffi-dev ca-certificates dialog \
  && rm -rf /var/cache/apk/*

RUN pip install --upgrade pip && pip install -U letsencrypt
RUN mkdir -p /var/lib/haproxy/webroot

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg", "-V"]
