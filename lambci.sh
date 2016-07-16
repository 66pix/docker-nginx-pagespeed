#!/bin/bash

set -o nounset
set -o errexit

printenv

TAG="66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM-layered"

docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Building $TAG"
docker build -t $TAG .
docker images

echo "Saving $TAG"
docker save $TAG > layered.tar

echo "Squashing $TAG"
docker-squash -from root -i layered.tar -o squashed.tar -t "66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM"

echo "Loading squashed $TAG"
cat squashed.tar | docker load
docker images

echo "Pushing $TAG"
docker push "66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM"

echo "Creating latest from $TAG"
docker-squash -from root -i layered.tar -o squashed.tar -t "66pix/nginx-pagespeed:latest"

echo "Squashing latest"
cat squashed.tar | docker load

echo "Pushing latest"
docker push "66pix/nginx-pagespeed:latest"
