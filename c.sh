#!/bin/bash

# Required field
VERSION=1.2.48
WEB=/data/web
WAS=/data/was

#의존성 파일 설치
yum install httpd-devel gcc gcc-c++

#File Download
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-${VERSION}-src.tar.gz
tar zxvf /tmp/tomcat-connectors-${VERSION}-src.tar.gz
cd /tmp/tomcat-connectors-${VERSION}-src/native
./configure --with-apxs=/usr/bin/apxs
make && make install
cp /usr/lib64/httpd/modules/mod_jk.so ${WEB}/modules
sed -i '158 i\LoadModule jk_module modules/mod_jk.so' ${WEB}/conf/httpd.conf

echo -e "<IfModule jk_module>" >> ${WEB}/conf/httpd.conf
echo -e "Include conf/mod_jk.conf" >> ${WEB}/conf/httpd.conf
echo -e "</IfModule>" >> ${WEB}/conf/httpd.conf

echo -e "<IfModule mod_jk.c>" >> ${WEB}/conf/mod_jk.conf
echo -e "  JkWorkersFile conf/workers.properties" >> ${WEB}/conf/mod_jk.conf
echo -e "  JkLogFile logs/mod_jk.log" >> ${WEB}/conf/mod_jk.conf
echo -e "  JkLogLevel info" >> ${WEB}/conf/mod_jk.conf
echo -e '  JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "' >> ${WEB}/conf/mod_jk.conf
echo -e "  JkMountFile conf/uriworkermap.properties" >> ${WEB}/conf/mod_jk.conf
echo -e "</IfModule>" >> ${WEB}/conf/mod_jk.conf

echo -e "/*=worker1" >> ${WEB}/conf/uriworkermap.properties

echo -e "worker.list=worker1" >> ${WEB}/conf/workers.properties
echo -e "worker.worker1.type=ajp13" >> ${WEB}/conf/workers.properties
echo -e "worker.worker1.host=127.0.0.1" >> ${WEB}/conf/workers.properties
echo -e "worker.worker1.port=8009" >> ${WEB}/conf/workers.properties

sed -i '119 i\               secretRequired="false"' ${WAS}/conf/server.xml
sed -i '116s/<!--//' ${WAS}/conf/server.xml
sed -i '122d' ${WAS}/conf/server.xml
sed -i '118s/address="::1"/address="0.0.0.0"/' ${WAS}/conf/server.xml

