#!/bin/bash

if [ ! -z "$(docker images goharbor/* --format {{.Repository}})" ]
then
  echo "saving goharbor images to [/data/dockerimages/goharbor]"
  docker save -o /data/dockerimages/goharbor $(docker images goharbor/* --format {{.Repository}})
fi