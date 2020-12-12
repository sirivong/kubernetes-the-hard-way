#!/bin/bash

ETCD_ENDPOINT=etcd-endpoint

cat <<EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "cluster-endpoint:6443"
etcd:
    external:
        endpoints:
        - https://${ETCD_ENDPOINT}:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
EOF
