# rukzuk cicleci build image

# debian buster (images: https://circleci.com/docs/2.0/docker-image-tags.json / https://github.com/CircleCI-Public/circleci-dockerfiles/tree/master/php/images)
FROM circleci/php:7.3-buster-node-browsers

# Install php5-v8js
RUN sudo apt-get update && \
      sudo apt-get install -y \
          libfreetype6-dev \
          libjpeg62-turbo-dev \
          libcurl4-openssl-dev \
          libsqlite3-dev \
          libmcrypt-dev

# Add recent libv8 (required to build libv8; buster nodejs i
#  embeeded libv8.so (part of libnode-dev) is to old for php 7.3 compatible v8js - might work in the future)
#  this is build on bionic but works on buster
RUN echo "deb http://ppa.launchpad.net/stesie/libv8/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/stesie-ppa-libv8.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1A10946ED858A0DF
RUN sudo apt-get update && \
      sudo apt-get install -y libv8-7.5-dev

RUN echo "/opt/libv8-7.5/lib" | sudo tee -a /etc/ld.so.conf.d/libv8.conf
RUN sudo ldconfig

# Install and enable required php extensions
RUN sudo docker-php-ext-install gd
RUN sudo docker-php-ext-install curl
RUN sudo docker-php-ext-install calendar
RUN sudo docker-php-ext-install zip
RUN sudo docker-php-ext-install iconv
RUN sudo docker-php-ext-install json
RUN sudo docker-php-ext-install mysqli
RUN sudo docker-php-ext-install pdo
RUN sudo docker-php-ext-install pdo_sqlite
RUN sudo docker-php-ext-install pdo_mysql

# Install 3rd-party php extensions from pecl (with custom flags)
RUN sudo CFLAGS=-w CPPFLAGS=-w pecl install mcrypt
RUN echo "extension = mcrypt.so" | sudo tee -a /usr/local/etc/php/php.ini

RUN printf "\/opt/libv8-7.5\n" | sudo CFLAGS=-w CPPFLAGS=-w pecl install v8js-2.1.1
RUN echo "extension = v8js.so" | sudo tee -a /usr/local/etc/php/php.ini

# Set Timezone
RUN echo "Europe/Berlin" | sudo tee /etc/timezone
RUN echo "date.timezone = \"Europe/Berlin\"" | sudo tee -a /usr/local/etc/php/php.ini

# Install grunt
RUN sudo npm i -g grunt-cli
