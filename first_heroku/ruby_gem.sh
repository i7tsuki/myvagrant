#!/usr/bin/env bash

yum update

#▼Rails用ライブラリインストール
yum install -y zlib-devel
yum install -y openssl-devel

#▼Rubyインストール
pushd /tmp
curl -k -o ruby-2.1.5.tar.gz https://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
tar zxvf ruby-2.1.5.tar.gz
pushd ruby-2.1.5
./configure
make && make install
popd	
popd

#▼Railsインストール
#/usr/local/bin/gem source list
/usr/local/bin/gem source --remove https://rubygems.org/
/usr/local/bin/gem source --add https://tokyo-m.rubygems.org/
#sudo chown -R vagrant:vagrant  /usr/local/lib/ruby/gems/2.1.0/
/usr/local/bin/gem install rails

#▼PostgreSQLインストール
pushd /tmp
curl -k -o pgdg-centos93-9.3-1.noarch.rpm http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
rpm -ivh pgdg-centos93-9.3-1.noarch.rpm
#yum grouplist | grep PostgreSQL
yum groupinstall -y "PostgreSQL Database Server 9.3 PGDG"
/etc/init.d/postgresql-9.3 initdb
chkconfig postgresql-9.3 on
popd

