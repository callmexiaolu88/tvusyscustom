#!/bin/bash
cd "${0%/*}"

set -e

echo "start elasticsearch and kibana"
./elastic/start.sh

echo "start fluent-bit"
./fluent-bit/stat.sh
