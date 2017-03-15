#!/usr/bin/env sh
set -e

GRACE_DAYS=$1
if [ -z ${GRACE_DAYS} ]; then
    GRACE_DAYS=$GRACEDAYS
fi

if [ "$(ls -A /usr/local/etc/haproxy/haproxy.cfg.d/)" ]; then
    for i in `ls -v /usr/local/etc/haproxy/haproxy.cfg.d/`; do
        DOMAIN=${i##*/}
        if [ -d "$LETSENCRYPT_LIVE_DIR/$DOMAIN" ]; then
            echo "Checking cert expiration: $DOMAIN"
            date=`echo | openssl x509 -enddate -noout -in $LETSENCRYPT_LIVE_DIR/$DOMAIN/fullchain.pem | grep notAfter | sed -e 's#notAfter=##'`
            diff="$(/datediff.py "$date")"

            if test "${diff}" -lt "${GRACE_DAYS}";
            then
                if test "${diff}" -lt "0";
                then
                    echo "The certificate for ${DOMAIN} has already expired."
                else
                    echo "The certificate for ${DOMAIN} will expire in ${diff} days."
                fi
                letsencrypt certonly -n --text --webroot --webroot-path $WEBROOT_DIR -d $DOMAIN --renew-by-default --agree-tos --email $(cat /usr/local/etc/haproxy/haproxy.cfg.d/$DOMAIN/email)
            fi
        else
            echo "WARNING: Skipping $DOMAIN"
        fi
    done;
fi
