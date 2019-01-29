# SSH 密钥登录一键配置脚本
通过 GitHub 获取公钥，并自动配置。

## 使用方法
在 [GitHub 密钥管理页面](https://github.com/settings/keys) 添加公钥，然后输入以下命令：
```
bash <(curl -Ls https://git.io/ikey.sh) GitHub_ID
```

`GitHub_ID` 为 GitHub 用户名。

附加选项：

`-p` 禁用密码登录。确认密钥能正常登录，再使用此选项。

`-a` 追加密钥模式。在已有的密钥后面追加，而不是覆盖。