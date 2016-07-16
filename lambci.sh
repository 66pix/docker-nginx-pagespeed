#!/bin/bash

whoami

set -o nounset
set -o errexit

LAMBCI_BUILD_NUM_TRIMMED="$(echo -e "${LAMBCI_BUILD_NUM}" | tr -d '[[:space:]]')"
NAME="66pix/nginx-pagespeed"
TAG="${NAME}:${LAMBCI_BUILD_NUM_TRIMMED}-layered"
TAG_SQUASHED="${NAME}:${LAMBCI_BUILD_NUM_TRIMMED}"
TAG_LATEST="${NAME}:latest"

echo "Tag: $TAG"
echo "Tag: $TAG_SQUASHED"
echo "Tag: $TAG_LATEST"

docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Building $TAG"
docker build -t "${TAG}" .

sleep 1

echo "Image check"
docker images -q "$TAG"

sleep 1

echo "Saving $TAG"
docker save $(docker images -q $TAG) > layered.tar
# echo "Squashing $TAG to $TAG_SQUASHED"
# docker export $(docker images -q $TAG) | docker import - $TAG_SQUASHED

sleep 1

echo "Squashing $TAG"
docker-squash -i layered.tar -o squashed.tar -t "$TAG_SQUASHED"

echo "Loading $TAG_SQUASHED"
cat squashed.tar | docker load

echo "Image check"
docker images -q "${TAG}"

sleep 1

echo "Pushing $TAG_SQUASHED"
docker push "$TAG_SQUASHED"

exit

echo "Creating latest from $TAG"
docker-squash -i layered.tar -o squashed.tar -t "$TAG_LATEST"

echo "Squashing latest"
cat squashed.tar | docker load

echo "Image check"
docker images

echo "Pushing latest"
docker push "$TAG_LATEST"
