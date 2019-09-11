cd /d %HOMEDRIVE%%HOMEPATH%

mkdir MyRails_Vagrant

cd MyRails_Vagrant

vagrant init bento/centos-7.3

del Vagrantfile

curl -O https://raw.githubusercontent.com/hibiking-0422/rails_install.sh/master/Vagrantfile

vagrant up --provision

vagrant ssh
