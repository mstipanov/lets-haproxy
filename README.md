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
Steps:
* docker exec -it lets-haproxy /add-site.sh your.email@example.com letstest.example.com server1 www.mysite1.com:80
* docker exec -it lets-haproxy /add-site.sh your.email@example.com letstest2.example.com server1 www.mysite2.com:80
* docker restart lets-haproxy

## Useful commands:
Check haproxy config:
* docker exec -it lets-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
Show haproxy config:
* docker exec -it lets-haproxy cat /usr/local/etc/haproxy/haproxy.cfg
