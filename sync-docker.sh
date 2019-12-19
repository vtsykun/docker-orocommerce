#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2019-12-19T23:49:53+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.1-fpm-alpine;
exitCode=0;


docker build 3.1/ --tag='okvpn/orocommerce:3.1.15' --build-arg ORO_PLATFORM=3.1.15 --memory=4000mb && docker push 'okvpn/orocommerce:3.1.15' || exitCode=$(( exitCode | $?))
docker build 3.1/ --tag='okvpn/orocommerce:3.1' --build-arg ORO_PLATFORM=3.1.15 --memory=4000mb && docker push 'okvpn/orocommerce:3.1' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:3.1.15' || true

exit $exitCode;