# OroCommerce CE Docker image.

The simple Docker image to start use OroCommerce.

## Features

* A small Docker image (250-300 Mb) that based on `php:7.2-fpm-alpine`.
* Allows to enable/disable cron, websocket and consumers count.
* Easy to use - single container for web, cron, websocket and consumers.
* Assets are already pre-installed in the docker image.

## Quick Start

**Examples**

* [base-nginx-ssl](examples/01-basic-nginx-ssl). Use docker application with nginx reverse proxy.
* [nginx-websocket-ssl](examples/02-nginx-websocket-ssl). Enabled websocket.
* [remote-database](examples/03-remote-database). Use remote database.
* [add-custom-logo](examples/04-add-custom-logo). Add custom bundle with logo.

The docker image is based on `php:7.2-fpm-alpine` with installed `supervisor` and `nginx`.
No additional containers for consumers, websocket etc. You can select count of consumers,
disable/enable websocket. Platform update/install and init a cache will occur when creating the container.
To update OroCommerce application you need only pull a new version and run container again.

#### Pull from docker hub

```
docker pull okvpn/orocommerce:3.1
```

List of all tags you can found [here](https://hub.docker.com/r/okvpn/orocommerce).

**Please note that the first installation may take a long time 10-20 min. 
To check the application logs and current status, please 
use the command `docker logs [container_name]`**

```
docker logs orocommerce --follow
```

## Additional Information

Docker composer example.

```yaml
version: '2'

services:
    postgres:
        hostname: postgres
        container_name: postgres_orocommerce
        image: postgres:9.6
        volumes:
            - .docker/db:/var/lib/postgresql/data
        environment:
            POSTGRES_DB: orocommerce
            POSTGRES_PASSWORD: 123456
        expose:
            - "5432"

    orocommerce:
        image: okvpn/orocommerce:4.1
        container_name: orocommerce
        hostname: orocommerce
        ports:
            - 127.0.0.1:8085:80
        volumes:
            - .docker/attachment:/var/www/orocommerce/var/attachment
            - .docker/media:/var/www/orocommerce/public/media
            - .docker/uploads:/var/www/orocommerce/public/uploads
        environment:
            # installation options
            APPLICATION_URL: https://orocommerce.companyname.org
            ADMIN_USER: admin
            ADMIN_PASSWORD: admin
            ADMIN_EMAIL: admin@example.com
            ADMIN_FIRST_NAME: Alieś
            ADMIN_LAST_NAME: Zagorski
            ORO_DATABASE_DRIVER: pdo_pgsql
            ORO_DATABASE_HOST: postgres
            ORO_DATABASE_PORT: 5432
            ORO_DATABASE_USER: postgres
            ORO_DATABASE_NAME: orocommerce
            ORO_DATABASE_PASSWORD: 123456

```

#### Enable websocket
To enable websocket, please use environment variable `ORO_WEBSOCKET=true`. By default websocket is disabled.

#### Disable crontab
Cron is enabled by default. Use `ORO_CRON=false` to disable cron.

#### Disable background jobs (consumers)
Background jobs is enabled by default. You can use env `ORO_CONSUMER_COUNT=0`.  

## Environment variables 

#### Installation options
To install application need to create admin user, so you will be able to login to the backoffice. 
To create an admin account you need to use environment variables to pass in an initial username and password

* `ADMIN_USER` - Admin username

* `ADMIN_PASSWORD` - Admin password

* `ADMIN_EMAIL` - Admin email

* `ADMIN_FIRST_NAME` - First name

* `ADMIN_LAST_NAME` - Last name

* `APPLICATION_URL` - Application url

* `ORGANIZATION_NAME` - Main organization name

#### parameters.yml options 

* `ORO_DATABASE_DRIVER` - (pdo_pgsql, pdo_mysql)

* `ORO_DATABASE_HOST` - Database host 

* `ORO_DATABASE_PORT` - Database port 

* `ORO_DATABASE_USER` - Database user

* `ORO_DATABASE_NAME` - Database name 

* `ORO_DATABASE_PASSWORD` - Database password

Other env options, see [here](3.1/php/env-map.php)

#### Additional configuration

* `ORO_CRON` - Enable cron `ORO_CRON=false`

* `ORO_WEBSOCKET` - Enable websocket `ORO_WEBSOCKET=true`

* `ORO_CONSUMER_COUNT` - Count of consumers. `ORO_CONSUMER_COUNT=2`

* `SKIP_ASSETS` - Skip install and build assets, default true. Assets are already pre-installed in the docker image. 

## Build image from source

```
docker build 3.1/ --tag='okvpn/orocommerce:3.1' --build-arg ORO_PLATFORM=3.1.15
```

## LICENSE

MIT
