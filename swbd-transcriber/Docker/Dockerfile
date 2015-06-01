# This file creates a kaldi-offline-transcriber VM, based on Tanel Alumäe's work
#
# Author: Florian Metze
# Date: 12/24/2014


FROM ubuntu:14.04
MAINTAINER Florian Metze "fmetze@cs.cmu.edu"

RUN apt-get update -y
RUN apt-get upgrade -y


# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux


# Create the 'docker' user
RUN useradd -m -d /home/docker -p `perl -e 'print crypt("?1zza4All", "aa"),"\n"'` -s /bin/bash docker
RUN sed -Ei 's/adm:x:4:/docker:x:4:docker/' /etc/group
RUN adduser docker sudo
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker
WORKDIR /home/docker


# --------------------------------------------------------------------------
#   The above is 'internal' stuff, below we do our own stuff
# --------------------------------------------------------------------------

# Installing gcc > 4.8.2 as needed for Kaldi
RUN apt-get install -y software-properties-common openssh-server sudo nano
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential g++ libatlas-base-dev subversion make automake libtool autoconf patch zlib1g-dev wget


# Compile Kaldi
RUN cd   /opt && svn co -r 4708 https://svn.code.sf.net/p/kaldi/code/trunk kaldi-trunk
RUN cd   /opt/kaldi-trunk/src   && sed -Ei 's/lm: base util/lm: base util fstext/' Makefile
# ^ fix missing dependency
RUN cd   /opt/kaldi-trunk/tools && make -j `lscpu -p|grep -v "#"|wc -l`
RUN cd   /opt/kaldi-trunk/src   && ./configure --shared
RUN cd   /opt/kaldi-trunk/src   && make depend
RUN cd   /opt/kaldi-trunk/src   && make -j `lscpu -p|grep -v "#"|wc -l`
RUN cd   /opt/kaldi-trunk/src   && make ext
# ^ would really like to parallelize, but crashes
RUN find /opt/kaldi-trunk/src -name '*.a' -or -name '*.o' -exec rm {} \;
# ^ there is no 'make clean', is there?
RUN cd   /opt/kaldi-trunk/src   && find *bin \( -executable -type f \) -print0 | xargs -0 -n 1 -P `lscpu -p|grep -v "#"|wc -l` gzexe
RUN cd   /opt/kaldi-trunk/src   && find *bin -name "*~" -exec rm {} \;
RUN cd   /opt/kaldi-trunk/tools/openfst-1.3.4 && make clean
#
# for some reason non-root users do not get access to the "openfst-1.3.4" directory
#   (and simple chmod doesn't fix it)
RUN cd /opt/kaldi-trunk/tools/openfst-1.3.4 && rm ../openfst; mkdir ../openfst && tar -cf - .patched * | tar -C ../openfst -xf - && cd .. && rm -rf openfst-1.3.4 && mv openfst openfst-1.3.4 && ln -s openfst-1.3.4 openfst 


# Get Tanel Alumae's framework & other audio stuff
RUN add-apt-repository -y ppa:mc3man/trusty-media
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends python-pip python-dev git curl ruby-mustache ffmpeg sox libsox-fmt-mp3 openjdk-6-jre
RUN export CPLUS_INCLUDE_PATH=/opt/kaldi-trunk/tools/openfst/include/; export LIBRARY_PATH=/opt/kaldi-trunk/tools/openfst/lib:/opt/kaldi-trunk/tools/openfst/lib/fst/; pip install pyfst
RUN git -C /opt clone https://github.com/alumae/kaldi-offline-transcriber.git && git -C /opt/kaldi-offline-transcriber checkout 89ab0a61bca62bbb19764f55d6557e5aee84c50d
RUN curl http://bark.phon.ioc.ee/tanel/kaldi-offline-transcriber-data-2014-12-17.tgz | tar -xvzC /opt/kaldi-offline-transcriber
# ADD kaldi-offline-transcriber-data-2014-12-17.tgz /opt/kaldi-offline-transcriber
RUN cd /opt/kaldi-offline-transcriber && echo "KALDI_ROOT=/opt/kaldi-trunk" > Makefile.options && make .init -j `lscpu -p|grep -v "#"|wc -l`
# ^ this step needs more than 2GB RAM in the boot2docker VM (Win/ OSX)
RUN cd   /opt/kaldi-offline-transcriber && wget http://media.kuku.ee/intervjuu/intervjuu201306211256.mp3  && mkdir -m 777 -p build/audio/segmented build/audio/base build/diarization build/trans build/sid build/output && chmod 777 src-audio build build/audio
RUN echo -e "--- utils/validate_data_dir.sh\t2014-12-26 19:47:26.007156337 +0000\n+++ validate_data_dir.sh\t2014-12-26 19:42:44.376304196 +0000\n@@ -54,7 +54,7 @@\n fi\n \n \n-tmpdir=\$(mktemp -d kaldi.XXXX);\n+tmpdir=\$(mktemp -d --tmpdir kaldi.XXXX);\n trap 'rm -rf \"\$tmpdir\"' EXIT HUP INT PIPE TERM\n \n export LC_ALL=C" | patch /opt/kaldi-offline-transcriber/utils/validate_data_dir.sh
RUN echo "cd /opt/kaldi-offline-transcriber && ./speech2text.sh --nthreads \`lscpu -p|grep -v '#'|wc -l\` --ctm build/output/intervjuu201306211256.ctm intervjuu201306211256.mp3" > /opt/kaldi-offline-transcriber/test_est.sh && chmod 755 /opt/kaldi-offline-transcriber/test_est.sh


