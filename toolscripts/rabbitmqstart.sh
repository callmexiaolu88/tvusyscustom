#!/bin/sh

if [ -z "$(docker ps -a --filter name=rabbit-server -q)" ] 
then
  echo "create container [rabbit-server]"
  docker run -d --name rabbit-server -e RABBITMQ_DEFAULT_USER=tvu -e RABBITMQ_DEFAULT_PASS=P1dkme17tvU -p 15672:15672 rabbitmq:3-management
  echo "saving image [rabbitmq:3-management] to [/data/dockerimages/rabbitmq:3-management]"
  docker save -o /data/dockerimages/rabbitmq:3-management rabbitmq:3-management
else
  echo "start container [rabbit-server]"
  docker start rabbit-server
fi