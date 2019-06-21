#!/bin/bash

package_name=elastic-7.1.1.tar.gz
TMP=/tmp
ELK_REPO='/etc/apt/sources.list.d/elastic-7.x.list'

#update package and dependencies
sudo apt update -y && sudo apt -y upgrade && sudo apt purge

#install the ELK public key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#install apt repository
sudo apt install -y apt-transport-https

#add the elastic repository
if [ ! -f $ELK_REPO ]; then
	echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a $ELK_REPO
else
	grep "^deb https://artifacts.elastic.co/packages/7.x/apt stable main$" /etc/apt/sources.list.d/elastic-7.x.list 
	ret=$?
	if [ ! $ret = 0 ]; then
		echo "do not exist"
		echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a $ELK_REPO
	else
		echo "exist"
	fi
fi

#install elastic package
sudo apt update -y && sudo apt -y install elasticsearch




#curl -o "/tmp/elastic-7.1.1.tar.gz" -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-linux-x86_64.tar.gz 
#tar -xvf ${TMP}/${package_name} 

