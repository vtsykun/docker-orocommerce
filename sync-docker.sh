#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-10-14T10:56:26+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 4.2/ --tag='okvpn/orocommerce:4.2.0-beta' --build-arg ORO_PLATFORM=4.2.0-beta --memory=4000mb && docker push 'okvpn/orocommerce:4.2.0-beta' || exitCode=$(( exitCode | $?))
docker build 4.2/ --tag='okvpn/orocommerce:4.2' --build-arg ORO_PLATFORM=4.2.0-beta --memory=4000mb && docker push 'okvpn/orocommerce:4.2' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.2.0-beta' || true

exit $exitCode;