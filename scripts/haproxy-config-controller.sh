#!/bin/bash

HOST0_IP=$(multipass info controller-0 | grep IPv4 | awk '{print $2}')
HOST1_IP=$(multipass info controller-1 | grep IPv4 | awk '{print $2}')
HOST2_IP=$(multipass info controller-2 | grep IPv4 | awk '{print $2}')

cat <<EOF | tee haproxy-controller.conf
#---------------------------------------------------------------------
# apiserver frontend which proxys to the masters
#---------------------------------------------------------------------
frontend apiserver
    bind *:6443
    mode tcp
    option tcplog
    default_backend apiserver

#---------------------------------------------------------------------
# round robin balancing for apiserver
#---------------------------------------------------------------------
backend apiserver
    option httpchk GET /healthz
    http-check expect status 200
    mode tcp
    option ssl-hello-chk
    balance     roundrobin
        server controller-0 ${HOST0_IP}:6443 check
        server controller-1 ${HOST1_IP}:6443 check
        server controller-2 ${HOST2_IP}:6443 check
EOF
