FROM circleci/php:5.6-node-browsers

# Install php5-v8js
RUN sudo apt-get update && \
      sudo apt-get install -y \
          libv8-dev \
          libfreetype6-dev \
          libjpeg62-turbo-dev \
          libcurl4-openssl-dev \
          libsqlite3-dev
RUN sudo docker-php-ext-install gd
RUN sudo docker-php-ext-install curl
RUN sudo docker-php-ext-install calendar
RUN sudo docker-php-ext-install zip
RUN sudo docker-php-ext-install iconv
RUN sudo docker-php-ext-install json
RUN sudo docker-php-ext-install mysqli
RUN sudo docker-php-ext-install mysql
RUN sudo docker-php-ext-install pdo
RUN sudo docker-php-ext-install pdo_sqlite
RUN sudo docker-php-ext-install pdo_mysql

RUN printf "\n" | sudo CFLAGS=-w CPPFLAGS=-w pecl install v8js-0.1.3
RUN echo "extension = v8js.so" | sudo tee -a /usr/local/etc/php/php.ini

# Set Timezone
RUN echo "Europe/Berlin" | sudo tee /etc/timezone
RUN echo "date.timezone = \"Europe/Berlin\"" | sudo tee -a /usr/local/etc/php/php.ini

# Install grunt
RUN sudo npm i -g grunt-cli
