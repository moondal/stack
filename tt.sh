#!/bin/bash

# Required field
VERSION=9.0.39
PREFIX=/data/was


cd /tmp
wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz -P /tmp
tar -xf apache-tomcat-$VERSION.tar.gz
mkdir -p /data/was
mv /tmp/apache-tomcat-$VERSION /tmp/was
mv /tmp/was /data
~

