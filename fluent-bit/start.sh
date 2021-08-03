#!/bin/bash
cd "${0%/*}"

set -e

containerName=fluent-bit

echo 'remove container [$containerName]'
for id in $(docker ps --filter name=$containerName -q)
do
  docker rm -f $id
done

docker run -d --name $containerName -it -p 24224:24224 -v $(pwd)/scripts/:/scripts/ fluent/fluent-bit:1.7 /fluent-bit/bin/fluent-bit -i forward -o es -p Host=10.12.32.91 -p Port=9200 -p Index=docker-fluent-bit -F lua -p script=/scripts/append_tag.lua -p call=append_tag -m '*'