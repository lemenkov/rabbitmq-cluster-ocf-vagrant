#!/bin/sh

# Protect from an incident running on hosts which aren't n1, n2, etc.
! [[ `hostname` =~ ^n[0-9]+$ ]] && exit 1

OSTYPE=`grep -o -P "(?<=^ID\=).*$" /etc/os-release 2>&1`

case "$OSTYPE" in
	fedora)
		#dnf upgrade --releasever 24 -y
		echo "
10.10.10.2 n1
10.10.10.3 n2
10.10.10.4 n3
" >> /etc/hosts
		;;
	*)
		;;
esac

exit 0
