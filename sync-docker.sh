#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-07-30T10:06:53+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 4.1/ --tag='okvpn/orocommerce:4.2.0-alpha.3' --build-arg ORO_PLATFORM=4.2.0-alpha.3 --memory=4000mb && docker push 'okvpn/orocommerce:4.2.0-alpha.3' || exitCode=$(( exitCode | $?))
docker build 4.1/ --tag='okvpn/orocommerce:4.2' --build-arg ORO_PLATFORM=4.2.0-alpha.3 --memory=4000mb && docker push 'okvpn/orocommerce:4.2' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.2.0-alpha.3' || true

exit $exitCode;