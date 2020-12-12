#!/bin/bash

kubeadm init phase etcd local --config=./kubeadmcfg.yaml

systemctl daemon-reload
systemctl restart kubelet
