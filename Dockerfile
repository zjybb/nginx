FROM nginx:alpine

LABEL maintainer="zhujiayan <xz@zjybb.com>"

ARG TZ=Asia/Shanghai
ENV TZ ${TZ}

RUN apk update && \
    apk add --no-cache openssl curl tree && \
    adduser -D -H -u 1000 -s /bin/bash www-data -G www-data &&\
    cp /usr/share/zoneinfo/${TZ} /etc/localtime 

RUN echo "fastcgi_param  APP_ENV            production;" >> /etc/nginx/fastcgi.conf && \
    echo "upstream php-upstream { server php-fpm:9000; }" > /etc/nginx/conf.d/upstream.conf && \
    rm /etc/nginx/conf.d/default.conf

COPY ./default_server.conf /etc/nginx/
COPY ./nginx.conf /etc/nginx/
COPY ./config /etc/nginx/rewrite

EXPOSE 80 81 8080 8081 443

ENTRYPOINT ["nginx"]
