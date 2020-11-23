#!/bin/bash

# Required field
SERVER=httpd
VERSION=2.4.46
PREFIX=/data/web
ARCHIVE_PATH=/tmp
UNARCHIVE_PATH=$ARCHIVE_PATH/"$SERVER"-"$VERSION"
MIRROR_SITE=downloads.apache.org
ARCHIVE_FILE="$SERVER"-"$VERSION".tar.gz
packages="apr-devel apr-util-devel pcre-devel wget vim gcc gcc-c++ httpd-devel"


### Commnad field
mkdir -p $PREFIX

yum -y install $packages
wget -q -N http://$MIRROR_SITE/$SERVER/$ARCHIVE_FILE -P $ARCHIVE_PATH
tar zxvf /tmp/$ARCHIVE_FILE

cd "$SERVER"-"$VERSION"
make clean
./configure --prefix=$PREFIX --enable-mpms-shared=all --enable-mime-magic
make && make install

#Start, PATH,
echo '###Apache Server Path###'
echo -e $PREFIX/bin
