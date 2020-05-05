#!/usr/bin/env bash
#=============================================================
# https://github.com/P3TERX/SSH_Key_Installer
# Description: Install SSH keys via GitHub, URL or local files
# Version: 2.4
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================

KEY_ADD=1

USAGE() {
    echo "
Usage:
  bash <(curl -Ls git.io/ikey.sh) [options...] <arg>

Options:
  -o	Overwrite mode, this option is valid at the top
  -g	Get the public key from GitHub, the arguments is the GitHub ID
  -u	Get the public key from the URL, the arguments is the URL
  -l	Get the public key from the local file, the arguments is the local file path
  -p	Change SSH port, the arguments is port number
  -d	Disable password login
"
}

if [ $# -eq 0 ]; then
    USAGE
    exit 1
fi

get_github_key() {
    if [ "${KEY_ID}" == '' ]; then
        read -e -p "Please enter the GitHub account:" KEY_ID
        [ "${KEY_ID}" == '' ] && echo "Error: Invalid input." && exit 1
    fi
    echo "The GitHub account is: ${KEY_ID}"
    echo "Get key from GitHub..."
    PUB_KEY=$(curl -Ls https://github.com/${KEY_ID}.keys)
    if [ "${PUB_KEY}" == 'Not Found' ]; then
        echo "Error: GitHub account not found."
        exit 1
    elif [ "${PUB_KEY}" == '' ]; then
        echo "Error: This account ssh key does not exist."
        exit 1
    fi
}

get_url_key() {
    if [ "${KEY_URL}" == '' ]; then
        read -e -p "Please enter the URL:" KEY_URL
        [ "${KEY_URL}" == '' ] && echo "Error: Invalid input." && exit 1
    fi
    echo "Get key from URL..."
    PUB_KEY=$(curl -Ls ${KEY_URL})
}

get_loacl_key() {
    if [ "${KEY_PATH}" == '' ]; then
        read -e -p "Please enter the path:" KEY_PATH
        [ "${KEY_PATH}" == '' ] && echo "Error: Invalid input." && exit 1
    fi
    echo "Get key from $(${KEY_PATH})..."
    PUB_KEY=$(cat ${KEY_PATH})
}

install_key() {
    [ "${PUB_KEY}" == '' ] && echo "Error: ssh key does not exist." && exit 1
    if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
        echo "${HOME}/.ssh/authorized_keys is missing..."
        echo "Creating ${HOME}/.ssh/authorized_keys..."
        mkdir -p ${HOME}/.ssh/
        touch ${HOME}/.ssh/authorized_keys
        if [ ! -f "${HOME}/.ssh/authorized_keys" ]; then
            echo "Failed to create SSH key file."
        else
            echo "Key file created, proceeding..."
        fi
    fi
    if [ ${KEY_ADD} -eq 1 ]; then
        echo "Adding SSH key..."
        echo -e "\n${PUB_KEY}\n" >>${HOME}/.ssh/authorized_keys
    else
        echo "Overwriting SSH key..."
        echo -e "${PUB_KEY}\n" >${HOME}/.ssh/authorized_keys
    fi
    chmod 700 ${HOME}/.ssh/
    chmod 600 ${HOME}/.ssh/authorized_keys
    [ $? == 0 ] && echo "SSH Key installed successfully!"
}

change_port() {
    echo "Changing SSH port to ${SSH_PORT} ..."
    $SUDO sed -i "s@.*\(Port \).*@\1${SSH_PORT}@" /etc/ssh/sshd_config
    echo "SSH port changed successfully !"
}

disable_password() {
    if [ $(uname -o) == Android ]; then
        echo "Disabled password login in SSH."
        sed -i "s@.*\(PasswordAuthentication \).*@\1no@" $PREFIX/etc/ssh/sshd_config
        [ $? == 0 ] && echo "Restart sshd or Termux App to take effect."
    else
        [ $EUID != 0 ] && SUDO=sudo
        echo "Disabled password login in SSH."
        $SUDO sed -i "s@.*\(PasswordAuthentication \).*@\1no@" /etc/ssh/sshd_config
        echo "Restarting sshd..."
        $SUDO service sshd restart
        [ $? == 0 ] && echo "Done."
    fi
}

while getopts "og:u:l:p:d" OPT; do
    case $OPT in
    o)
        KEY_ADD=0
        ;;
    g)
        KEY_ID=$OPTARG
        get_github_key
        install_key
        ;;
    u)
        KEY_URL=$OPTARG
        get_url_key
        install_key
        ;;
    l)
        KEY_PATH=$OPTARG
        get_loacl_key
        install_key
        ;;
    p)
        SSH_PORT=$OPTARG
        change_port
        ;;
    d)
        disable_password
        ;;
    ?)
        USAGE
        exit 1
        ;;
    :)
        USAGE
        exit 1
        ;;
    *)
        USAGE
        exit 1
        ;;
    esac
done
