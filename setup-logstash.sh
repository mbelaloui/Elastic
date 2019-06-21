#!/bin/bash

ELK_REPO='/etc/apt/sources.list.d/elastic-7.x.list'
NAME=logstash

#update package and dependencies
(sudo apt update -y && sudo apt -y upgrade && sudo apt purge) > /dev/null

#install the ELK public key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#install apt repository
(sudo apt install -y apt-transport-https) > /dev/null

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
(sudo apt update -y && sudo apt -y install ${NAME})



#save the return value of the install cmd and look if its successful

sudo systemctl enable ${NAME}

#if we run the elasticsearch in dev mode in local that will work fine with out any config just start the service
#if we run the elasticsearch in prod or in a Vm with bridged network mode [to make the node richable frome the externes machines] we have to do some more configuration in the /etc/elasticsearch/elasticsearch.yml see the ReadMe for more details 
# to start the elasticsearch <systemctl restart elasticsearch>


sudo systemctl restart ${NAME}

echo "${NAME} successfully installed and enabled"
