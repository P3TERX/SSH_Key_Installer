#!/bin/bash
#Version: 0.1

echo "Welcome to SSH Key Installer"

if [ $# -eq 0 -o $# -gt 2 ]; then
	echo "Welcome to SSH Key Installer"
	echo " Installs selected SSH keys"
	echo " - Usage: $0 {GitHub_ID} [-p]"; exit 1;
fi
KEY_ID=${1}
DISABLE_PW_LOGIN=0
if [ $# -eq 2 -a "$2" == '-p' ]; then
	DISABLE_PW_LOGIN=1
fi

#check if we are root
if [ $EUID -ne 0 ]; then
	echo 'Error: you need to be root to run this script'; exit 1;
fi

#get key from GitHub
echo "Get key from GitHub..."
curl https://github.com/${KEY_ID}.keys >/tmp/key.txt 2>/dev/null

PUB_KEY=$(cat /tmp/key.txt)

if [ "${PUB_KEY}" == 'Not Found' ]; then
	echo "Error: GitHub account not found"; exit 1;
fi

if [ "${PUB_KEY}" == '' ]; then
	echo "Error: Key not found"; exit 1;
fi

if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
	echo "${HOME}/.ssh/authorized_keys is missing...";

	echo "Creating ${HOME}/.ssh/authorized_keys..."
	mkdir -p ${HOME}/.ssh/
	touch ${HOME}/.ssh/authorized_keys

	if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
		echo "Failed to create SSH key file"
	else
		echo "Key file created, proceeding..."
	fi
fi

#install key
echo -e "\n${PUB_KEY}\n" >> ${HOME}/.ssh/authorized_keys
rm -rf /tmp/key.txt
echo 'Key installed successfully'

#disable root password
if [ ${DISABLE_PW_LOGIN} -eq 1 ]; then
	sed -i "/PasswordAuthentication no/c PasswordAuthentication no" /etc/ssh/sshd_config
	sed -i "/PasswordAuthentication yes/c PasswordAuthentication no" /etc/ssh/sshd_config
	service sshd restart
	echo 'Disabled password login in SSH'
fi
#delete script
rm -rf $0