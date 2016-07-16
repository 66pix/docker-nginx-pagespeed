#!/bin/bash

set -o nounset
set -o errexit

printenv

TAG="66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM-layered"
TAG_SQUASHED="66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM"
TAG_LATEST="66pix/nginx-pagespeed:latest"

docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Building $TAG"
docker build -t $TAG .
docker images

echo "Saving $TAG"
docker save $TAG > layered.tar

echo "Squashing $TAG"
docker-squash -from root -i layered.tar -o squashed.tar -t $TAG_SQUASHED

echo "Loading $TAG_SQUASHED"
cat squashed.tar | docker load
docker images

echo "Pushing $TAG_SQUASHED"
docker push $TAG_SQUASHED

echo "Creating latest from $TAG"
docker-squash -from root -i layered.tar -o squashed.tar -t $TAG_LATEST

echo "Squashing latest"
cat squashed.tar | docker load

echo "Pushing latest"
docker push $TAG_LATEST
