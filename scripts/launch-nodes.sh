#!/bin/bash

launch() {
	multipass launch --name ${1} --cpus=2 --mem=4G --disk=10G
}


haproxy() {
	host=haproxy
	launch ${host}
}

controller() {
	for i in {0..2} ; do
		host=controller-${i}
		launch ${host}
	done
}

worker() {
	for i in {0..2} ; do
		host=worker-${i}
		launch ${host}
	done
}

etcd() {
	for i in {0..2} ; do
		host=etcd-${i}
		launch ${host}
	done
}

cluster_endpoint() {
	IP=$(multipass info haproxy | grep IPv4 | awk '{print $2}')
	echo "${IP} cluster-endpoint" > cluster-endpoint.txt
}

etcd_hosts() {
	for i in {0..2} ; do
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
