# lets-haproxy
Alpine based haproxy container with modular let's encrypt features

## Running HAProxy
Steps:
* sudo su
* cd ~
* git clone https://github.com/mstipanov/lets-haproxy.git
* cd lets-haproxy
* cp -r example local
* ./build.sh
* ./run.sh "$(pwd)/local" 80 443

## Request certificate:
TODO: extract to convenient script!
Steps:
* docker exec -it lets-haproxy ash
* letsencrypt certonly -n --text --webroot --webroot-path /var/lib/haproxy/webroot -d domain.one --renew-by-default --agree-tos --email admin@domain.one
