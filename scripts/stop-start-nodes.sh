#!/bin/bash

ACTION=start

haproxy() {
	multipass ${ACTION} haproxy-controller
	multipass ${ACTION} haproxy-etcd
}

controller() {
	for i in {0..2} ; do
		multipass ${ACTION} controller-${i}
	done
}

worker() {
	for i in {0..2} ; do
		multipass ${ACTION} worker-${i}
	done
}

etcd() {
	for i in {0..2} ; do
		multipass ${ACTION} etcd-${i}
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
	'stop')
		ACTION=stop
		haproxy
		controller
		worker
		etcd
		;;
	*)
		haproxy
		controller
		worker
		etcd
		;;
esac
