#/bin/bash

PEM_CERT_NAME="My-ELK-Cert-pem.zip"
PKI_CERT_NAME="My-ELK-Cert-pki.zip"

PEM_CA_NAME="My-ELK-Ca.zip"
DEFAULT_CA_NAME="My-ELK-Ca.p12"
#PKI_CA_NAME="My-ELK-Ca.p12"    a mettre a jour

#DEFAULT_CERT_NAME="My-ELK-Cert.zip"

DEFAULT_CA_VALIDITY_DAYS=60
RSA_KEY_SIZE=2048

#CERTBIN=/usr/share/elasticsearch/bin/elasticsearch-certutil
CERTBIN=bin/elasticsearch-certutil
US=${USER}

CA_PART ()
{
	echo "Certificat Authority"
	echo ${US}
	if [ "$1" -eq 1 ]
	then
		#echo "Please, entre <transport> "
		# ask the user if its for the transport or http protocole
		##ask for the format [.p12 or the .pem]   default .p12
		### if .pem build an other commande or try to add --pem to this

		#### add directory chois
		#### the size of the rsa size key default 1024
		#a confirmer si c'est pour la CA ou pour tout les sertificats generer par la CA
		#echo -n "Please, enter the number of the days that the generated certificat : [default: ${DEFAULT_VALIDITY_DAYS}]"

#--------------------------------days validity----------------------------------------------------------------------------------------
		CA_DAYS=$DEFAULT_CA_VALIDITY_DAYS

		#### if the name alrady existe ask user if we can remove or rename the new one
		##ask for the format     default .p12

#--------------------------------Password Ca------------------------------------------------------------------------------------------
		echo -n "Please enter the key of the Ca : "
		read -s CA_KEY
		echo ""

#----------------------------------type Ca--------------------------------------------------------------------------------------------
	#	-----------------Name output-----------------
		echo -n "Please enter the type of CA cert [pem / pk12 ] : "
		read TYPE_CA
		echo ""

		if [ "$TYPE_CA" == "pem" ]
		then
			OUTPUT_CA=${PEM_CA_NAME}
	
			echo -n "Please, enter the name of the out put Certificat : [default: ${PEM_CA_NAME}]"
			read OUTPUT_CA
			if [ -z "$OUTPUT_CA" ]
			then
				OUTPUT_CA=${PEM_CA_NAME}
			else
				OUTPUT_CA+=".zip"
			fi
		elif [ "$TYPE_CA" == "pk12" ]
		then
			OUTPUT_CA=${DEFAULT_CA_NAME}

			echo -n "Please, enter the name of the out put Certificat : [default: ${DEFAULT_CA_NAME}]"
			read OUTPUT_CA
			if [ -z "$OUTPUT_CA" ]
			then
				OUTPUT_CA=${DEFAULT_CA_NAME}
			else
				OUTPUT_CA+=".p12"
			fi

		else
			echo "Error wrong type of cert, the script will exit !."
			exit 0
		fi
	
	
		#echo "$OUTPUT_CA"

#---------------------------------run the conf----------------------------------------------------------------------------------------
		if [ -f "${CERTBIN}" ]
		then
			echo "Generating the Certificat Authority."
			if [ "$TYPE_CA" == "pem" ]
			then
				echo "pem ca gen..."
				sudo ${CERTBIN} ca --pass ${CA_KEY}\
				--pem --silent --out "${PWD}/${OUTPUT_CA}" --days $CA_DAYS --keysize ${RSA_KEY_SIZE}
			else 		#	if [ "$TYPE_CA" == "pk12" ]then
				echo "pk12 ca gen..."
				sudo ${CERTBIN} ca --pass ${CA_KEY}\
				--silent --out "${PWD}/${OUTPUT_CA}" --days $CA_DAYS --keysize ${RSA_KEY_SIZE}
			fi
			sudo chown ${US}:${US} ${PWD}/${OUTPUT_CA}
			echo "The certificate Authority is succesfuly created."
			echo "The Destination file is in the curent directory \"${PWD}/${OUTPUT_CA}\""
		else
			echo "Error: no elasticsearch-certutil found make sur that you're yousing the right setup script."
			echo "This script is used for the deb instalation."
		fi
	elif [ "$1" -eq 2 ] && [ $3 == 'h' ]
	then
		echo "Sorry, still under construction"
	else
		CA_USAGE
	fi
}

