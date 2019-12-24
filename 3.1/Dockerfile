FROM ubuntu:xenial AS builder

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 PGPASSWORD=postgres

RUN apt-get update && apt-get install -y locales language-pack-en-base software-properties-common
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN add-apt-repository ppa:ondrej/php && apt-get update && \
    apt-get install -y --force-yes --no-install-recommends php7.2-mbstring php7.2-zip \
    php7.2-cli php7.2-common php7.2-dev php7.2-pgsql php7.2-mysql php7.2-curl \
    php7.2-gd php7.2-xmlrpc php7.2-bcmath php7.2-ldap php7.2-apcu \
    php7.2-xsl php7.2-intl php7.2-soap php7.2-bz2 php7.2-tidy

RUN apt-get install -y --force-yes curl git patch wget sudo

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && apt-get install -y --force-yes nodejs  && \
    chmod +x /usr/bin/composer && \
    mkdir /var/www/ && chown www-data:www-data -R /var/www/

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/postgresql.list && \
    apt-get update && apt-get install -y postgresql-9.6

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf
USER postgres
RUN /etc/init.d/postgresql start && sleep 10 &&\
    psql -c "ALTER USER postgres WITH PASSWORD '${PGPASSWORD}'" -d template1

USER www-data

ARG ORO_PLATFORM
RUN cd /var/www/ && \
    git clone -b ${ORO_PLATFORM} https://github.com/oroinc/orocommerce-application.git orocommerce && \
    composer global require hirak/prestissimo && \
    composer install --no-interaction --no-suggest --no-dev --prefer-dist --working-dir /var/www/orocommerce && \
    rm -rf /var/www/orocommerce/.git

USER root
WORKDIR /var/www/orocommerce
ENV HOME=/var/www/
# Create fake database connection
RUN set -eux; \
    /etc/init.d/postgresql start; sleep 15;\
    psql -U postgres -h 127.0.0.1 -c "CREATE DATABASE test;"; \
    psql -U postgres -h 127.0.0.1 -d test -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'; \
    find config -type f -name 'parameters.yml' \
        -exec sed -i "s/database_driver"\:".*/database_driver"\:" pdo_pgsql/g; s/database_name"\:".*/database_name"\:" test/g; s/database_user"\:".*/database_user"\:" postgres/g; s/database_password"\:".*/database_password"\:" postgres/g;" {} \; ;\
    sudo -u www-data php bin/console oro:assets:install --env=prod --timeout=1800 --symlink; \
    rm -rf var/cache/* var/logs/* vendor/oro/platform/build/node_modules


FROM php:7.2-fpm-alpine

RUN apk --no-cache add nginx supervisor curl imagemagick libpng nodejs npm \
    git rsync libldap freetype libjpeg-turbo bash nano sudo

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# workaround for https://github.com/docker-library/php/issues/240
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		postgresql-dev \
		icu-dev coreutils \
		curl-dev \
		libpng-dev openldap-dev \
		bzip2-dev libxml2-dev \
		libxslt-dev imap-dev tidyhtml-dev \
		imagemagick-dev \
		freetype-dev libjpeg-turbo-dev libpng-dev \
	; \
	\
	export CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS"; \
	\
#	install gd with jpeg
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd; \
    \
    docker-php-ext-install pdo pdo_pgsql pdo_mysql sysvsem opcache \
        bz2 soap xsl imap tidy xmlrpc mbstring iconv curl bcmath \
        ldap intl zip pcntl; \
    runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	echo $runDeps; \
	apk add --no-cache $runDeps; \
	\
	apk del --no-network .build-deps

COPY --from=builder --chown=www-data /var/www/orocommerce /var/www/orocommerce

# Default range for docker, see index.php
COPY php/www.conf /usr/local/etc/php-fpm.d/zzz-custom.conf
COPY php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini

COPY supervisord/supervisord.conf /etc/
COPY supervisord/* /etc/supervisor.d/
COPY nginx/nginx.conf /etc/nginx/
COPY php/app /usr/local/bin/
COPY php/index.php /var/www/orocommerce/public/
COPY php/install-checker.php php/env-map.php php/banner.txt /var/www/orocommerce/
COPY docker-entrypoint.sh /usr/local/bin/
RUN rm /etc/supervisor.d/supervisord.conf && chmod +x /usr/local/bin/app && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown www-data:www-data /var/tmp/nginx

WORKDIR /var/www/orocommerce
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 80
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
