# OroCommerce CE Docker image.

The simple Docker image to start use OroCommerce.

## Quick Start
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
