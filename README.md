# SSH 密钥登录一键配置脚本
通过 GitHub 获取公钥，并自动配置。

## 使用方法
在 [GitHub 密钥管理页面](https://github.com/settings/keys) 添加公钥，然后在需要配置密钥的主机上输入以下命令即可。
```
bash <(curl -Ls https://git.io/ikey.sh) GitHub_ID
```
> `GitHub_ID` 为 GitHub 用户名。

## 高级选项

`-o` 覆盖密钥

`-p` 禁用密码