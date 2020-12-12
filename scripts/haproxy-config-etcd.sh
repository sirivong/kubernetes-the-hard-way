#!/bin/bash

HOST0_IP=$(multipass info etcd-0 | grep IPv4 | awk '{print $2}')
HOST1_IP=$(multipass info etcd-1 | grep IPv4 | awk '{print $2}')
HOST2_IP=$(multipass info etcd-2 | grep IPv4 | awk '{print $2}')

cat <<EOF | tee haproxy-etcd.conf
#---------------------------------------------------------------------
# etcdserver frontend which proxys to the masters
#---------------------------------------------------------------------
frontend etcdserver
    bind *:2379
    mode tcp
    option tcplog
    default_backend etcdserver

#---------------------------------------------------------------------
# round robin balancing for etcdserver
#---------------------------------------------------------------------
backend etcdserver
    mode tcp
    option ssl-hello-chk
    balance     roundrobin
        server controller-0 ${HOST0_IP}:2379
        server controller-1 ${HOST1_IP}:2379
        server controller-2 ${HOST2_IP}:2379
EOF
