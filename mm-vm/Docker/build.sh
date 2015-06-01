#!/bin/bash

sudo docker build --rm=true -t fmetze/mm-vm-big .
sudo docker save fmetze/mm-vm-big | sudo ~/docker-squash-bin/docker-squash -t fmetze/mm-vm -verbose | pxz > mm-vm.tar.xz
xz -cd mm-vm.tar.xz | sudo docker load
sudo docker rmi  fmetze/mm-vm-big

# CONTAINER_ID=$(sudo docker run -d --privileged=true -v /home/fmetze:/mnt -P fmetze/mm-vm)
# sudo docker exec -t -i $CONTAINER_ID bash -c "su docker"

LD_LIBRARY_PATH=/home/docker/sfep/asr_noisemes/libraries/openSmile/lib PBS_NUM_PPN=8 PYTHONPATH=.:/usr/lib/python2.7/dist-packages:/home/docker/sfep/asr_noisemes/base/lib/python2.7/site-packages ./extractLSPFeatures.py MED10TRN_fg.paths ./out /home/docker/sfep/asr_noisemes/noisemes/large_scale_feature_extraction/mergebaseANDmfcc_manual.ftr

mkdir sfep; sudo sshfs -o allow_other fmetze@rocks-login.is.cs.cmu.edu:/home/iyu/sfep sfep

software-properties-common, ffmpeg, portaudio19-dev, make, sox
