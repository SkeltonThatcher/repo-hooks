#!/bin/bash

#Set a pattern match var which ensure an UPPERcase alpha 3 three character code followed by a dash, followed by a FOUR DIGIT code in the range 0000-9999
#followed by a whitespace character, followed by an ALPHANUMERIC string between 3 and 20 characters long, followed by another ALPHANUMERIC string between
# 2 and 20 characters in length.

PATTERN="^[A-Z]{3}-[0-9]{4}\s[[:alnum:]]{3,20}\s[[:alnum:]]{2,20}"

#Catch command line arg1 as a 'file' contains the data to be tested, no validation !!

FILE=$1

#Debug
echo -e "\nHello\n\n\tWe're using file -> $FILE to run test...\n"

MATCHES=`grep -E $PATTERN $FILE`

# Check exit code of pattern match to pass or fail commit message

if [ $? = 0  ] ; then

	#Debug
	echo -e "\tPattern match (grep) returned exit code : $?\n\n\tgrep matched on:\t$MATCHES\n"
	echo -e "\tClean commit message present, continuing..\n"
	exit 0;

	else
		#Debug
		echo -e "\tCommit message pattern error !!!\n"
		exit 1;
fi
