#!/bin/bash

CA_GEN_FILE=$(readlink -f cert/ca_gen_deb.sh)
CERT_NODE_GEN_FILE=$(readlink -f cert/cert_get_deb.sh)
CA_PassWord=qwerty 			#secret
URL_CONF_FILE=$(readlink -f cert/elastic_conf_cert.yml)
NODES_PassWord=node			#secret
CERT_URL_FILE=/usr/share/elasticsearch/cert

if [ -d ${CERT_URL_FILE} ]; then
	echo "The file existe please check what's inside"
	#exit 0
else
	echo "Creating the output file ${CERT_URL_FILE}"
	mkdir ${CERT_URL_FILE}
fi

echo "[${CA_GEN_FILE}]"
echo "[${CERT_NODE_GEN_FILE}]"

if [ -f ${CA_GEN_FILE} ] && [ -f ${CERT_NODE_GEN_FILE} ]; then
	sh ${CA_GEN_FILE} ${CA_PassWord} && sh ${CERT_NODE_GEN_FILE} ${CA_PassWord} ${URL_CONF_FILE} ${NODES_PassWord}
else
	echo "usage : \n\t please check the url of the ca gen file and cert node gen file"
fi
