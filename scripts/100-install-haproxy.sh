#!/bin/bash

apt-get update
apt-get install -y haproxy

cat haproxy.conf | tee -a /etc/haproxy/haproxy.cfg

systemctl daemon-reload
systemctl restart haproxy
systemctl enable haproxy
