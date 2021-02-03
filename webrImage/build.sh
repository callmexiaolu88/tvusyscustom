#!/bin/bash
cd "${0%/*}"

set -e

webrdirect="10.12.32.91/library/webr-direct"
webrproxy="10.12.32.91/library/webr-proxy"

echo "======remove containers======"
echo "remove containers which start with $webrdirect"
for id in $(docker ps -a --filter ancestor=$webrdirect -q)
do
  docker rm -f $id
done
echo "remove containers which start with $webrproxy"
for id in $(docker ps -a --filter ancestor=$webrproxy -q)
do
  docker rm -f $id
done
echo "======remove containers end======"

echo "======remove images======"
echo "remove image $webrdirect"
for id in $(docker images --filter reference=$webrdirect -q)
do
  docker rmi $id
done
echo "remove image $webrproxy"
for id in $(docker images --filter reference=$webrproxy -q)
do
  docker rmi $id
done
echo "======remove images end======"

echo "======build latest $webrdirect======"
docker build -t $webrdirect --build-arg type=direct --build-arg rport=3582 --build-arg rws=8298 .
echo "======build latest $webrdirect end======"

echo "======build latest $webrproxy======"
docker build -t $webrproxy .
echo "======build latest $webrproxy end======"

echo "======push image to harbor======"
docker login -u tvu -p P1dkme17tvU 10.12.32.91
docker push $webrdirect
docker push $webrproxy
echo "======push image to harbor end======"

echo "======start containers======"
docker run -d --name 23.66 -p 3366:80 -p 4366:443 -e RHOST=10.12.23.66 10.12.32.91/library/webr-direct
docker run -d --name 23.20 -p 3320:80 -p 4320:443 -e RHOST=10.12.23.20 10.12.32.91/library/webr-proxy
docker run -d --name 23.21 -p 3321:80 -p 4321:443 -e RHOST=10.12.23.21 10.12.32.91/library/webr-proxy
docker run -d --name 32.91 -p 3391:80 -p 4391:443 -e RHOST=10.12.32.91 10.12.32.91/library/webr-proxy
echo "======start containers end======"
