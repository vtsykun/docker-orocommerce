#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-08-17T11:15:23+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 4.1/ --tag='okvpn/orocommerce:4.1.7' --build-arg ORO_PLATFORM=4.1.7 --memory=4000mb && docker push 'okvpn/orocommerce:4.1.7' || exitCode=$(( exitCode | $?))
docker build 4.1/ --tag='okvpn/orocommerce:4.1' --build-arg ORO_PLATFORM=4.1.7 --memory=4000mb && docker push 'okvpn/orocommerce:4.1' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.1.7' || true

exit $exitCode;