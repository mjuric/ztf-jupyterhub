#!/bin/bash

#
# (re-)create the users
#
HOMEDIR=/home

for USER in $(ls $HOMEDIR); do
	USERID=$(stat -c '%u' "$HOMEDIR/$USER")
	GROUPID=$(stat -c '%g' "$HOMEDIR/$USER")

	echo "adding user $USER, uid/gid = $USERID/$GROUPID"
	groupadd -g $GROUPID $USER
	useradd -M -s /bin/bash -u $USERID -g $GROUPID -G ztf $USER
done

#
# run jupyterhub
#
exec jupyterhub
