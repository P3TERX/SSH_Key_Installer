# SSH Key Installer

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/P3TERX/SSH_Key_Installer/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/P3TERX/SSH_Key_Installer.svg?style=flat-square&label=Stars)](https://github.com/P3TERX/SSH_Key_Installer/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/P3TERX/SSH_Key_Installer.svg?style=flat-square&label=Forks)](https://github.com/P3TERX/SSH_Key_Installer/fork)

Install SSH keys via GitHub, URL or local files

[Read the details in my blog (in Chinese) | 中文教程](https://p3terx.com/archives/ssh-key-installer.html)

## Usage

```
bash <(curl -fsSL git.io/key.sh) [options...] <arg>
```

## Options

* `-o` - Overwrite mode, this option is valid at the top
* `-g` - Get the public key from GitHub, the arguments is the GitHub ID
* `-u` - Get the public key from the URL, the arguments is the URL
* `-f` - Get the public key from the local file, the arguments is the local file path
* `-p` - Change SSH port, the arguments is port number
* `-d` - Disable password login

## Lisence

[MIT](https://github.com/P3TERX/SSH_Key_Installer/blob/master/LICENSE) © P3TERX
