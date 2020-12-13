#!/bin/bash

HOSTS_FILE=hosts.txt
NODE_SET=2

cmd() {
	IP=$(multipass info ${1} | grep IPv4 | awk '{print $2}')
	echo "${IP} ${1}" >> ${HOSTS_FILE}

}

haproxy_controller() {
	cmd haproxy-controller
}

haproxy_etcd() {
	cmd haproxy-etcd
}

controller() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		cmd controller-${i}
	done
}

worker() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		cmd worker-${i}
	done
}

etcd() {
	for (( i=0; i<=${NODE_SET}; i++ )) ; do
		cmd etcd-${i}
	done
}

case ${1} in
	*)
		haproxy_controller
		controller
		worker
		haproxy_etcd
		etcd
		;;
esac

exit $?
