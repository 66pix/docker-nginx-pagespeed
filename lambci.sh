#!/bin/bash

whoami

set -o nounset
set -o errexit

LAMBCI_BUILD_NUM_TRIMMED="$(echo -e "${LAMBCI_BUILD_NUM}" | tr -d '[[:space:]]')"
TAG="66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM_TRIMMED-layered"
TAG_SQUASHED="66pix/nginx-pagespeed:$LAMBCI_BUILD_NUM_TRIMMED"
TAG_LATEST="66pix/nginx-pagespeed:latest"

echo "Tag: $TAG"
echo "Tag: $TAG_SQUASHED"
echo "Tag: $TAG_LATEST"

docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"

echo "Building $TAG"
docker build -t "$TAG" .

echo "Image check"
docker images | grep "$TAG_SQUASHED"

# echo "Saving $TAG"
# docker save "$TAG" > layered.tar
echo "Squashing $TAG to $TAG_SQUASHED"
docker export $TAG | docker import $TAG_SQUASHED

# echo "Squashing $TAG"
# docker-squash -i layered.tar -o squashed.tar -t "$TAG_SQUASHED"

# echo "Loading $TAG_SQUASHED"
# cat squashed.tar | docker load

echo "Image check"
docker images | grep "$TAG_SQUASHED"

exit 1

# echo "Pushing $TAG_SQUASHED"
# docker push "$TAG_SQUASHED"

echo "Pushing $TAG"
docker push "$TAG"

echo "Creating latest from $TAG"
docker-squash -i layered.tar -o squashed.tar -t "$TAG_LATEST"

echo "Squashing latest"
cat squashed.tar | docker load

echo "Image check"
docker images

echo "Pushing latest"
docker push "$TAG_LATEST"
