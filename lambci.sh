#!/bin/bash

set -o nounset
set -o errexit

ENV

exit 1

# docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USER" -p "$DOCKER_PASS"
# docker images
# docker save "66pix/nginx-pagespeed:$CIRCLE_BUILD_NUM-layered" > layered.tar
# sudo docker-squash -from root -i layered.tar -o squashed.tar -t "66pix/nginx-pagespeed:$CIRCLE_BUILD_NUM"
# cat squashed.tar | docker load
# docker images
# docker push "66pix/nginx-pagespeed:$CIRCLE_BUILD_NUM"
# sudo docker-squash -from root -i layered.tar -o squashed.tar -t "66pix/nginx-pagespeed:latest"
# cat squashed.tar | docker load
# docker push "66pix/nginx-pagespeed:latest"
