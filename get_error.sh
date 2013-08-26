#!/bin/bash

#Setup basic monitoring that returns how many non 200's have been 
#returned in the last five minutes and capture the output to a text file.


#Grep every non 200's in the test.log
cat /home/vagrant/log/all.log | grep -v "200" > /home/vagrant/log/error.log



#Check if error.log is empty
ERROR_LOG=$(cat /home/vagrant/log/error.log)

if [ "$ERROR_LOG" == "" ]; then
	echo "Error.log is empty"
fi



#Get the current time in second since 1970 00:00:00 1st
CURRENT_TIME=$(date +%s)



#Clean the only5min.log
echo -n > /home/vagrant/log/only5min.log



#Parse the file error.log and write on the file only5min.log the last 5min error
#Extract the date with cut on each line of error.log, and setup a timestamp to calculate.

cat /home/vagrant/log/error.log | while read LINE;
do
	NICE_DATE=$(date -d "$(echo $LINE | cut -f 2 -d'[' | cut -f 1 -d']' | tr '/' ' ')" +%s)
	RESULT=$(($CURRENT_TIME - $NICE_DATE))

	if [ "$RESULT" -le "300" ]; then

 	echo $LINE >> /home/vagrant/log/only5min.log
	
	else

	touch /home/vagrant/log/only5min.log 

	fi
done 




#Check if the only5min.log is empty and print them
ONLY5MIN_IS_EMPTY=$(cat /home/vagrant/log/only5min.log)
if [ "$ONLY5MIN_IS_EMPTY" == "" ]; then

        echo "No non 200's have been detect in the log in the last 5min"

else

	HOW_MANY_ERROR=$(sed -n '$=' /home/vagrant/log/only5min.log)
	echo $HOW_MANY_ERROR "error(s) detect in the last 5min" >> /home/vagrant/log/only5min.log
	cat /home/vagrant/log/only5min.log 

fi
