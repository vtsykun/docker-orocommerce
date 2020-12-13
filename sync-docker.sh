#!/usr/bin/env bash
set -Eeox pipefail

# Auto generated at 2020-12-13T22:50:09+00:00
docker pull php:7.2-fpm-alpine;
docker pull php:7.3-fpm-alpine;
exitCode=0;


docker build 4.1/ --tag='okvpn/orocommerce:4.1.10' --build-arg ORO_PLATFORM=4.1.10 --memory=4000mb && docker push 'okvpn/orocommerce:4.1.10' || exitCode=$(( exitCode | $?))
docker build 4.1/ --tag='okvpn/orocommerce:4.1' --build-arg ORO_PLATFORM=4.1.10 --memory=4000mb && docker push 'okvpn/orocommerce:4.1' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.1.10' || true
docker build 4.2/ --tag='okvpn/orocommerce:4.2.0-rc' --build-arg ORO_PLATFORM=4.2.0-rc --memory=4000mb && docker push 'okvpn/orocommerce:4.2.0-rc' || exitCode=$(( exitCode | $?))
docker build 4.2/ --tag='okvpn/orocommerce:4.2' --build-arg ORO_PLATFORM=4.2.0-rc --memory=4000mb && docker push 'okvpn/orocommerce:4.2' || exitCode=$(( exitCode | $?))
docker rmi 'okvpn/orocommerce:4.2.0-rc' || true

exit $exitCode;