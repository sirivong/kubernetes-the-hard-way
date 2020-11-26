#!/bin/bash

delete_haproxy() {
	multipass delete haproxy
}

delete_controller() {
	for i in {0..2} ; do
		multipass delete controller-${i}
	done
}

delete_worker() {
	for i in {0..2} ; do
		multipass delete worker-${i}
	done
}

delete_etcd() {
	for i in {0..2} ; do
		multipass delete etcd-${i}
	done
}

case ${1} in
	'haproxy')
		delete_haproxy
		;;
	'controller')
		delete_controller
		;;
	'worker')
		delete_worker
		;;
	'etcd')
		delete_etcd
		;;
	*)
		delete_haproxy
		delete_controller
		delete_worker
		delete_etcd
		;;
esac

multipass purge
