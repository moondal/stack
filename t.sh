#!/bin/bash

# Required field
VERSION=9.0.40
PREFIX=/data/was

#File Download
cd /tmp
wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz -P /tmp
tar -xf apache-tomcat-$VERSION.tar.gz
mkdir -p /data/was
mv /tmp/apache-tomcat-$VERSION /tmp/was
mv /tmp/was /data


#Start & Stop File Create
echo -e "./was/bin/shutdown.sh" >> /data/tomcat_stop.sh
echo -e "./was/bin/startup.sh" >> /data/tomcat_start.sh

chmod 775 /data/*.sh
