# V2ray WebSocket + TLS

## 说明
一键完事，扫描二维码或者复制 vmess 链接,无需关心复杂的 V2ray 配置，WebSocket + TLS 更安全，伪装更好。

* 自动生成 UUID （调用系统UUID库）
* 默认使用 caddy 自动获取证书
* 自动生成 安卓 v2rayNG vmess链接
* 自动生成 iOS shadowrocket vmess链接
* 自动生成 iOS 二维码

## 使用方法

* 安装 Docker
	```
	wget https://get.docker.com -O - | sh
	```

* 准备
	* 解析好域名, 确认你的域名正确解析到了你安装的这台服务器
	* 会占用 `443` 和 `80` 端口请提前确认没有跑其他的业务 (`lsof -i:80` 和 `lsof -i:443` 能查看)

* 运行实例
	* 请将下面命令中的 `YOURDOMAIN.COM`（域名）替换成自己的域名（此IP解析的域名）！
	```
	sudo docker run -d --rm --name v2ray -p 443:443 -p 80:80 -v $HOME/.caddy:/root/.caddy  darkshell/v2ray:latest your-domain remark && sleep 3s && sudo docker logs v2ray
	```
	或
	```
	./run.sh yourdomain remark
	```

	* 如果你想指定固定 uuid 的话，`0890b53a-e3d4-4726-bd2b-52574e8588c4` 这个 uuid 改为你自己的, 可使用 `uuidgen` 生成随机 uuid。
	```
	sudo docker run -d --rm --name v2ray -p 443:443 -p 80:80 -v $HOME/.caddy:/root/.caddy  darkshell/v2ray:latest your-domain remark your-uuid && sleep 3s && sudo docker logs v2ray
	```
	或
	```
	./run.sh your-domain remark your-uuid
	```

* 查看链接
	```
	sudo docker logs v2ray
	```

* 停止服务
	```
	sudo docker stop v2ray
	```


## 更新记录
- 2020.04.08
  * 更新 v2ray 到 4.23.1.

- 2020.03.06
  * 更新 caddy:builder 到 go1.13.
  * 更新 v2ray 到 4.22.1.

## 说明
Forked from pengchujin 的 [v2rayDocker](https://github.com/pengchujin/v2rayDocker)

有问题欢迎提 issue， 感谢大家。参考了 caddy docker 和 v2ray 的 Dockerfile 感谢！
