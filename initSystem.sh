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

#enable ipv4.forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -p

#try load local image
[ -d "/data/dockerimages" ] && for item in /data/dockerimages/* ; do echo "load $item"; docker load -i $item; done

#start harbor and save images
bash harbor/start.sh
bash harbor/saveimages.sh

#copy ca
mkdir -p /etc/docker/certs.d/10.12.32.91/
cp -u certification/ca.crt certification/server.key certification/server.cert /etc/docker/certs.d/10.12.32.91/
#scp tvu@10.12.32.91:/data/syscustom/certification/ca.crt /etc/docker/certs.d/10.12.32.91/

#build webr image and push to harbor
bash webrImage/build.sh

#add cron job for build image
echo "0 */4 * * * root bash $(pwd)/webrImage/build.sh" >> /etc/crontab
systemctl restart cron.service

#execute tool scripts
[ -d "toolscripts" ] && for sc in toolscripts/* ; do echo "execute $sc"; bash $sc; done

#deploy ssh keys
rm -f /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
ln -s /data/syscustom/sshkeys/id_rsa /root/.ssh/id_rsa
ln -s /data/syscustom/sshkeys/id_rsa.pub /root/.ssh/id_rsa.pub

#install vsdbg on ~/vsdbg
curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l ~/vsdbg

#link nightlyUpdate
ln -s $(pwd)/nightlyUpdate.sh /bin/nightlyUpdate

#configure confd
mkdir -p /etc/confd/{conf.d,templates}
ln -s /data/syscustom/confd/confd /bin/confd
cp /data/syscustom/confd/confd.toml /etc/confd/
cp /data/syscustom/confd/conf.d/* /etc/confd/conf.d/
cp /data/syscustom/confd/templates/* /etc/confd/templates/