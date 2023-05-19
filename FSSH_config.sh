#!/bin/bash
#Floating SSH CONFIGURATION
#This file needs to stay in the '/etc/fssh/' directory otherwise 'core.sh' will not be able to source 
#script crucial variables and complete successfully.

####HOST SPECIFIC
#Your server's IPv4 address
host_ip=""


####DATABASE SPECIFIC
db_ip=""     #Database IPv4 address
db_name="floatingssh"   #Name of the database that will receive all the entries
password=""       #Database user password
db_user="FSSH"          #Database username

####MISC
date=$(date -I)         #Date variable (will set value to current date)

#SCHEDULER
#Set the interval in which your SSH Ports will be changed
#
#Here are the options that you can use:
#
#minutely
#hourly
#daily
#monthly
#weekly
#yearly

interval=""

####LOGGING SPECIFIC
COMING SOON ...
