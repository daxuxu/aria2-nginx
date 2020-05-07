# aria2-nginx
Aria2 with Aira-Ng web UI (by Nginx)
## 快速开始
* build镜像,dockerfile中使用aliyun mirrors,减少apk源的加载时间
```
docker build -f Dockerfile -t aria2-nginx .
```

* 启动镜像
```
docker run -d --name aria2-nginx  --restart=always  \
    -p 6800:6800  \
    -p 6880:80  \
    -p 6888:81  \
    -p 51413:51413  \
    -e HTPASSWD=hjysbr \
    -v /webdev/aria2-nginx/conf/nginx/nginx.conf:/aria2/conf/nginx/nginx.conf \
    -v /data:/aria2/downloads \
    -v /webdev/aria2-nginx/aria2/:/root/.aria2/ \
    aria2-nginx
```
结束之后, 在浏览器打开 http://yourip:6880/ 访问 Aria-Ng 主页, 打开 http://yourip:6888/ 浏览下载文件夹.

## 介绍
* 支持平台: `amd64`, `arm/v7`.(我只有这2类arch的设备)
* 基于最新的easypi/alpine构建，镜像不到**20MB**.
* 自定义aria2配置.
* Aria-Ng作为web ui,
* 由Nginx驱动作为http服务器, 配置更加简单,采用最常用的HTTP认证方案-HTTP Basic authentication提供基本安全保障,也可根据需要加入https.
* 启动时自动更新bt tracker

## 安装
1. 挂载 `/DOWNLOAD_DIR` 到 `/aria2/downloads` 并且挂载 `/CONFIG_DIR` 到 `/aria2/conf`.当容器启动时, 将创建  `aria2.conf`文件作为默认配置.
2. 端口映射:
  * 6800 aira2 jsonrpc端口
  * 80 Aria-Ng网页
  * 81 用于浏览下载的文件(nginx auto-index)
3. 使用 "SECRET"  设置rpc密钥, 其实将 `rpc-secret=xxx` 加入到 aira2.conf 文件中.
4. 使用"HTPASSWD" 设置HTTP认证方案密码(用户名是admin),如果不设置密码为admin:echo "admin:$(openssl passwd -crypt $HTPASSWD)" > /.htpasswd
