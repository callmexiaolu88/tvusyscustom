#!/bin/bash

version=${2:-"0.2.9"}
mode=${3:-"rm"}

docker run --net=host -t -d --privileged --device /dev/snd --$mode --ipc=host --name $1 -v /var/log:/var/log tvurtc/peerclient:$version peerclient -w wss://10.12.23.111:9091 -u $1 --hw-encoder=true --shared-encoder=false --vidcodec_name=H264 --audcodec_name=OPUS --video=true -p 0 -a A$1 -v V$1 --shm-enabled=true --width 640 --hight 360 --ambr=64 --vmbr=600 --vminbr=600 --port-start 60100 --port-count 100 --scaleby FAST_BILINEAR --stunserver turn:rtcturn.tvunetworks.com:13478 --stunserver turn:rtcturn.tvunetworks.com:13479 --stunserver turn:rtcturn-us.tvunetworks.com:13478 --stunserver stun:stun.l.google.com:19302 --stunserver stun:stun.sipgate.net --user-limit 60 --appLogLevel=28
