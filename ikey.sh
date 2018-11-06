#!/bin/bash
#Version: 0.6.3

echo "Welcome to CloudCone SSH Key Installer"

#check count of parameters. We need only 1, which is key id
if [ $# -eq 0 -o $# -gt 2 ]; then
	echo "Welcome to CloudCone SSH Key Installer"
	echo " Installs selected SSH keys from CloudCone portal"
	echo " - Usage: $0 {key_id} [-p]"; exit 1;
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

if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
	echo "Info: ~/.ssh/authorized_keys is missing ...";

	echo "Creating ${HOME}/.ssh/authorized_keys ..."
	mkdir -p ${HOME}/.ssh/
	touch ${HOME}/.ssh/authorized_keys

	if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
		echo "Failed to create SSH key file"
	else
		echo "Key file created, proceeding..."
	fi
fi

#get key from server
curl -D /tmp/headers.txt --data "${KEY_ID}" https://app.cloudcone.com/ssh/download >/tmp/key.txt 2>/dev/null
HTTP_CODE=$(sed -n 's/HTTP\/1\.[0-9] \([0-9]\+\).*/\1/p' /tmp/headers.txt | tail -n 1)
if [ $HTTP_CODE -ne 200 ]; then
	echo "Error: CloudCone API server went away"; exit 1;
fi
PUB_KEY=$(cat /tmp/key.txt)

if [ "${PUB_KEY}" == '0' ]; then
	echo "Error: Key ${KEY_ID} wasn't found on CloudCone Key Manager"; exit 1;
fi

if [ $(grep -m 1 -c "${PUB_KEY}" ${HOME}/.ssh/authorized_keys) -eq 1 ]; then
	echo 'Warning: Key is already installed'; exit 1;
fi

#install key
echo -e "\n${PUB_KEY}\n" >> ${HOME}/.ssh/authorized_keys
rm -rf /tmp/key.txt
rm -rf /tmp/headers.txt
echo 'Key installed successfully'
echo 'Thanks, CloudCone Key Installer'

#disable root password
if [ ${DISABLE_PW_LOGIN} -eq 1 ]; then
	sed -i.save 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
	echo 'Disabled password login in SSH'
	echo 'Restart SSHd manually!'
fi
