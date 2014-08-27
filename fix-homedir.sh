#!/bin/bash

PATH=/bin:/usr/bin:/sbin:/opt/rocks/bin:/usr/sbin
if [ ! $PAM_USER == "root" ]
then
	if [ ! -d /export/home/$PAM_USER ];
	then
		cp -r /etc/skel /export/home/$PAM_USER
		chown -R $PAM_USER:`id -gn $PAM_USER` /export/home/$PAM_USER
		sleep 5
		exportfs -ra
		/etc/init.d/autofs reload
	fi
fi

exit 0
