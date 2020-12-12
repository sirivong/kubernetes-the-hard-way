#!/bin/bash

stop_haproxy() {
	multipass stop haproxy-controller
	multipass stop haproxy-etcd
}

stop_controller() {
	for i in {0..2} ; do
		multipass stop controller-${i}
	done
}

stop_worker() {
	for i in {0..2} ; do
		multipass stop worker-${i}
	done
}

stop_etcd() {
	for i in {0..2} ; do
		multipass stop etcd-${i}
	done
}

case ${1} in
	'haproxy')
		stop_haproxy
		;;
	'controller')
		stop_controller
		;;
	'worker')
		stop_worker
		;;
	'etcd')
		stop_etcd
		;;
	*)
		stop_haproxy
		stop_controller
		stop_worker
		stop_etcd
		;;
esac
