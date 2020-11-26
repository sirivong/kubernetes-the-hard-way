#!/bin/bash

kubeadm config images pull

#kubeadm init \
#	--control-plane-endpoint=cluster-endpoint \
#	--upload-certs

sudo kubeadm init --config kubeadm-config.yaml --upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Weave pod network
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

