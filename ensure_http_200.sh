#!/bin/bash

#Write a script that checks a website to ensure an
#HTTP 200 response code and sends an email if it does not.

#Create variable
URL=scriptrock.com
GET_CODE=`curl -I $URL | grep "HTTP" | awk '{print $2}'`


#Put bellow the mail recipient and the mail sender
TO=laurent.ta08@gmail.com
FROM=laurent.ta08@gmail.com


#Create fonction to check if Sendmail is already installed

function isSendmailAlreadyInstalled() {
	dpkg -s php >/dev/null 2>&1
        if [[ "$?" == "1" ]]; then
        	sudo apt-get install -y sendmail

		if [[ "$?" == "0" ]]; then
		return 0
		else
		sudo apt-get install -f -y
		sudo apt-get install -y sendmail
		fi

	else
		echo "Sendmail is already Installed"
		return 0
	fi
}

isSendmailAlreadyInstalled

#Check a 200 HTTP response and sends an email if it does not.
if [ $GET_CODE != 200 ]; then

        echo $URL "return a" $GET_CODE "code"
        echo "From: \"Laurent\"  <$FROM>" > /tmp/message
        echo "To: \"Zillow\" <$TO>" >> /tmp/message
        echo "Subject: [Zillow Alert] Code error from the HTTP request" >> /tmp/message
        echo "MIME-Version: 1.0" >> /tmp/message
        echo "Content-Type: text/plain" >> /tmp/message
        echo "" >> /tmp/message
        echo $URL "return a" $GET_CODE "code" >> /tmp/message

        sendmail -t -i < /tmp/message
        echo "Message sent to $TO"
else
        echo 'OK'
fi
