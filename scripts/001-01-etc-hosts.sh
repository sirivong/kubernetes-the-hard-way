#!/usr/bin/env bash

HOSTS_FILE=hosts.txt
UPDATE_SCRIPT=/usr/sbin/update-etc-hosts

echo '#!/usr/bin/env bash' > ${UPDATE_SCRIPT}
IFS=$'\n'
for e in $(cat ${HOSTS_FILE}); do
	IP=$(echo $e | awk '{print $1}')
	HOST=$(echo $e | awk '{print $2}')
	cat <<EOD >> ${UPDATE_SCRIPT}
grep '${HOST}' /etc/hosts &> /dev/null
if [[ \$? > 0 ]]; then
	EXTRA_HOST=''
	if [[ '${HOST}' = 'haproxy-controller' ]]; then
		EXTRA_HOST=' cluster-endpoint'
	elif [[ '${HOST}' = 'haproxy-etcd' ]]; then
		EXTRA_HOST=' etcd-endpoint'
	fi
	echo "${IP} ${HOST}\${EXTRA_HOST}" >> /etc/hosts
fi
EOD
done
chmod 755 ${UPDATE_SCRIPT}

cat <<EOD > /etc/systemd/system/etc-hosts.service
[Unit]
Description=Update Etc Hosts
Before=kubelet.service
After=systemd-resolved.service

[Service]
Type=oneshot
ExecStart=/usr/sbin/update-etc-hosts
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target kubelet.service
Alias=etc-hosts.service
EOD

systemctl daemon-reload
systemctl enable etc-hosts
