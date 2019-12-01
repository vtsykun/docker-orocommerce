# OroCommerce CE Docker image.

The simple Docker image to start use OroCommerce.

## Quick Start

*Examples*

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

List of all tags you can found here.

Example usage with docker-compose [Nginx reverse proxy example](examples/01-basic-nginx-ssl).

*Please note that the first installation may take a long time 10-20 min. 
To to check the application logs and current status, 
use command `docker logs [container_name]`*

```
docker logs orocommerce --follow
```

## Additional Information

#### Enable websocket

To enable websocket, please use environment variable `ORO_WEBSOCKET=true`. By default websocket is disabled.

## Environment variables 

## Build image from source

## LICENSE

MIT
