#!/usr/bin/env bash
set -Eeox pipefail

docker build 3.1/ --tag='okvpn/orocommerce:4.1.0-beta' --build-arg ORO_PLATFORM=4.1.0-beta
docker push 'okvpn/orocommerce:4.1.0-beta'
docker build 3.1/ --tag='okvpn/orocommerce:4.1' --build-arg ORO_PLATFORM=4.1.0-beta
docker push 'okvpn/orocommerce:4.1'
docker rmi 'okvpn/orocommerce:4.1.0-beta' || true
