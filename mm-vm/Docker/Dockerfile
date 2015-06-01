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
WORKDIR /home/docker


# --------------------------------------------------------------------------
#   The above is 'internal' stuff, below we do our own stuff
# --------------------------------------------------------------------------


RUN apt-get install -y software-properties-common openssh-server sudo nano
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential make sox ffmpeg portaudio19-dev tcl8.5-dev libreadline5


# set up slurm scheduler
RUN  apt-get install -y --no-install-recommends slurm-llnl
RUN  /usr/sbin/create-munge-key
RUN  mkdir /var/run/munge /var/run/slurm-llnl
ADD  slurm.conf /etc/slurm-llnl/slurm.conf
COPY reconf-slurm.sh /root/
# ^ need to automatically set the number of processors correctly


# set up DAV (e.g. for Box Sync), sshfs, samba, and nfs
# do "mount ~/box" as docker
#     needs '--privileged=true' when running the container
#     the file ~docker/.davfs2/secrets contains the Box account -- edit it
# do "mkdir ~/sshfs; sudo sshfs -o allow_other fmetze@islpc19.is.cs.cmu.edu:/home/fmetze ~/sshfs" as docker
#     needs '--cap-add SYS_ADMIN --device=/dev/fuse' (or --privileged=true) when running
# for samba, try "mount -t cifs -o user=administrator '\\192.168.0.1\Data' /tmp/myServer"
# for nfs?
RUN apt-get install -y --no-install-recommends debconf-utils davfs2 sshfs cifs-utils nano
RUN echo "davfs2  davfs2/suid_file        boolean true" | debconf-set-selections
RUN dpkg-reconfigure davfs2 -f noninteractive
RUN cp -r /etc/davfs2/ .davfs2 && chown -R docker .davfs2/ && sed -Ei 's/# use_locks       1/use_locks       0/' /home/docker/.davfs2/davfs2.conf
RUN sed -Ei 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
RUN echo "https://dav.box.com/dav user@andrew.cmu.edu  <box_password>" >> .davfs2/secrets && chmod 600 .davfs2/secrets
#RUN cd .davfs2 && rm secrets && ln -s /mnt/kitchen-sandbox/mm-vm/davfs2.secrets secrets && chown docker /mnt/kitchen-sandbox/mm-vm/davfs2.secrets || :
# ^ you could also link somewhere, if you expect to run the container with "-v /Users/metze:/mnt" or so
RUN echo "fmetze@rocks-login.is.cs.cmu.edu:/data /media/sshfs fuse.sshfs _netdev,rw,user,allow_other 0 0" >> /etc/fstab && echo "https://dav.box.com/dav/ /media/box davfs _netdev,rw,user 0 0" >> /etc/fstab
RUN adduser docker davfs2 && adduser docker fuse
RUN cd /media && mkdir box sshfs && chown docker box sshfs


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
