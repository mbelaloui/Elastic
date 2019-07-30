#!/bin/bash

DFILE="1rCO6XI38DM7ScvUluoHXmg-HWHRbmJR1"
JDK="jdk-11-0-3.tar.gz"
JDK_TEMP_FILE="jdk-11.0.3"
JDK_FILE="jdk-11"
JDK_DIR="/usr/java"
JAVA_PATH=${JDK_DIR}/${JDK_FILE}"/bin"

#################################################################
(sudo apt-get update && sudo apt-get upgrade && sudo apt-get purge) > /dev/null
(sudo apt-get install -y sudo openssh-server git curl unzip) > /dev/null

#################################################################
if [ ! -f ${JDK_TEMP_FILE} ]; then
	git clone https://github.com/circulosmeos/gdown.pl.git > /dev/null
	cp gdown.pl/gdown.pl ./gdown
	sudo ./gdown https://drive.google.com/open?id=${DFILE} ${JDK}
	tar -xvf ${JDK} > /dev/null
	rm -fr ${JDK} gdown.pl gdown
fi

################################################################
if [ -d ${JDK_DIR} ]; then
	sudo rm -fr ${JDK_DIR}
fi
sudo mkdir ${JDK_DIR}
sudo mv -f ${JDK_TEMP_FILE} ${JDK_DIR}/${JDK_FILE}

#################################################################
#		exporting java Path				#
echo "PATH=${JAVA_PATH}:$PATH
export JAVA_HOME=${JAVA_PATH}" >> ~/.bashrc
. ~/.bashrc
echo "set-Up the Node done."
#################################################################


#################################################################
#  to add							#
# creat a file to store the ssl/tsl certificates 		#
# mkdir /usr/shar/cert/ .... is this a goos file to store certs #
#								#
# run the script that generat the certs automaticly 		#
# giving to it a pass that secure:				#
#	the CA							#
#    and							#
#	the nodes						#
# we can call the main_ssl_gen.sh from here by 			#

#echo "generating the ssl/tls certificat Authority and certificat node"
#echo "please change the default password..."

#################################################################
#this part is executer only in one of the master node.
#it's should be different from conf to conf
#sh ../cert/main_ssl_gen.sh 					
#################################################################
#	aftere generating script 
#	send the generated sert to the node
#	try to get all the node withe there user-[ip, hostname] and scp the file to all of them 
#	we should befor creat the directory to send in the sertificate in all the node
#	user the 'elastic_conf_cert.yml' or a dirivent
#  do this for all the node
#	scp /etc/path_to_sert user@192.168.1.x:chemin/de/réception/
#################################################################

echo "
10.2.1.197	elasticsearch-node-1
10.2.1.174	elasticsearch-node-2
10.2.1.90	elasticsearch-node-3
" >> /etc/hosts

