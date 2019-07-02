#!/bin/bash

DFILE="1rCO6XI38DM7ScvUluoHXmg-HWHRbmJR1"
JDK="jdk-11-0-3.tar.gz"
JDK_TEMP_FILE="jdk-11.0.3"
JDK_FILE="jdk-11"
JDK_DIR="/usr/java"
JAVA_PATH=${JDK_DIR}/${JDK_FILE}"/bin"

#################################################################
(sudo apt-get update && sudo apt-get upgrade && sudo apt-get purge) > /dev/null
(sudo apt-get install -y sudo openssh-server git curl) > /dev/null

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
export PATH" >> ~/.bashrc
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

echo "generating the ssl/tls certificat Authority and certificat node"
echo "please change the default password..."

sh cert/main_ssl_gen.sh 					
#################################################################

