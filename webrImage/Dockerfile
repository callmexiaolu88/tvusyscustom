FROM 10.12.32.91/library/webr-nginx
ARG type=proxy
ARG rport
ARG rws
ENV RHOST=127.0.0.1
ENV RPORT=${rport:-8288}
ENV RWS=${rws:-8288}
ENV PID=0000000000000000
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/NginxConf
COPY default.conf /etc/nginx/conf.d/
COPY template/WebR-$type.conf.template /etc/nginx/templates/
COPY index.html /www/
COPY certification/* /certification/
RUN /bin/bash -c "mkdir /etc/nginx/NginxConf; \
cd /; \
curl -O http://10.12.20.54/jenkins/job/Nightly-WebR-Vue/lastSuccessfulBuild/artifact/WebR2.tgz; \
tar xvf WebR2.tgz; \
rm -f WebR2.tgz; \
if [ '$type' == 'proxy' ] ; then \
curl -O http://10.12.20.54/jenkins/view/All/job/ReceiverSetting3/lastSuccessfulBuild/artifact/Setting3-linux.tar.xz; \
tar xvf Setting3-linux.tar.xz Setting3/Setting3/WebGUI; \
mv Setting3/Setting3/WebGUI/* Setting3/; \
rm -Rf Setting3-linux.tar.xz Setting3/Setting3; \
curl -O http://10.12.20.54/jenkins/view/All/job/TVUFTPUploadService-x64-vs2017/lastSuccessfulBuild/artifact/*zip*/archive.zip; \
unzip archive.zip archive/opt-FTPUploadService*.tar.xz; \
cd archive; \
tar xvf opt-FTPUploadService*.tar.xz opt/tvu/FTPUploadService/Web; \
mv opt/tvu/FTPUploadService/Web /FTPUploadService; \
cd ..; \
rm -Rf archive archive.zip; \
fi"
