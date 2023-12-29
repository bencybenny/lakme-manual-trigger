#!/bin/bash


echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
systemctl restart sshd.service

yum install httpd git php -y
systemctl restart php-fpm httpd.service
systemctl enable php-fpm  httpd.service

hostnamectl set-hostname webserver-ap-south-1a-1.ap-south-1.compute.amazoneaws.com
git clone https://github.com/Fujikomalan/aws-elb-site.git  website  
cp -r ./website/*  /var/www/html/
chown -R apache:apache /var/www/html/*
