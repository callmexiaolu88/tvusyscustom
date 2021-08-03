#!/bin/bash
cd "${0%/*}"

set -e

netName=elastic
elasticsearchName=elasticsearch
kibanaName=kibana

echo 'check network [$netName]'
if [[ -z $(docker network ls --filter name=$netName -q) ]]; then
  echo 'create network [$netName]'
  docker network create $netName
fi

echo 'check container [$elasticsearchName]'
for id in $(docker ps --filter name=$elasticsearchName -q)
do
  echo 'remove container [$elasticsearchName]'
  docker rm -f $id
done

echo 'create container [$elasticsearchName]'
docker run --name $elasticsearchName --net elastic -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" -v /data/elasticsearchdata:/usr/share/elasticsearch/data docker.elastic.co/elasticsearch/elasticsearch:7.13.2

echo 'check container [$kibanaName]'
for id in $(docker ps --filter name=$kibanaName -q)
do
  echo 'remove container [$kibanaName]'
  docker rm -f $id
done

echo 'create container [$kibanaName]'
docker run -d --name $kibanaName --net elastic -p 5601:5601 -e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" docker.elastic.co/kibana/kibana:7.13.2