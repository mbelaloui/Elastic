#!/bin/bash

DFILE="1rCO6XI38DM7ScvUluoHXmg-HWHRbmJR1"
JDK="jdk-11-0-3.tar.gz"
JDK_TEMP_FILE="jdk-11.0.3"
JDK_FILE="jdk-11"
JDK_DIR="/usr/java"
JAVA_PATH=${JDK_DIR}/${JDK_FILE}"/bin"

#################################################################
(sudo apt update && sudo apt upgrade && sudo apt purge) > /dev/null
(sudo apt install -y sudo openssh-server git) > /dev/null

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

#################################################################
