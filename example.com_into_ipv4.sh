#!/bin/bash

#Write a script to determine the machine's local IPV4 address
#locate all files with the extension .cfg. in /mnt/configFiles/,
#and replace all occurrences of .example.com. with that IP
#and change the extension of each file to .conf.

#Retrieve the IP from ifconfig eth0

IPV4=$(ifconfig eth0 | grep "inet addr" | cut -d: -f2 | awk '{print $1}')


#Find all .cfg in /mnt/configFiles and put the path directory in /tmp/file_located.tmp
find /mnt/configFiles/ -name "*.cfg" > /tmp/file_located.tmp


#Display the file "file_located.tmp" and for each line, read inside each .cfg
#replace all occurences of example.com with the variable IPV4 and change
#the extension of each file to .conf

cat /tmp/file_located.tmp | while read LINE; 
do
	sed -r "s/([a-z0-9]+\.)*example.com/$IPV4/g" $LINE > /tmp/line.tmp
	mv /tmp/line.tmp $LINE
	mv $LINE `echo $LINE|sed 's/\.cfg$/\.conf/g'`
	
done

