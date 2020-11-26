#!/bin/bash

ETCD0=$(multipass info etcd-0 | grep IPv4 | awk '{print $2}')
ETCD1=$(multipass info etcd-1 | grep IPv4 | awk '{print $2}')
ETCD2=$(multipass info etcd-2 | grep IPv4 | awk '{print $2}')

cat <<EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "cluster-endpoint:6443"
etcd:
    external:
        endpoints:
        - https://${ETCD0}:2379
        - https://${ETCD1}:2379
        - https://${ETCD2}:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
EOF
