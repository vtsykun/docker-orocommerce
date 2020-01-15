#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-01-15T19:54:28+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 3.1/ --tag='okvpn/orocommerce:3.1.18' --build-arg ORO_PLATFORM=3.1.18 --memory=4000mb && docker push 'okvpn/orocommerce:3.1.18' || exitCode=$(( exitCode | $?))
docker build 3.1/ --tag='okvpn/orocommerce:3.1' --build-arg ORO_PLATFORM=3.1.18 --memory=4000mb && docker push 'okvpn/orocommerce:3.1' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:3.1.18' || true

exit $exitCode;