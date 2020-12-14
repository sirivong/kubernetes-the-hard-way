#!/bin/bash

kubeadm config images pull

single_node() {
	kubeadm init \
		--control-plane-endpoint=cluster-endpoint \
		--upload-certs \
		--ignore-preflight-errors=all
}

multi_node() {
	kubeadm init \
		--config kubeadm-config.yaml \
		--upload-certs \
		--ignore-preflight-errors=all
}

kubeconfig() {
	mkdir -p ${HOME}/.kube
	cp -i /etc/kubernetes/admin.conf ${HOME}/.kube/config
	chown ubuntu:ubuntu ${HOME}/.kube/config
}

pod_network() {
	# Install Weave pod network
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

case ${1} in
	'single-node')
		single_node
		kubeconfig
		pod_network
		;;
	*)
		multi_node
		kubeconfig
		pod_network
		;;
esac

