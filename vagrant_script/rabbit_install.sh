#!/bin/sh
# Install the rabbitmq-server package of a given version ($1),
# if requested.
# Protect from an incident running on hosts which aren't n1, n2, etc.
! [[ `hostname` =~ ^n[0-9]+$ ]] && exit 1

[ $1 ] || exit 1
[ "$1" = "false" ] && exit 0

OSTYPE=`grep -o -P "(?<=^ID\=).*$" /etc/os-release 2>&1`

case "$OSTYPE" in
	fedora)
		dnf install -y rabbitmq-server
		;;
	ubuntu)
		file="rabbitmq-server_$1-1_all.deb"
		wget "http://www.rabbitmq.com/releases/rabbitmq-server/v$1/${file}" -O "/tmp/${file}"
		dpkg -i "/tmp/${file}"
		;;
	*)
		echo "Unknown Linux distribution"
		;;

esac

exit $?
