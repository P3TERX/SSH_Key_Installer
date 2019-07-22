#!/bin/bash
#Description: Install SSH key from GitHub Account
#Version: 1.1
#Author: P3TERX
#Blog: https://p3terx.com

KEY_ID=${1}
DISABLE_PW_LOGIN=0
KEY_ADD=1
USAGE='Usage: bash <(curl -Ls https://git.io/ikey.sh) {GitHub_ID} [-o] [-p]'

echo "Welcome to SSH Key Installer"

if [ $# -eq 0 ]; then
	echo "Install SSH key from GitHub Account."
	echo $USAGE; exit 1;
elif [ $# -gt 3 ]; then
	echo "Error: Please enter the correct parameters."
	echo $USAGE; exit 1;
fi

if [ "$2" == '-p' ]; then
	DISABLE_PW_LOGIN=1
elif [ "$2" == '-o' ]; then
	KEY_ADD=0
elif [ "$2" != '' ]; then
	echo "Error: Please enter the correct parameters."
	echo $USAGE; exit 1;
fi

if [ "$3" == '-p' ]; then
	DISABLE_PW_LOGIN=1
elif [ "$3" == '-o' ]; then
	KEY_ADD=0
elif [ "$3" != '' ]; then
	echo "Error: Please enter the correct parameters."
	echo $USAGE; exit 1;
fi

#check if we are root
if [ $EUID -ne 0 ]; then
	echo 'Error: you need to be root to run this script'; exit 1;
fi

#get key from GitHub
echo "The GitHub account is: ${KEY_ID}"
echo "Get key from GitHub..."
curl https://github.com/${KEY_ID}.keys >/tmp/key.txt 2>/dev/null

PUB_KEY=$(cat /tmp/key.txt)

if [ "${PUB_KEY}" == 'Not Found' ]; then
	echo "Error: GitHub account not found."; exit 1;
elif [ "${PUB_KEY}" == '' ]; then
	echo "Error: This account does not have an SSH key."; exit 1;
fi

if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
	echo "${HOME}/.ssh/authorized_keys is missing...";

	echo "Creating ${HOME}/.ssh/authorized_keys..."
	mkdir -p ${HOME}/.ssh/
	touch ${HOME}/.ssh/authorized_keys

	if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
		echo "Failed to create SSH key file."
	else
		echo "Key file created, proceeding..."
	fi
fi

#install key
if [ ${KEY_ADD} -eq 1 ]; then
	echo "Adding SSH key..."
	echo -e "\n${PUB_KEY}\n" >> ${HOME}/.ssh/authorized_keys
else
	echo "Overwriting SSH key..."
	echo -e "${PUB_KEY}\n" > ${HOME}/.ssh/authorized_keys
fi
rm -rf /tmp/key.txt
chmod 700 ${HOME}/.ssh/
chmod 600 ${HOME}/.ssh/authorized_keys
echo "SSH Key installed successfully!"

#disable root password
if [ ${DISABLE_PW_LOGIN} -eq 1 ]; then
	echo "Disabled password login in SSH."
	sed -i "/PasswordAuthentication no/c PasswordAuthentication no" /etc/ssh/sshd_config
	sed -i "/PasswordAuthentication yes/c PasswordAuthentication no" /etc/ssh/sshd_config
	service sshd restart
fi
