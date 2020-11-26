#!/bin/bash

apt-get update
apt-get install -y haproxy

cat haproxy.conf | tee -a /etc/haproxy/haproxy.cfg

sudo systemctl daemon-reload
sudo systemctl restart haproxy
sudo systemctl enable haproxy
