#!/usr/bin/env bash

############################################################
#□□□注意：以下はCentOS6.5（※１）環境での実行コマンドであるので、他の環境では不必要な処理がある可能性がある。
#※１：使用したBOXのURL:https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
############################################################

#【ログ】Vagrant
#▼スクリプト共通設定
VAGRANT_HOME="/vagrant"
export VAGRANT_HOME="/vagrant"
VAGRANT_LOG=${VAGRANT_HOME}"/log"
export VAGRANT_LOG=${VAGRANT_HOME}"/log"
mkdir ${VAGRANT_LOG}
#▼スクリプト個別設定
LOG_NAME="rails_install.log"
export LOG_NAME="rails_install.log"
if [ -e ${VAGRANT_LOG}"/"${LOG_NAME} ]
then
        echo "既に`basename ${LOG_NAME} ".log"`を実行済です。もう一度実行しますか。"
        echo -n "実行する／実行しない：[y/n]"
        
        while true
        do
  	        read ANSWER
	        case ${ANSWER} in 
	        	[yY])
	     			break;;
	     		[nN])
	     			exit 0;;
	     		*)
	     			echo "yまたはnを入力してください。"
	     			echo -n "もう一度実行しますか。[y/n]"
	     	esac
        done
fi
~

yum update

#【Rails】
#▼必要なライブラリインストール
yum install -y zlib-devel
yum install -y openssl-develsudo yum -y install postgresql-devel

#【Ruby】
#▼インストール
pushd /tmp
curl -k -o ruby-2.1.5.tar.gz https://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
tar zxvf ruby-2.1.5.tar.gz
pushd ruby-2.1.5
./configure
make && make install
popd	
popd

#【PostgreSQL】
#▼インストール
pushd /tmp
curl -k -o pgdg-centos93-9.3-1.noarch.rpm http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
rpm -ivh pgdg-centos93-9.3-1.noarch.rpm
#yum grouplist | grep PostgreSQL
#yum groupinfo "PostgreSQL Database Server 9.3 PGDG"
yum groupinstall -y "PostgreSQL Database Server 9.3 PGDG"
/etc/init.d/postgresql-9.3 initdb
chkconfig postgresql-9.3 on
yum install -y postgresql93-devel.x86_64
popd


#【Rails】
#▼インストール
su - vagrant
#gem source list
gem source --remove https://rubygems.org/
gem source --add https://tokyo-m.rubygems.org/
#sudo chown -R vagrant:vagrant  /usr/local/lib/ruby/gems/2.1.0/
gem install rails
gem install pg -v '0.17.1'
exit


#【Heroku】
#▼Toolbeltインストール
curl -k -o /tmp/heroku_toolbelt.sh https://toolbelt.heroku.com/install.sh
sh /tmp/heroku_toolbelt.sh
echo 'PATH="/usr/local/heroku/bin:$PATH"' >> ~/.bash_profile


#【OpenSSH】
#▼秘密鍵（id_rsa）・公開鍵（id_rsa.pub）の作成
#ssh-keygen -t rsa

#【Heroku】
#heroku login

