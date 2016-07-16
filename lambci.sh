#!/bin/bash

tar --version

exit

set -o nounset
set -o errexit

LAMBCI_BUILD_NUM_TRIMMED="$(echo -e "${LAMBCI_BUILD_NUM}" | tr -d '[[:space:]]')"
NAME="66pix/nginx-pagespeed"
TAG="${NAME}:${LAMBCI_BUILD_NUM_TRIMMED}"
TAG_LATEST="${NAME}:latest"

echo "Tag: $TAG"
echo "Tag: $TAG_LATEST"

docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Building $TAG"
docker build -t "${TAG}" .

echo "Pushing $TAG"
docker push "$TAG"

echo "Building $TAG_LATEST"
docker build -t "$TAG_LATEST" .

echo "Pushing latest"
docker push "$TAG_LATEST"
