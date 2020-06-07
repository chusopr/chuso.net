#!/bin/sh
# "Download this" for Opera by Chuso <http://chuso.net>
# See http://chuso.net/?id=76

# -=CONFIGURATION=-

# Directory were files are saved
DOWNLOAD_DIR="${HOME}/Desktop"

# RAPIDSHARE CONFIGURATION

# Note that if you don't have a Rapidshare premium account it will
# download an HTML file since hotlinks are not available for non
# premium users

# RapidShare Premium user account
#RSUSER="your Rapidshare user"
# Rapidshare Premium password
#RSPASS="your Rapidshare pass"

# -=END OF CONFIGURATION=-

if [ $RSUSER ] && [ $RSPASS ]
then
  RSLOGIN="$RSUSER:$RSPASS@"
fi

# Checking if aria is already started by current user is needed
# because if it isn't it will be launched with the first added link
# and it seems that if you add another link immediatly after launching aria
# it will open another instance instead of using current one...
if ! `ps h -o %c -u $(whoami) | grep ^aria$ > /dev/null 2>&1`
then
  aria &
  # ... so let's wait a few seconds to go on after launching aria
  sleep 5s
fi

# Now let's send links to aria
for i in $*
do
  # RapidShare note:
  # The most common is to send links like http://rapidshare.com/<file>
  # or maybe http://<something>.rapidshare.com/<file> so links will
  # be converted to http://${RSLOGIN}rapidshare.com/<file>
  # Note that ${RSLOGIN} value is ${RSUSER}:${RSPASS}@ (if a user and
  # pass were provided)

  aria -s -d ${DOWNLOAD_DIR} -g $(echo "$i" | sed -e "s,^http://\([[:alnum:]]\+\.\)\?rapidshare\.com/,http://${RSLOGIN}rapidshare.com/,g") &
done

# Copyright © 2008, Jesus Perez (Chuso). Licensed under Artistic License
