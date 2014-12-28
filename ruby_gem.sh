#!/usr/bin/env bash

yum update

#▼Rails用ライブラリインストール
yum install -y zlib-devel
yum install -y openssl-devel

#▼Rubyインストール
pushd /tmp
curl -k -o ruby-2.1.2.tar.gz https://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
tar zxvf ruby-2.1.2.tar.gz
pushd ruby-2.1.2
./configure
make && make install
popd	
popd

#▼Railsインストール
gem install rails

#▼PostgreSQLインストール
pushd /tmp
curl -k -o pgdg-centos94-9.4-1.noarch.rpm http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
rpm -ivh pgdg-centos94-9.4-1.noarch.rpm
#yum grouplist | grep PostgreSQL
yum groupinstall "PostgreSQL Database Server 9.4 PGDG"
/etc/init.d/postgresql-9.4 initdb
chkconfig postgresql-9.4 on
popd

