#!/bin/bash

CA_PASS=$1
FILE_CONF=$2
NODE_PASS=$3
CERT_DEST=/usr/share/elasticsearch/cert/cert.zip
CA_DEST=/usr/share/elasticsearch/cert/elastic-stack-ca.p12


if [ -z $CA_PASS ] || [ ! -f $FILE_CONF ] || [ -z $NODE_PASS ]; then
	echo "usage : \n\t ./$0 'CA_PassWord' 'URL_CONF_FILE' 'Nodes_PassWord'"
else
	if [ -f "/usr/share/elasticsearch/bin/elasticsearch-certutil" ]; then
		echo "Generating the Cluster node certificats."
		/usr/share/elasticsearch/bin/elasticsearch-certutil cert \
		       --in ${FILE_CONF} \
		       --out ${CERT_DEST} \
		       --ca ${CA_DEST} \
		       --ca-pass ${CA_PASS} \
		       --pass ${NODE_PASS} \
		       --silent
		echo "The certificates are succesfuly created."
		echo "The Destination file is ${CERT_DEST}"
	else
		echo "Error: no elasticsearch-certutil found make sur that you're yousing the right setup script."
		echo "This script is used for the deb instalation."
	fi
fi

# check if the output existe and ...
