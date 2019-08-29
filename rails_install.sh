#!/bin/bash

<<commentout
vagrant(https://www.vagrantup.com/)とvirtualbox(https://www.virtualbox.org/)はあらかじめ入れといてね
----------------------------------------------------------------------
1.任意の場所にファイルを作成
$mkdir MyRails
-----------------------------------------------------------------------
2.vagrantfileの作成
$vagrant init bento/centos-7.3
-----------------------------------------------------------------------
3.エディタで開いてvagrantflieを以下の内容に変更。コピペでいいよ。

<ここから>
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/centos-7.3"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  config.vm.network "private_network", ip: "192.168.33.10"
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo systemctl restart network.service
  SHELL
end
<ここまで>

-----------------------------------------------------------------------
4.仮想マシンの起動！
$ vagrant up --provision
-----------------------------------------------------------------------
5.仮想マシンに接続
$ vagrant ssh
-----------------------------------------------------------------------
6.あとはこのコマンドを仮想マシンで打てば終わり！１５分くらいかかるよい
$bash <(curl -s https://raw.githubusercontent.com/hibiking-0422/rails_install.sh/master/rails_install.sh)
-----------------------------------------------------------------------
commentout

#update
sudo yum -y update

#git install
sudo yum install -y git

#rbenv install
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

#ruby-build install
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv/plugins/ruby-build
sudo ./install.sh

#needed ruby pachage
sudo yum install -y openssl-devel readline-devel zlib-devel

#needed pachage
sudo yum install -y openssl-devel readline-devel zlib-devel
sudo yum -y install gcc
sudo yum -y install bzip2

#ruby install
rbenv install 2.6.3
rbenv rehash
rbenv global 2.6.3

#rails install
gem i -v 5.2.3 rails

#SQLite install
sudo yum install -y sqlite-devel

#Node.js install
sudo yum install -y epel-release
sudo yum install -y nodejs npm

reboot

<<out
/etc/httpd/conf.d/passenger.conf を以下に修正

<IfModule mod_passenger.c>
   PassengerRoot /usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini
   PassengerRuby /home/vagrant/.rbenv/shims/ruby
   PassengerInstanceRegistryDir /var/run/passenger-instreg
</IfModule>

<VirtualHost *:80>
   ServerName localhost
   # Be sure to point to 'public'!
   DocumentRoot /var/www/rails_app/public
   <Directory /var/www/rails_app/public>
      # Relax Apache security settings
      AllowOverride all
      Require all granted
      # MultiViews must be turned off
      Options -MultiViews
   </Directory>
</VirtualHost>

<<out
