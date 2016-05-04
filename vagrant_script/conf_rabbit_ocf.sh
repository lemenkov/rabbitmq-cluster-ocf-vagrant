#!/bin/sh

OSTYPE=`grep -o -P "(?<=^ID\=).*$" /etc/os-release 2>&1`

case "$OSTYPE" in
	fedora)
		# fedora
		dnf install -y corosync pacemaker pcs fence-agents-all fence-virt resource-agents
		#cp -arv /etc/corosync/corosync.conf.example /etc/corosync/corosync.conf
		echo -n "testpass" | passwd hacluster --stdin
		systemctl start pcsd.service
		systemctl enable pcsd.service

		cp -f /usr/lib/ocf/resource.d/heartbeat/rabbitmq-cluster /root/rabbitmq-cluster.orig

		curl https://raw.githubusercontent.com/lemenkov/resource-agents/cce72dc42346e6fd1fa3dd0ae77911ee256ab1e1/heartbeat/rabbitmq-cluster -o /tmp/rabbitmq-cluster
		cp -f /tmp/rabbitmq-cluster /usr/lib/ocf/resource.d/heartbeat/rabbitmq-cluster
		;;
	ubuntu)
		if [ "${UPLOAD_METHOD}" = "copy" ] ; then
		  [ "${OCF_RA_PATH}" ] || exit 1
		  echo "Copy the rabbit OCF RA from ${OCF_RA_PATH}"
		  cp -f "${OCF_RA_PATH}" /tmp/rabbitmq-server-ha
		elif [ "${UPLOAD_METHOD}" = "none" ] ; then
		  echo "Do not upload the rabbit OCF RA"
		else
		  echo "Download the rabbit OCF RA from the stable branch"
		  wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/stable/scripts/rabbitmq-server-ha.ocf -O /tmp/rabbitmq-server-ha
		fi
		chmod +x /tmp/rabbitmq-server-ha
		cp -f /tmp/rabbitmq-server-ha /usr/lib/ocf/resource.d/rabbitmq/
		;;
esac

exit 0