# Now let's clean up the Estonian
#RUN  cd /opt/kaldi-offline-transcriber && rm build/fst/data/prunedlm/tmp/* build/fst/data/dict/tmp/* && find build/fst kaldi-data \( -name '*.carpa' -or -name final.ie -or -name final.ubm -or -name '*.fst' \) -print0 | xargs -0 -n 1 -P `lscpu -p|grep -v "#"|wc -l` bzip2
# let's be brutal (temporarily)
RUN cd /opt/kaldi-offline-transcriber && rm -rf kaldi-data build/fst intervjuu201306211256.mp3 && find /opt/kaldi-trunk \( -name '*.a' -or -name '*.o' \) -exec rm {} \;

# Now let's make this into something English, copy files here (swbd-transcriber.tar.gz)
RUN  wget -q -O - https://cmu.box.com/shared/static/hyuunncetaspkyilq01x7lgnyhplhhbr.gz | tar -xvzC /opt/kaldi-offline-transcriber
# tar -cvzf /mnt/Work/Kitchen/kitchen-sandbox/swbd-transcriber/swbd-transcriber.tar.gz -C /opt/kaldi-offline-transcriber build/fst_swbd kaldi-data-swbd conf/mfcc_8kHz.conf conf/mfcc_sid_8kHz.conf conf/fbank_8kHz.conf steps_pdnn
# or: tar -C /opt/kaldi-offline-transcriber -cvzf - ... | ssh fmetze@islpc19.is.cs.cmu.edu "cat > swbd-transcriber.tar.gz"
# (kaldi-trunk.tar.gz)
#RUN  wget -q -O - https://cmu.box.com/shared/static/zrtx7z9se3p3erebze8cnnbgqk9b0xlu.gz | tar -xvzC /opt/kaldi-trunk
# tar -cvzf /mnt/Work/Kitchen/kitchen-sandbox/swbd-transcriber/kaldi-trunk.tar.gz -C /opt/kaldi-trunk egs/wsj/s5/utils/ali-to-pdf egs/wsj/s5/utils/analyze-counts egs/wsj/s5/utils/latgen-faster-mapped
COPY slurm.sh speech2text.sh /opt/kaldi-offline-transcriber/
COPY Makefile /opt/kaldi-offline-transcriber/kaldi-data-swbd/
RUN  mkdir -p /opt/kaldi-offline-transcriber/Log && chmod 777 /opt/kaldi-offline-transcriber/Log

# set up cron and sklearn for Aspect
COPY cron.sh /opt/kaldi-offline-transcriber/
RUN  apt-get update -y
RUN  apt-get install -y --no-install-recommends cron python-sklearn

# set up slurm scheduler
RUN  apt-get update -y
RUN  apt-get install -y --no-install-recommends slurm-llnl
RUN  /usr/sbin/create-munge-key
RUN  mkdir /var/run/munge /var/run/slurm-llnl
ADD  slurm.conf /etc/slurm-llnl/slurm.conf
COPY reconf-slurm.sh /root/
# ^ need to automatically set the number of processors correctly


# set up DAV, e.g. for Box Sync, sshfs, samba, and nfs
# the file ~docker/.davfs2/secrets contains the password to the Box account -- edit it
# do "mount ~/box" as docker -- all of this needs "--privileged=true" when running the container
# do "mkdir ~/islpc19; sudo sshfs -o allow_other fmetze@islpc19.is.cs.cmu.edu:/home/fmetze ~/islpc19" as docker
# for samba, try "mount -t cifs -o user=administrator '\\192.168.0.1\Data' /tmp/myServer"
RUN apt-get install -y --no-install-recommends debconf-utils davfs2 sshfs cifs-utils
RUN echo "davfs2  davfs2/suid_file        boolean true" | debconf-set-selections
RUN dpkg-reconfigure davfs2 -f noninteractive
RUN cp -r /etc/davfs2/ /home/docker/.davfs2 && chown -R docker /home/docker/.davfs2/ && sed -Ei 's/# use_locks       1/use_locks       0/' /home/docker/.davfs2/davfs2.conf
RUN echo "https://dav.box.com/dav fmetze@andrew.cmu.edu  <box_password>" >> /home/docker/.davfs2/secrets && chmod 600 /home/docker/.davfs2/secrets
#RUN cd .davfs2 && rm secrets && ln -s /mnt/kitchen-sandbox/mm-vm/davfs2.secrets secrets && chown docker /mnt/kitchen-sandbox/mm-vm/davfs2.secrets || :
# ^ you could also link somewhere, if you run the container with "-v /Users/metze:/mnt" or so
RUN echo "https://dav.box.com/dav/ /home/docker/box  davfs  _netdev,rw,user 0 0" >> /etc/fstab
RUN adduser docker davfs2 && adduser docker fuse
RUN mkdir /home/docker/box && chown docker /home/docker/box


# --------------------------------------------------------------------------
#   The below is needed for startup
# --------------------------------------------------------------------------

# supervisor installation && 
# create directory for child images to store configuration in
RUN apt-get install -y supervisor

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf
ADD slurm.sv.conf ssh.sv.conf /etc/supervisor/conf.d/

# clean up packages
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

# Start xdm and make ssh services accessible
RUN mkdir -p /var/run/sshd
EXPOSE 22

# default command (need ENTRYPOINT to overwrite previous ENTRYPOINT,
# CMD does not work)
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]
