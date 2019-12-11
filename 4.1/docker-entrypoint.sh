#!/usr/bin/env bash
set -Eeox pipefail

# Run install/ update command only under www-data user
# sudo -u www-data
# See bug https://github.com/oroinc/platform/issues/958

docker_install_application() {
  [[ -z "${ADMIN_FIRST_NAME}" ]] && ADMIN_FIRST_NAME='Alieś'
  [[ -z "${ADMIN_LAST_NAME}" ]] && ADMIN_LAST_NAME='Zagorski'
  [[ -z "${ADMIN_USER}" ]] && ADMIN_USER='admin'
  [[ -z "${ADMIN_EMAIL}" ]] && ADMIN_EMAIL='admin@example.com'
  [[ -z "${ADMIN_PASSWORD}" ]] && ADMIN_PASSWORD='admin'
  [[ -z "${ORGANIZATION_NAME}" ]] && ORGANIZATION_NAME='Oro'
  [[ -z "${APPLICATION_URL}" ]] && APPLICATION_URL='http://localhost'

  local dbDriver=$(cat config/parameters.yml | awk '/database_driver:/{ print $2 }')

  if [[ "$dbDriver" == "pdo_pgsql" ]]; then
    sudo -u www-data php bin/console doctrine:query:sql 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"' -vvv --env=prod || true
  fi

  sudo --preserve-env=LD_PRELOAD -u www-data php bin/console oro:install --env=prod --user-name="${ADMIN_USER}" --user-email="${ADMIN_EMAIL}" \
      --user-firstname="${ADMIN_FIRST_NAME}" --user-lastname="${ADMIN_LAST_NAME}" \
      --user-password="${ADMIN_PASSWORD}" --sample-data=n --organization-name="${ORGANIZATION_NAME}" \
      --no-interaction --application-url="${APPLICATION_URL}" --timeout=3600 --symlink
}

docker_configure_supervisor() {
  echo 'Update supervisor config'
  [[ -z "${ORO_CONSUMER_COUNT}" ]] && ORO_CONSUMER_COUNT=1
  [[ -z "${ORO_CRON}" ]] && ORO_CRON=true

  if [[ "$ORO_WEBSOCKET" == "true" ]]; then
    sed -i "s/autostart=.*/autostart=true/" /etc/supervisor.d/4-websocket.conf
  else
    sed -i "s/autostart=.*/autostart=false/" /etc/supervisor.d/4-websocket.conf
  fi

  if [[ "$ORO_CRON" == "true" ]]; then
    sed -i "s/autostart=.*/autostart=true/" /etc/supervisor.d/2-cron.conf
  else
    sed -i "s/autostart=.*/autostart=false/" /etc/supervisor.d/2-cron.conf
  fi

  sed -i "s/autostart=.*/autostart=true/" /etc/supervisor.d/3-consumer.conf
  sed -i "s/numprocs=.*/numprocs=$ORO_CONSUMER_COUNT/" /etc/supervisor.d/3-consumer.conf
}

echo 'Updating parameters.yml'
php env-map.php

docker_configure_supervisor
sudo -u www-data composer install --no-interaction --no-suggest --no-dev --prefer-dist --optimize-autoloader

chown www-data:www-data /var/www/orocommerce/var -R
chown www-data:www-data /var/www/orocommerce/public -R

# check if application is installed
[[ -z "${ORO_INSTALLED}" ]] && ORO_INSTALLED=$(php install-checker.php)
rm -rf var/cache/*

if [[ "$ORO_INSTALLED" == "false" ]]; then
  echo 'Install OroCommerce'
  sudo -u www-data php bin/console --env=prod > /dev/null || true
  sudo -u www-data php bin/console about --env=prod || true

  docker_install_application
else
  echo 'Clear cache'
  sed -i "s/installed"\:".*/installed"\:" true/g" config/parameters.yml
  sudo -u www-data php bin/console --env=prod > /dev/null || true
  sudo -u www-data php bin/console about --env=prod || true

  # Update application only one times (if a new container)
  if [[ ! -f '/.oro-installed' ]]; then
    echo 'Update application ...'
    sudo --preserve-env=LD_PRELOAD -u www-data php bin/console oro:platform:update --env=prod \
      --force --symlink --timeout=7200
  fi
fi

# Flag that application is installed or updated.
touch /.oro-installed
cat banner.txt

"$@"
