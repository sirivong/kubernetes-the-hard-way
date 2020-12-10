#!/bin/bash

NODE_SET=2

launch() {
	multipass launch --name ${1} --cpus=2 --mem=4G --disk=10G
}


haproxy() {
	host=haproxy
	launch ${host}
}

controller() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=controller-${i}
		launch ${host}
	done
}

worker() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=worker-${i}
		launch ${host}
	done
}

etcd() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=etcd-${i}
		launch ${host}
	done
}

cluster_endpoint() {
	if [[ ${NODE_SET} > 1 ]] ; then
		IP=$(multipass info haproxy | grep IPv4 | awk '{print $2}')
		echo "${IP} cluster-endpoint" > cluster-endpoint.txt
	else 
		IP=$(multipass info controller-0 | grep IPv4 | awk '{print $2}')
		echo "${IP} cluster-endpoint" > cluster-endpoint.txt
	fi
}

etcd_hosts() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=etcd-${i}
		IP=$(multipass info ${host} | grep IPv4 | awk '{print $2}')
		echo "export HOST${i}=${IP}" >> etcd-hosts.txt
	done
}

case ${1} in
	'haproxy')
		haproxy
		;;
	'controller')
		controller
		;;
	'worker')
		worker
		;;
	'etcd')
		etcd
		;;
	'single-node')
		NODE_SET=0
		controller
		worker
		cluster_endpoint
		;;
	*)
		haproxy
		controller
		worker
		etcd
		cluster_endpoint
		etcd_hosts
		;;
esac

exit $?
