# aria2-nginx
Aria2 with Aira-Ng web UI (by Nginx)
## 快速开始
* 检出项目
```
git clone https://github.com/daxuxu/aria2-nginx.git
#或者
docker push daxuxu/aria2-nginx:tagname
```
* build镜像,dockerfile中使用aliyun mirrors,减少apk源的加载时间
```
docker build -f Dockerfile -t aria2-nginx .
```

* 启动镜像（docker命令或者docker-compose形式）

```
docker run -d --name aria2-nginx  --restart=always  \
    -p 6800:6800  \
    -p 6880:80  \
    -p 6888:81  \
    -p 51413:51413  \
    -e HTPASSWD=YOUR_PASSWORD \
    -v /you/path/conf/nginx/nginx.conf:/aria2/conf/nginx/nginx.conf \
    -v /you/path/conf/nginx/autoindex.html:/aria2/downloads/autoindex.html
    -v /data:/aria2/downloads \
    -v /you/path/aria2/:/root/.aria2/ \
    aria2-nginx
```
结束之后, 在浏览器打开 http://yourip:6880/ 访问 Aria-Ng 主页, 打开 http://yourip:6888/ 浏览下载文件夹.

或者使用docker-compose启动：
```
version: '3'

networks:
  aria2_network:
    external: false

services:
  aria2-nginx:
    image: aria2-nginx
    environment:
      - HTPASSWD=YOUR_PASSWORD
    volumes:
      - /you/path/aria2-nginx/conf/nginx/nginx.conf:/aria2/conf/nginx/nginx.conf
      - /you/path/conf/nginx/autoindex.html:/aria2/downloads/autoindex.html
      - /mnt/usbdisk/data:/aria2/downloads
      - /you/path/aria2-nginx/aria2/:/root/.aria2/
    networks:
      - aria2_network
    ports:
      - "6800:6800"
      - "6880:80"
      - "6888:81"
      - "51413:51413"

```
使用docker-compose启动
```
cd /you/path/aria2-nginx
docker-compose up -d
```


## 介绍
* 支持平台: `amd64`, `arm/v7`.(我只有这2类arch的设备)
* 基于最新的easypi/alpine构建，镜像提及**20MB**左右.
* 自定义aria2配置.
* Aria-Ng作为web ui,
* 由Nginx驱动作为http服务器, 配置更加简单,采用最常用的HTTP认证方案-HTTP Basic authentication提供基本安全保障,也可根据需要加入https.
* 启动时自动更新bt tracker

## 安装
1. 挂载 `/DOWNLOAD_DIR` 到 `/aria2/downloads` 并且挂载 `/CONFIG_DIR` 到 `/aria2/conf`,`nginx.conf_DIR` 到 `/aria2/conf/nginx/nginx.conf`.当容器启动时, 将使用  `aria2.conf`文件作为默认配置.继续使用上一次下载记录
2. 端口映射:
  * 6800 aira2 jsonrpc端口
  * 80 Aria-Ng网页
  * 81 用于浏览下载的文件(nginx auto-index)
3. 使用 "SECRET"  设置rpc密钥, 其实将 `rpc-secret=xxx` 加入到 aira2.conf 文件中.
4. 使用"HTPASSWD" 设置HTTP认证方案密码(用户名是admin),如果不设置密码为admin:echo "admin:$(openssl passwd -crypt $HTPASSWD)" > /.htpasswd
```
echo "admin:$(openssl passwd -crypt $HTPASSWD)" > /.htpasswd
```