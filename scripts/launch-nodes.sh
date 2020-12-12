#!/bin/bash

NODE_SET=2

launch() {
	multipass launch --name ${1} --cpus=2 --mem=4G --disk=10G
}

haproxy_controller() {
	host=haproxy-controller
	launch ${host}
}

haproxy_etcd() {
	host=haproxy-etcd
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
	CLUSTER_ENDPOINTS_FILE=cluster-endpoint.txt
	cat /dev/null > ${CLUSTER_ENDPOINTS_FILE}
	if [[ ${NODE_SET} > 1 ]] ; then
		IP=$(multipass info haproxy-controller | grep IPv4 | awk '{print $2}')
		echo "${IP} cluster-endpoint" >> ${CLUSTER_ENDPOINTS_FILE}

		IP=$(multipass info haproxy-etcd | grep IPv4 | awk '{print $2}')
		echo "${IP} etcd-endpoint" >> ${CLUSTER_ENDPOINTS_FILE}
	else 
		IP=$(multipass info controller-0 | grep IPv4 | awk '{print $2}')
		echo "${IP} cluster-endpoint etcd-endpoint" >> ${CLUSTER_ENDPOINTS_FILE}
	fi
}

etcd_hosts() {
	ETCD_HOSTS_FILE=etcd-hosts.txt
	cat /dev/null > ${ETCD_HOSTS_FILE}
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		host=etcd-${i}
		IP=$(multipass info ${host} | grep IPv4 | awk '{print $2}')
		echo "export HOST${i}=${IP}" >> ${ETCD_HOSTS_FILE}
	done
}

case ${1} in
	'haproxy-controller')
		haproxy_controller
		;;
	'controller')
		controller
		;;
	'worker')
		worker
		;;
	'haproxy-etcd')
		haproxy_etcd
		;;
	'etcd')
		etcd
		;;
	'cluster-endpoint')
		cluster_endpoint
		;;
	'single-node')
		NODE_SET=0
		controller
		worker
		cluster_endpoint
		;;
	*)
		haproxy_controller
		controller
		worker
		haproxy_etcd
		etcd
		cluster_endpoint
		etcd_hosts
		;;
esac

exit $?
