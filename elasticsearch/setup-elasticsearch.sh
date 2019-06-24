#!/bin/bash

ELK_REPO='/etc/apt/sources.list.d/elastic-7.x.list'
NAME=elasticsearch

#update package and dependencies
#ckage and dependencies
(sudo apt-get update -y && sudo apt-get -y upgrade && sudo apt-get purge) > /dev/null

#install the ELK public key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#install apt repository
(sudo apt-get install -y apt-transport-https) > /dev/null

#add the elastic repository
if [ ! -f $ELK_REPO ]; then
	echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a $ELK_REPO
else
	grep "^deb https://artifacts.elastic.co/packages/7.x/apt stable main$" /etc/apt/sources.list.d/elastic-7.x.list 
	ret=$?
	if [ ! $ret = 0 ]; then
		echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a $ELK_REPO
	fi
fi

#install elastic package
(sudo apt-get update -y && sudo apt-get -y install ${NAME}) 
sudo systemctl enable ${NAME}

#if we run the elasticsearch in dev mode in local that will work fine with out any config just start the service
#if we run the elasticsearch in prod or in a Vm with bridged network mode [to make the node richable frome the externes machines] we have to do some more configuration in the /etc/elasticsearch/elasticsearch.yml see the ReadMe for more details 
# to start the elasticsearch <systemctl restart elasticsearch>
sudo cp elastic_conf.yml /etc/elasticsearch/elasticsearch.yml

sudo systemctl restart ${NAME}
echo "${NAME} successfully installed and enabled please change the node name and the cluster name in /etc/elasticsearch/elasticsearch.yml"
