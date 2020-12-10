#!/bin/bash

NODE_SET=2

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
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
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
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=worker-${i}
		echo "Transfer files to ${host}"
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
	done
}

etcd() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=etcd-${i}
		echo "Transfer files to ${host}"
		multipass transfer etcd-hosts.txt ${host}:.
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
	done
}

case ${1} in
	'single-node')
		NODE_SET=0
		controller
		worker
		;;
	*)
		haproxy
		controller
		worker
		etcd
		;;
esac

exit $?
