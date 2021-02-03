#!/bin/bash
cd "${0%/*}"

set -e

#enable root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart ssh.service

#change root password
echo "root:P1dkme17tvU" | chpasswd

#install lldb
apt-get update
apt-get install lldb

#link docker-compose
ln -s $(pwd)/dockertools/docker-compose /usr/bin/docker-compose

#start harbor and save images
bash harbor/start.sh
bash harbor/saveimages.sh

#copy ca
mkdir -p /etc/docker/certs.d/10.12.32.91/
cp -u certification/ca.crt certification/server.key certification/server.cert /etc/docker/certs.d/10.12.32.91/
#scp tvu@10.12.32.91:/data/syscustom/certification/ca.crt /etc/docker/certs.d/10.12.32.91/

#try load local image
[ -d "/data/dockerimages" ] && for item in /data/dockerimages/* ; do echo "load $item"; docker load -i $item; done

#build webr image and push to harbor
bash webrImage/build.sh

#add cron job for build image
echo "0 */4 * * * root bash $(pwd)/webrImage/build.sh" >> /etc/crontab
systemctl restart cron.service

#execute tool scripts
[ -d "toolscripts" ] && for sc in toolscripts/* ; do echo "execute $sc"; bash $sc; done