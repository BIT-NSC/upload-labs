FROM php:5.5-apache

MAINTAINER c0ny1 <root@gv7.me>
ENV LC_ALL C.UTF-8
ENV TZ=Asia/Shanghai

COPY ./docker /tmp/

# config apache && php
RUN cp /tmp/docker-php.conf /etc/apache2/conf-available/docker-php.conf &&\
    cp /tmp/php.ini /usr/local/etc/php/ &&\
    cp /tmp/php.ini /usr/local/etc/php/conf.d/

# install git && php ext
RUN sed -i 's/httpredir.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
	apt-get update && \
    apt-get install -y libgd-dev &&\
    docker-php-ext-install gd &&\
    docker-php-ext-enable gd &&\
    docker-php-ext-install exif &&\
    docker-php-ext-enable exif &&\
    rm -rf /var/lib/apt/lists/*

COPY ./src /tmp/upload-labs

# install upload-labs
RUN cd /tmp/ &&\
    rm -rf /var/www/html/* &&\
    mv /tmp/upload-labs/* /var/www/html/ &&\
    chown www-data:www-data -R /var/www/html/ && \
    rm -rf /tmp/*

EXPOSE 80
