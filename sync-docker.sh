#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-03-27T14:37:52+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 4.1/ --tag='okvpn/orocommerce:4.2.0-alpha' --build-arg ORO_PLATFORM=4.2.0-alpha --memory=4000mb && docker push 'okvpn/orocommerce:4.2.0-alpha' || exitCode=$(( exitCode | $?))
docker build 4.1/ --tag='okvpn/orocommerce:4.2' --build-arg ORO_PLATFORM=4.2.0-alpha --memory=4000mb && docker push 'okvpn/orocommerce:4.2' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.2.0-alpha' || true

exit $exitCode;