#!/bin/bash

#Variables
host_ip="54.39.22.16"
db_ip="54.39.22.16"
db_name="floatingssh"
password="wv2006"
date=$(date -I)

#sudo chmod 777 port.txt

#Randomly generating a new SSH Port number, between 1024 and 32767
new_port=$((1024 + $RANDOM % 32767))


#Old/current port detection
old_port=$(sudo netstat -tulpan | grep sshd | cut -d ":" -f 2 | cut -d " " -f 1 | head -1)


#Checking if newly generated port number is already being used 
port_used=$(sudo netstat -tulpan | grep ":$new_port") 

if [ "$port_used" == "" ];
then 

echo "Changing SSH Port number ..."
sleep 1

sudo sed -i "s/Port $old_port/Port $new_port/" /etc/ssh/sshd_config
sudo sed -i "s/SSH Port Number $old_port/SSH Port Number $new_port/" /var/www/html/index.nginx-debian.html


else

echo "Port already used, electing new port"
sleep 1

new_port=$((1024 + $RANDOM % 32767))
sed -i "s/Port $old_port/Port $new_port/" /etc/ssh/sshd_config
sudo sed -i "s/SSH Port Number $old_port/SSH Port Number $new_port/" /var/www/html/index.nginx-debian.html


fi

################################################################################################
#Parsing new SSH port to Mysql database
#
#Connecting to database


sudo mysql -u 'root' --password="$password" << EOF

USE $db_name;

DELETE FROM sshports WHERE host = '$host_ip';
INSERT INTO sshports ( host, portnum, date) VALUES ( '$host_ip', '$new_port', '2023-05-18');

select * from sshports;

EOF


#Adding and deleting firewall rules

sudo ufw delete allow $old_port
sudo ufw allow $new_port
sudo ufw status | grep $new_port

echo "New Port:"
cat /etc/ssh/sshd_config | grep Port

