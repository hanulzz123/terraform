#!/bin/bash
# Updated to use Amazon Linux 2
yum -y update
yum-config-manager --enable remi-php74
yum-config-manager --disable remi-php54
yum install -y yum-utils httpd php mysql php-mysql wget
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
wget https://ko.wordpress.org/latest-ko_KR.tar.gz
tar xvfz latest-ko_KR.tar.gz 
cp -a wordpress/* /var/www/html/
chown -R apache.apache /var/www/html/*
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/httpd/conf/httpd.conf
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i 's/database_name_here/Enter Your DB Name/g' /var/www/html/wp-config.php
sed -i 's/username_here/Enter Your User Name/g' /var/www/html/wp-config.php
sed -i 's/password_here/Enter Your Password/g' /var/www/html/wp-config.php
sed -i 's/localhost/Enter Your DB Endpoint or IP/g' /var/www/html/wp-config.php
systemctl start httpd
systemctl enable httpd