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

## Request certificate and add config:
Prerequisites:
* Existing DNS A records pointing on your public IP for: letstest.example.com and letstest2.example.com

Steps:
* docker exec -it lets-haproxy /add-site.sh your.email@example.com letstest.example.com server1 www.mysite1.com:80
* docker exec -it lets-haproxy /add-site.sh your.email@example.com letstest2.example.com server1 www.mysite2.com:80
* docker restart lets-haproxy

## Renew certificates 
Older than 15 days:
* docker exec -it lets-haproxy /renew-certs.sh
* docker restart lets-haproxy

Older than 45 days:
* docker exec -it lets-haproxy /renew-certs.sh 45
* docker restart lets-haproxy

## Useful commands:
Check haproxy config:
* docker exec -it lets-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
Show haproxy config:
* docker exec -it lets-haproxy cat /usr/local/etc/haproxy/haproxy.cfg
