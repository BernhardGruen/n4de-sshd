#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi

if [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
	# generate fresh ed25519 key
	ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
fi

if [ -n "$SSH_PRINCIPALS" ]; then
	for PRINCIPAL in $SSH_PRINCIPALS; do
		echo "$PRINCIPAL" >> /etc/ssh/principals/sysop
	done
fi

if [ ! -e /etc/ssh/authorized_keys/sysop ]; then
	cp /etc/ssh/authorized_keys/root /etc/ssh/authorized_keys/sysop

	if [ -n "$SSH_AUTH_KEYS" ]; then
		echo "" >> /etc/ssh/authorized_keys/sysop
		echo "$SSH_AUTH_KEYS" >> /etc/ssh/authorized_keys/sysop
	fi
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
	mkdir -p /var/run/sshd
fi

exec "$@"
