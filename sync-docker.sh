#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-01-14T16:07:05+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.1-fpm-alpine;
exitCode=0;


docker build 4.1/ --tag='okvpn/orocommerce:4.1.0-rc4' --build-arg ORO_PLATFORM=4.1.0-rc4 --memory=4000mb && docker push 'okvpn/orocommerce:4.1.0-rc4' || exitCode=$(( exitCode | $?))
docker build 4.1/ --tag='okvpn/orocommerce:4.1' --build-arg ORO_PLATFORM=4.1.0-rc4 --memory=4000mb && docker push 'okvpn/orocommerce:4.1' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.1.0-rc4' || true

exit $exitCode;