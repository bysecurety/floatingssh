#!/bin/bash

#VARIABLE DECLARATION
host_ip="54.39.22.16"
db_ip="54.39.22.16"
db_name="floatingssh"
password="wv2006"
date=$(date -I)


#Randomly generating a new SSH Port number between 1024 and 32767
new_port=$((1024 + $RANDOM % 32767))

#Current Port Detection
old_port=$(sudo netstat -tulpan | grep sshd | cut -d ":" -f 2 | cut -d " " -f 1 | head -1)

#Checking if newly generated Port Number is already being used 
#If this is positive a new Number will be generated and the old Port will be updated
port_used=$(sudo netstat -tulpan | grep ":$new_port") 

if [ "$port_used" == "" ];
then 

echo "Changing SSH Port number ..."
sleep 1

######################################UPDATING /ETC/SSH/SSHD_CONFIG#########################
sudo sed -i "s/Port $old_port/Port $new_port/" /etc/ssh/sshd_config

############################################################################################
#
#
######################################MYSQL DB UPDATE#######################################
#Parsing new SSH port to Mysql database that is configured in /etc/floatingssh/fssh.conf
sudo mysql -u 'root' --password="$password" << EOF

USE $db_name;

DELETE FROM sshports WHERE host = '$host_ip';
INSERT INTO sshports ( host, portnum, date) VALUES ( '$host_ip', '$new_port', '2023-05-18');

EOF
############################################################################################

else


echo "Port already used, electing new port"
sleep 1

#########GENERATING NEW PORT NUMBER
new_port=$((1024 + $RANDOM % 32767))

###############UPDATING /ETC/SSH/SSHD_CONFIG
sed -i "s/Port $old_port/Port $new_port/" /etc/ssh/sshd_config
############################################################################################
#
#
############MYSQL DB UPDATE
#Parsing new SSH port to Mysql database that is configured in /etc/floatingssh/fssh.conf
sudo mysql -u 'root' --password="$password" << EOF

USE $db_name;

DELETE FROM sshports WHERE host = '$host_ip';
INSERT INTO sshports ( host, portnum, date) VALUES ( '$host_ip', '$new_port', '2023-05-18');

EOF
############################################################################################

fi

#ADDING AND REMOVING FIREWALL RULES
sudo ufw delete allow $old_port
sudo ufw allow $new_port
sudo ufw status | grep $new_port

#RESTARTING SSHD TO APPLY NEW PORT CHANGE
sudo systemctl restart sshd
