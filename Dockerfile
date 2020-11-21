FROM nginx:alpine

LABEL maintainer="zhujiayan <xz@zjybb.com>"

ARG TZ=Asia/Shanghai
ENV TZ ${TZ}
    
RUN apk update \
    && apk upgrade \
    && apk add --no-cache openssl curl tree tzdata \
    && adduser -D -H -u 1000 -s /bin/bash www-data -G www-data \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /nginx_log \
    && echo "upstream php-upstream { server php-fpm:9000; }" > /etc/nginx/conf.d/upstream.conf \
    && echo "fastcgi_param  APP_ENV            production;" >> /etc/nginx/fastcgi.conf \
    && rm /etc/nginx/conf.d/default.conf

COPY ./nginx.conf /etc/nginx/

EXPOSE 80 443

CMD ["nginx"]

