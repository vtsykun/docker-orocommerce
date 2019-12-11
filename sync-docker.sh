#!/usr/bin/env bash
set -Eeox pipefail

docker pull php:7.2-fpm-alpine;
docker pull php:7.1-fpm-alpine;
exitCode=0;

docker build 1.6/ --tag='okvpn/orocommerce:1.6.39' --build-arg ORO_PLATFORM=1.6.39 && docker push 'okvpn/orocommerce:1.6.39' || exitCode=$(( exitCode | $?))
docker build 1.6/ --tag='okvpn/orocommerce:1.6' --build-arg ORO_PLATFORM=1.6.39 && docker push 'okvpn/orocommerce:1.6' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:1.6.39' || true

exit $exitCode;