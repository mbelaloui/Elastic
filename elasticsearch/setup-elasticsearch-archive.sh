curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.2.0-linux-x86_64.tar.gz
tar -xvf elasticsearch-7.2.0-linux-x86_64.tar.gz
###########################################################3
# NB it's not the safe way to run elasticsearch it's just for test
#echo "vm.max_map_count=262144" >> /etc/sysctl.conf
#sysctl -w vm.max_map_count=262144
#cp elastic_conf.yml elasticsearch-7.2.0/config/elasticsearch.yml
