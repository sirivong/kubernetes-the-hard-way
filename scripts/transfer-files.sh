#!/bin/bash

NODE_SET=2

bash_profile() {
	multipass transfer bash_profile ${1}:.bash_profile
}

haproxy_controller() {
	echo "Transfer files to haproxy-controller"
	multipass transfer 100-install-haproxy.sh haproxy-controller:.
	multipass transfer haproxy-controller.conf haproxy-controller:haproxy.conf
	multipass exec haproxy-controller -- chmod 755 1*.sh
	bash_profile haproxy-controller
}

haproxy_etcd() {
	echo "Transfer files to haproxy-etcd"
	multipass transfer 100-install-haproxy.sh haproxy-etcd:.
	multipass transfer haproxy-etcd.conf haproxy-etcd:haproxy.conf
	multipass exec haproxy-etcd -- chmod 755 1*.sh
	bash_profile haproxy-etcd
}

controller() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=controller-${i}
		echo "Transfer files to ${host}"
		multipass transfer kubeadm-config.yaml ${host}:.
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass exec ${host} -- chmod 755 0*.sh
		multipass transfer hosts.txt ${host}:.
		bash_profile ${host}
	done
}

worker() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=worker-${i}
		echo "Transfer files to ${host}"
		multipass transfer 0*.sh ${host}:.
		multipass transfer cluster-endpoint.txt ${host}:.
		multipass transfer hosts.txt ${host}:.
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
		multipass transfer hosts.txt ${host}:.
	done
}

case ${1} in
	'single-node')
		NODE_SET=0
		controller
		worker
		;;
	*)
		haproxy_controller
		haproxy_etcd
		controller
		worker
		etcd
		;;
esac

exit $?
