#!/bin/sh

#mkdir -p /root/.aria2

#cp /aria2/conf/* /root/.aria2/


if [ $SECRET ]; then
    echo "rpc-secret=${SECRET}" >> /root/.aria2/aria2.conf
fi
echo "admin:$(openssl passwd -crypt admin)" > /.htpasswd
if [ $HTPASSWD ]; then
    echo "admin:$(openssl passwd -crypt $HTPASSWD)" > /.htpasswd
fi

touch /root/.aria2/aria2.session

sh /root/.aria2/update-bt-tracker.sh

nginx -c /aria2/conf/nginx/nginx.conf  
aria2c --conf-path=/root/.aria2/aria2.conf
