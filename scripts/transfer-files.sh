#!/bin/bash

bash_profile() {
	multipass transfer bash_profile ${1}:.bash_profile
}

haproxy() {
	echo "Transfer files to haproxy"
	multipass transfer 100-install-haproxy.sh haproxy:.
	multipass transfer haproxy.conf haproxy:.
	multipass exec haproxy -- chmod 755 1*.sh
	bash_profile haproxy
}

controller() {
	for i in {0..2} ; do
		host=controller-${i}
		echo "Transfer files to ${host}"
		multipass transfer kubeadm-config.yaml ${host}:.
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
		bash_profile ${host}
	done
}

worker() {
	for i in {0..2} ; do
		host=worker-${i}
		echo "Transfer files to ${host}"
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
	done
}

etcd() {
	for i in {0..2} ; do
		host=etcd-${i}
		echo "Transfer files to ${host}"
		multipass transfer etcd-hosts.txt ${host}:.
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
	done
}

haproxy
controller
worker
etcd

exit $?
