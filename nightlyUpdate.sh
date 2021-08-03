#!/bin/bash
set -e

if [ -z $1 ]; then
   echo "ERROR:must pass version number."
   exit 1
fi

project=${2:-"Nightly-LinuxR-NETCore"}

filename="opt-LinuxR-$1.tar.xz"

#change workspce to root
cd /

if [ -f $filename ]; then
  echo "INFO:remove $filename"
  rm -f $filename
fi

echo "INFO:dowloading $filename"
echo "http://10.12.20.54/jenkins/view/Nightly%20Builds/job/$project/$1/artifact/opt-LinuxR-$1.tar.xz"
wget "http://10.12.20.54/jenkins/view/Nightly%20Builds/job/$project/$1/artifact/opt-LinuxR-$1.tar.xz"

echo "INFO:stop R"
systemctl stop tvu.r
echo "INFO:remove original /opt/tvu/R"
rm -Rf /opt/tvu/R
echo "INFO:stop Auth"
systemctl stop tvu.auth
echo "INFO:remove original /opt/tvu/AuthCenter"
rm -Rf /opt/tvu/AuthCenter
echo "INFO:stop FTP upload"
systemctl stop tvu.ftpupload
echo "INFO:remove original /opt/tvu/FTPUploadService"
rm -Rf /opt/tvu/FTPUploadService
echo "INFO:remove original /opt/tvu/Web"
rm -Rf /opt/tvu/Web
echo "INFO:extract $filename"
tar xvf $filename
echo "INFO:copy config.xml and libraryconfig.xml"
\cp "/data/syscustom/rconfig/"* "/opt/tvu/R/"
echo "INFO:remove $filename"
rm -f $filename
echo "INFO:start FTP upload"
systemctl restart tvu.ftpupload
echo "INFO:start Auth"
systemctl restart tvu.auth
echo "INFO:start R"
systemctl restart tvu.r
echo "INFO:daemon-reload"
systemctl daemon-reload
