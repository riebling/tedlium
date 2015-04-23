#!/bin/bash

sudo docker build --rm=true -t fmetze/swbd-transcriber-tmp .
sudo docker save fmetze/swbd-transcriber-tmp | sudo ~/docker-squash-bin/docker-squash -t fmetze/swbd-transcriber -verbose | pxz > swbd-transcriber.tar.xz
xz -cd swbd-transcriber.tar.xz | sudo docker load
sudo docker rmi  fmetze/swbd-transcriber-tmp

# CONTAINER_ID=$(sudo docker run -d --cap-add SYS_ADMIN --device /dev/fuse -P fmetze/swbd-transcriber)
# sudo docker exec -t -i $CONTAINER_ID bash -c "su docker"
