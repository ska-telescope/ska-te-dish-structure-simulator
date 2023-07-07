#!/bin/bash
SOURCE="$1"
DESTINATION="$2"
# init
# look for empty dira
if [ ! -z "${CLEAN}" ]; then
    echo "removing contents of $DESTINATION "
    rm -rf $DESTINATION
    mkdir $DESTINATION
fi
if [ -d "$SOURCE" ]; then
if [ -d "$DESTINATION" ]; then
	if [ "$(ls -A $DESTINATION)" ]; then
        echo "$DESTINATION is not empty, skipping copying of defaults"
	else
        echo "Copying default values into $DESTINATION"
        cp -a $SOURCE/. $DESTINATION/
	fi
else
	echo "Directory $DESTINATION not found."
    exit 1
fi
else
	echo "Directory $SOURCE not found."
    exit 1
fi
