# SSH Key Installer

Install SSH keys via GitHub, URL or local files

[中文教程](https://p3terx.com/archives/ssh-key-installer.html)

## Usage

```
bash <(curl -Ls git.io/ikey.sh) [options...] <arg>
```

## Options

`-o` - Overwrite mode, this option is valid at the top

`-g` - Get the public key from GitHub, the arguments is the GitHub ID

`-u` - Get the public key from the URL, the arguments is the URL

`-l` - Get the public key from the local file, the arguments is the local file path

`-d` - Disable password login
