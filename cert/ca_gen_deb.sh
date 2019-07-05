#!/bin/bash

PASS=$1
CERT_DEST=/usr/share/elasticsearch/cert/
OUT_PUT=elastic-stack-ca.p12

if [ -z $PASS ]; then
	echo "usage : \n\t $0 '\$CA_PassWord'"
else
	if [ -f "/usr/share/elasticsearch/bin/elasticsearch-certutil" ]; then
		echo "Generating the Certificat Authority."
		/usr/share/elasticsearch/bin/elasticsearch-certutil ca --pass ${PASS}\
		       	--silent --out ${CERT_DEST}${OUT_PUT}
		echo "The certificate Authority is succesfuly created."
		echo "The Destination file is ${CERT_DEST}"
		echo "The Name of the CA is ${OUT_PUT}"
	else
		echo "Error: no elasticsearch-certutil found make sur that you're yousing the right setup script."
		echo "This script is used for the deb instalation."
	fi
fi

### adding check if the out_put file existe say if the user want to overide it
