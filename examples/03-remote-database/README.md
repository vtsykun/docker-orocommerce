## Use remote database 

You can use the application with remote database. 
In this example shows how to connect to host database from docker.

If you use postgres don't forgot update pg_hba.conf to allow connect from docker.

```
# /etc/postgresql/10/main/pg_hba.conf

# IPv4 local connections:
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    orocommerce     all             172.16.0.0/12           md5
```

And update connection settings `postgresql.conf` to listen on docker IP

```
# /etc/postgresql/10/main/pg_hba.conf

listen_addresses = 'localhost, 172.17.0.1'              # what IP address(es) to listen on;
```

**Note** If you use PostgresSQL with not super user, you need create extension `uuid-ossp` manually.

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"
```

```yaml
version: '2'

services:
    orocommerce:
        image: okvpn/orocommerce:3.1
        container_name: orocommerce
        hostname: orocommerce
        ports:
            - 127.0.0.1:8080:80
        volumes:
            - .docker/attachment:/var/www/orocommerce/var/attachment
            - .docker/media:/var/www/orocommerce/public/media
            - .docker/uploads:/var/www/orocommerce/public/uploads
        environment:
            # installation options
            APPLICATION_URL: http://127.0.0.1:8080
            ADMIN_USER: admin
            ADMIN_PASSWORD: admin

#            Parameters.yml options
            ORO_DATABASE_DRIVER: pdo_pgsql
            ORO_DATABASE_HOST: 172.17.0.1
            ORO_DATABASE_PORT: 5432
            ORO_DATABASE_USER: postgres
            ORO_DATABASE_NAME: orocommerce
            ORO_DATABASE_PASSWORD: 123456
```
