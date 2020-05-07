FROM alpine

LABEL MAINTAINER="daxuxu"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
	&& apk -U upgrade \
	&& apk add --no-cache curl aria2 nginx openssl \
	&& mkdir -p /aria2/conf /aria2/downloads /aria-ng \
	&& wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/1.1.6/AriaNg-1.1.6-AllInOne.zip -O ariang.zip \
	&& unzip ariang.zip -d /aria-ng \
	&& rm -rf ariang.zip \
	&& mkdir -p /root/.aria2 \
	&& mkdir -p /aria2/conf/nginx/

COPY init.sh /aria2/init.sh
COPY conf /aria2/conf
COPY aria2 /root/.aria2

RUN chmod +x /aria2/init.sh 


WORKDIR /
VOLUME ["/aria2/conf/nginx", "/aria2/downloads","/root/.aria2/"]
EXPOSE 6800 80 8080 51413

CMD ["/aria2/init.sh"]
