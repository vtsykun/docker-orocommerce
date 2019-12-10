FROM php:7.2-fpm-alpine

RUN apk --no-cache add nginx supervisor curl imagemagick libpng nodejs-current npm \
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

ARG ORO_PLATFORM
RUN cd /var/www/ && \
    git clone -b ${ORO_PLATFORM} https://github.com/oroinc/orocommerce-application.git orocommerce && \
    composer global require hirak/prestissimo && \
    composer install --no-interaction --no-suggest --no-dev --prefer-dist --working-dir /var/www/orocommerce && \
    rm -rf /var/www/orocommerce/.git && \
    chown www-data:www-data /var/www/orocommerce -R

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
