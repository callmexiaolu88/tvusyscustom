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
curl -O http://10.12.20.54/jenkins/job/Nightly-WebR-Vue/lastSuccessfulBuild/artifact/*zip*/archive.zip; \
unzip archive.zip archive/opt-WebR*.tar.xz; \
cd archive; \
tar xvf opt-WebR*.tar.xz; \
mv opt /; \
cd ..; \
rm -Rf archive archive.zip; \
if [ '$type' == 'proxy' ] ; then \
curl -O http://10.12.20.54/jenkins/view/All/job/ReceiverSetting3-NETCore/lastSuccessfulBuild/artifact/*zip*/archive.zip; \
unzip archive.zip archive/opt-Setting3*.tar.xz; \
cd archive; \
tar xvf opt-Setting3*.tar.xz opt/tvu/web/setting3; \
mv opt/tvu/web/setting3 /Setting3; \
cd ..; \
rm -Rf archive archive.zip; \
curl -O http://10.12.20.54/jenkins/view/All/job/TVUFTPUploadService-NETCore/lastSuccessfulBuild/artifact/*zip*/archive.zip; \
unzip archive.zip archive/opt-FTPUploadService*.tar.xz; \
cd archive; \
tar xvf opt-FTPUploadService*.tar.xz opt/tvu/web/ftpupload; \
mv opt/tvu/web/ftpupload /FTPUploadService; \
cd ..; \
rm -Rf archive archive.zip; \
fi"
