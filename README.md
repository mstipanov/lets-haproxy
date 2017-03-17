# lets-haproxy
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Let's Encrypt certificate auto-renewal in docker-powered HAProxy reverse proxy

## Running HAProxy

```bash
sudo su
cd ~
git clone https://github.com/mstipanov/lets-haproxy.git
cd lets-haproxy
mkdir local
./build.sh
./run.sh "$(pwd)/local" 80 443
```

## Prerequisites
Existing DNS A records pointing on your public IP for: letstest.example.com and letstest2.example.com

## Request certificate and add config:

```bash
sudo docker exec -it lets-haproxy /add-site.sh your.email@example.com letstest.example.com server1 www.mysite1.com:80
```

## Renew certificates 
Older than 15 days:

```bash
sudo docker exec -it lets-haproxy /renew-certs.sh
```

Older than 45 days:

```bash
sudo docker exec -it lets-haproxy /renew-certs.sh 45
```

## Useful commands:
Check haproxy config 

```bash
sudo docker exec -it lets-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```

Show haproxy config

```bash
docker exec -it lets-haproxy cat /usr/local/etc/haproxy/haproxy.cfg
```

### I've borrowed from:
* https://github.com/janeczku/haproxy-acme-validation-plugin (thanks janeczku)