CERT_PART()
{
	echo "Nodes Certificats"
	if [ "$1" -eq 4 ]
	then
		FILE_NODES_CONF=$(readlink -f $5)
		CA_KEY=$(readlink -f $3)
		CA_CERT=$(readlink -f $4)

		echo ${CERTBIN}
#--------------------------------Password Ca------------------------------------------------------------------------------------------
		echo -n "Please enter the key of the Ca : "
		read -s CA_PASS
		echo ""
#--------------------------------Password Nodes---------------------------------------------------------------------------------------
		echo -n "Please enter the key of the Nodes : "
		read -s NODE_KEY
		echo ""

#----------------------------------type Cert------------------------------------------------------------------------------------------
	#  	 -----------------Name output-----------------
		echo -n "Please enter the type of Cert [ pem / pk12 ] : "
		read TYPE_CERT
		echo ""
		if [ "$TYPE_CERT" == "pem" ]
		then
			OUTPUT_CERT=${PEM_CERT_NAME}
	
			echo -n "Please, enter the name of the out put Certificat pem : [default: ${PEM_CERT_NAME}]"
			read OUTPUT_CERT
			if [ -z "$OUTPUT_CERT" ]
			then
				OUTPUT_CERT=${PEM_CERT_NAME}
			else
				OUTPUT_CERT+="-pem.zip"
			fi
		elif [ "$TYPE_CERT" == "pk12" ]
		then
			OUTPUT_CERT=${PKI_CERT_NAME}

			echo -n "Please, enter the name of the out put Certificat pk12 : [default: ${PKI_CERT_NAME}]"
			read OUTPUT_CERT
			if [ -z "$OUTPUT_CERT" ]
			then
				OUTPUT_CERT=${PKI_CERT_NAME}
			else
				OUTPUT_CERT+="-pki.zip"
			fi

		else
			echo "Error wrong type of cert, the script will exit !."
			exit 0
		fi
	
	
		#echo "$OUTPUT_CA"


#--------------------------------Run Script-------------------------------------------------------------------------------------------
		if [ -f "${CERTBIN}" ]; then
			echo "Generating the Cluster node certificats."
			if [ "$TYPE_CERT" == "pem" ]
			then
				sudo ${CERTBIN} cert \
				--ca-cert ${CA_CERT}\
				--ca-key ${CA_KEY}\
				--ca-pass ${CA_PASS}\
				--in ${FILE_NODES_CONF} \
				--out "${PWD}/${OUTPUT_CERT}" \
				--pass ${NODE_KEY} \
				--silent \
				--pem
			elif [ "$TYPE_CERT" == "pk12" ]
			then
				sudo ${CERTBIN} cert \
				--ca-cert ${CA_CERT}\
				--ca-key ${CA_KEY}\
				--ca-pass ${CA_PASS}\
				--in ${FILE_NODES_CONF} \
				--out "${PWD}/${OUTPUT_CERT}" \
				--pass ${NODE_KEY} \
				--silent
			fi	
			sudo chown ${US}:${US} ${PWD}/${OUTPUT_CERT}
			echo "The certificates are succesfuly created."
			echo "The Destination file is ${PWD}/${OUTPUT_CERT}"
		else
			#echo "2 $2 -- 3  $3  -- 4 $4  --5  $5  key [${CA_KEY}]  cert[${CA_CERT}]"
			echo "Error: no elasticsearch-certutil found make sur that you're yousing the right setup script."
			echo "This script is used for the deb instalation."
		fi

	elif [ "$1" -eq 2 ] && [ "$3" == 'h' ]
	then
		echo "Sorry the usage is still under construction"
	else
		CERT_USAGE
	fi
}

CERT_USAGE()
{
	echo -e "\t\tCertificate Nodes Usage :"
	echo -e "\t\t\t cert [option] | [[URL_CA-KEY URL_CA_CERT conf_file] [file_conf_Nodes.yml]]"
	echo -e "\t\t\t\t option :"
	echo -e "\t\t\t\t\t h         : -\t Explaine how to use the cert commande."

}

CA_USAGE()
{
	echo -e "\t\tCertificate Authority Usage :"
	echo -e "\t\t\tca [options]"
	echo -e "\t\t\t\t option :"
	echo -e "\t\t\t\t\t transport : -\t It's the defautl value of protocole."
	echo -e "\t\t\t\t\t http      : -"
	echo -e "\t\t\t\t\t h         : -\t Explaine how to use the ca commande.\n"

	# ask the user if its for the transport or http protocole
	# p12 for the inter connexion between elasticsearch node  <transport>
	#.pem for the extra elasticsearch nodes >kibana/beats/logstash< nodes <http>
}

USAGE()
{
	echo "$0 [Commade] [options]"
	echo -e "\n\tCommandes :"
	echo -e "\t\tca\t\t To generate Certificate Authority."
	echo -e "\n\t\tcert\t\t To generate Node Certificate."
	echo -e "\n\t\t\t----------------------------------------------"
	CA_USAGE
	echo -e "\t\t\t----------------------------------------------"
	CERT_USAGE
}

if [ "$1" ==  "ca" ]
then
	CA_PART $# $*
elif [ "$1" == "cert" ]
then
	CERT_PART $# $*
else
	USAGE
fi

