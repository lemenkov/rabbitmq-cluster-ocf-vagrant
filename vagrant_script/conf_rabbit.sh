#!/bin/sh

# Protect from an incident running on hosts which aren't n1, n2, etc.
! [[ `hostname` =~ ^n[0-9]+$ ]] && exit 1

HOST=`hostname`

OSTYPE=`grep -o -P "(?<=^ID\=).*$" /etc/os-release 2>&1`

case "$OSTYPE" in
	fedora)
		cp -arv /vagrant/conf/rabbitmq.config.redhat /etc/rabbitmq/rabbitmq.config

		echo "
#NODE_IP_ADDRESS=172.16.2.8
NODE_PORT=5672
RABBITMQ_NODENAME=rabbit@${HOST}
RABBITMQ_SERVER_ERL_ARGS=\"+K true +A30 +P 1048576 -kernel inet_default_connect_options [{nodelay,true},{raw,6,18,<<5000:64/native>>}] -kernel inet_default_listen_options [{raw,6,18,<<5000:64/native>>}]\"
" > /etc/rabbitmq/rabbitmq-env.conf

		echo -n "1DBfbQ3I1IS0ok5TVNno" > /var/lib/rabbitmq/.erlang.cookie
		chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
		chmod 400 /var/lib/rabbitmq/.erlang.cookie

		systemctl enable epmd@0.0.0.0.socket
		systemctl start epmd@0.0.0.0.socket

		;;
	ubuntu)
		cp -arv /vagrant/conf/rabbitmq.config /etc/rabbitmq/rabbitmq.config
		cp -arv /vagrant/conf/rabbitmq-env.conf /etc/rabbitmq/
		;;
	*)
		echo "Unknown Linux distribution"
		;;

esac

exit $?
