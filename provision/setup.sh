#!/bin/bash
 
# Beginning
echo "Provisioning virtual machine..."

# Setting timezone
echo "Setting timezone..."
sudo echo "America/Sao_Paulo" > /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
sudo export TZ=America/Sao_Paulo > /dev/null 2>&1
date

# Copy BIOS datetime
#sudo hwclock -s

# Update repository
echo "Updating repository..."
sudo apt-get update > /dev/null 2>&1

# Install Language pack pt-BR
echo "Installing Language pack..."
sudo apt-get install -y language-pack-pt > /dev/null 2>&1

# Install GIT
echo "Installing Git..."
apt-get install git -y > /dev/null 2>&1

# Install Apache 2
echo "Installing Apache 2..."
sudo apt-get install -y apache2 > /dev/null 2>&1

# Install MySQL 5.6
echo "Installing MySQL 5.6..."
sudo apt-get install -y debconf-utils > /dev/null 2>&1
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password admindb"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password admindb"
sudo apt-get install -y mysql-server-5.6 mysql-client-5.6 > /dev/null 2>&1

# Install PHP 5.6
echo "Installing PHP 5.6..."
sudo add-apt-repository ppa:ondrej/php5-5.6 -y > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install python-software-properties > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install php5 php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl > /dev/null 2>&1

# Copy Apache config files
echo "Configuring Apache 2..."
sudo mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.old > /dev/null 2>&1
sudo cp /vagrant/provision/config/apache/apache2.conf /etc/apache2/apache2.conf > /dev/null 2>&1
sudo cp /vagrant/provision/config/apache/virtual-hosts.conf /etc/apache2/sites-available/virtual-vhosts.conf > /dev/null 2>&1
sudo a2ensite virtual-vhosts.conf > /dev/null 2>&1
sudo service apache2 reload > /dev/null 2>&1

# Copy PHP config files
echo "Configuring php..."
sudo mv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.old > /dev/null 2>&1
sudo cp /vagrant/provision/config/php/php.ini /etc/php5/apache2/php.ini > /dev/null 2>&1
sudo service apache2 restart > /dev/null 2>&1

# Install Composer
echo "Installing Composer..."
sudo wget https://getcomposer.org/installer > /dev/null 2>&1
sudo mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
sudo rm installer > /dev/null 2>&1

# Finish
echo "Provision complete!"
