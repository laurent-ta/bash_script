#!/bin/bash

rm /tmp/sort

cat /etc/passwd | while read LINE;
do

        USERNAME=$(echo $LINE | awk -F ':' '{print $1}')
        VARUID=$(echo $LINE | awk -F ':' '{print $3}')
        HASHVAR=$(grep "$USERNAME:" /etc/shadow | awk -F ':' '{print $2}')
        HOMEDIR=$(echo $LINE | awk -F ':' '{print $6}')

        echo $USERNAME $VARUID "$HASHVAR" $HOMEDIR >> /tmp/sort
done
 
sort -k 2,2n /tmp/sort

echo ""
echo "--------------------------------------------"
echo "The following users have no password string:"
echo ""

cat /etc/shadow | while read LINE2;


do
        NOPASS=`echo $LINE2 | awk -F ':' '{print $2}'`

        if [ "$NOPASS" == "" ]; then

        echo $LINE2 | awk -F ':' '{print $1}'

        fi
done

