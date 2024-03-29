#!/bin/sh

if [ -z "$(docker ps -a --filter name=rtmp-server -q)" ] 
then
  echo "create container [rtmp-server]"
  #docker run -d -p 1935:1935 --name rtmp-server tiangolo/nginx-rtmp
  #docker run -d -p 8080:8080 -p 1935:1935 --name rtmp-server alqutami/rtmp-hls
  docker run -d -p 1935:1935 --name rtmp-server alqutami/rtmp-hls
  echo "saving image [tiangolo/nginx-rtmp] to [/data/dockerimages/nginx-rtmp]"
  docker save -o /data/dockerimages/nginx-rtmp tiangolo/nginx-rtmp
else
  echo "start container [rtmp-server]"
  docker start rtmp-server
fi