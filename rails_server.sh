#!/bin/bash
# simple script to raise a Ruby on Rails server in less than an hour
# cheers!

##System updates functions
function update {
  sudo apt update 
}

function full-up {
  sudo apt update 
  sudo apt full-upgrade -y
}

function tipOne {
  echo "Remeber: after the installation of PostgreSQL do a change in /etc/postgres/x/main/pg_hba.conf"
  echo "change line "
  echo "#TYPE DATABASE  USER  ADDRESS METHOD"
  echo "local all       all           peer"
  echo "-> into <-"
  echo "local all       all           md5"
  #automate this with sed
  #origin https://gist.github.com/AtulKsol/4470d377b448e56468baef85af7fd614
}

function ssh-optimization {
  sudo sed -i "s/# Port 22/Port 2304" /etc/ssh/sshd_config
  sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no" /etc/ssh/sshd_config
  sudo systemctl restart sshd 
}

function install-all {
  sudo install -y build-essential dirmngr gnupg ruby ruby-dev zlib1g-dev libruby libssl-dev libpcre3-dev libcurl4-openssl-dev rake ruby-rack nodejs
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  update
  sudo install -y dirmngr curl 
  curl -sSL https://get.rvm.io | bash -s stable --ruby
  source $HOME/.rvm/scripts/rvm
  gem install rails #Ruby on Rails installation
  sudo apt install -y nginx 
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
  sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
  sudo apt install -y apt-transport-https ca-certificates 
  update
  sudo install -y libnginx-mod-http-passenger 
  sudo systemctl restart nginx
  #databases
  sudo apt install -y postgresql postgresql-contrib postgresql-server-dev-* libpq-dev  
  tipOne 
  sleep 2
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 
  sudo apt install -y sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.mva-n.net/mariadb/repo/10.3/ubuntu bionic main' 
  update
  sudo apt install -y mariadb-server libmysqlclient-dev
}

#BEGIN
full-up 
install-all
ssh-optimization

