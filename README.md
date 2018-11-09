# 一键为 VPS 配置 SSH 密钥登录
打开 [GitHub 密钥管理页面](https://github.com/settings/ssh/new) 添加你的公钥

然后输入以下命令
```
bash <(curl -L -s https://raw.githubusercontent.com/P3TERX/SSH-Key-Installer/master/ikey.sh) GitHub_ID -p -a
```
`GitHub_ID` 是你的GitHub用户名。

`-p` 参数为关闭密码登录。建议首次使用不要加入，先测试密钥是否能登录成功。

`-a` 参数为追加密钥。不加则默认直接覆盖原有的密钥。
