#!/bin/bash

grep cluster-endpoint /etc/hosts &> /dev/null
if [[ $? > 0 && -e cluster-endpoint.txt ]]; then
	cat cluster-endpoint.txt >> /etc/hosts
fi
