#!/bin/bash

cd ${0%/*}

docker-compose down -v
docker-compose up -d
