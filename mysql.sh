#!/bin/bash

#common -> libs -> libs-compat -> embedded -> embedded-devel -> client -> server 순서로 설치
wget --no-check-certificate https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar
#설치파일 압축해제
tar xvf mysql-5.7.22-1.el7.x86_64.rpm-bundle.tar

#기존 lib 삭제
yum remove -y mariadb-libs*

#압축 해제한 파일 로컬 설치

yum localinstall -y mysql-community-common-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-libs-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-libs-compat-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-devel-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-embedded-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-embedded-devel-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-client-5.7.22-1.el7.x86_64.rpm
yum localinstall -y mysql-community-server-5.7.22-1.el7.x86_64.rpm

systemctl start mysqld

#기본 엔진 설정
echo default_storage_engine = InnoDB >> /etc/my.cnf
#InnoDB 메모리 설정
read -p "innodb_buffer_pool_size ?" MEM
echo innodb_buffer_pool_size="$MEM"G >> /etc/my.cnf
#OS Swap 사용 X
echo innodb_flush_method=O_DIRECT >> /etc/my.cnf
#transaction 의 redo log 를 저장하는 로그 파일의 사이즈
echo innodb_log_file_size=256M >> /etc/my.cnf
#log 파일을 기록하기 위한 버퍼 사이즈, 트랜잭션 크기가 큰경우 높게 설정
echo innodb_log_buffer_size=32M >> /etc/my.cnf
#InnoDB 쓰레드 설정 (0=무한대)
echo innodb_thread_concurrency=0 >> /etc/my.cnf
#InnoDB 읽기/쓰기 쓰레드 설정
echo innodb_write_io_threads=8 >> /etc/my.cnf
#InnoDB queue에 접근하기 전 thread sleep delay 시간
echo innodb_thread_sleep_delay=0 >> /etc/my.cnf
#동시에 commit할 수 있는 thread 수
echo innodb_commit_concurrency=20 >> /etc/my.cnf
#쿼리를 mysql에서 가져오지 않고 캐시에서 가져와 속도를 크게 높여주는 기술
echo query_cache_type = 1 >> /etc/my.cnf
#데이터베이스 내 테이블당 ibd 파일로 데이터 저장 // 0일경우 idb 통으로 저장
echo innodb_file_per_table = 1 >> /etc/my.cnf
#buffer pool에 있는 내용을 flush 할때 같은 extent에 있는 다른 dirty page 들까지도 같이 flush 할지 설정할 수 있다.
echo innodb_flush_neighbors = 0 >> /etc/my.cnf
#최대 커넥션 개수
echo max_connections=1000 >> /etc/my.cnf

systemctl restart mysqld

echo -e '###mysql PASSWORD###'
cat /var/log/mysqld.log | grep 'temporary password' | cut -d ' ' -f11
