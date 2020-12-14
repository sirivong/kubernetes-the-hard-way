#!/bin/bash

HOSTS_FILE=hosts.txt
NODE_SET=2

cat /dev/null > ${HOSTS_FILE}

cmd() {
	EXTRA_HOST=''
	if [[ -n "${2}" ]] ; then
		EXTRA_HOST=" ${2}"
	fi
	IP=$(multipass info ${1} | grep IPv4 | awk '{print $2}')
	echo "${IP} ${1}${EXTRA_HOST}" >> ${HOSTS_FILE}
}

haproxy_controller() {
	cmd haproxy-controller cluster-endpoint
}

haproxy_etcd() {
	cmd haproxy-etcd etcd-endpoint
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
