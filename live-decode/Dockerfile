# This file creates a container that runs X11 and SSH services
# The ssh is used to forward X11 and provide you encrypted data
# communication between the docker container and your local 
# machine.
#
# Xpra allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
# with disconnection and reconnection capabilities
#
# Xephyr allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
#
# Fluxbox and ROX-Filer creates a very minimalist way to 
# manages the windows and files.
#
# Author: Roberto Gandolfo Hashioka
# Date: 07/28/2013


FROM ubuntu:14.04.1
MAINTAINER Florian Metze "fmetze@cs.cmu.edu"

RUN apt-get update -y
RUN apt-get upgrade -y

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Installing gcc 4.8.3 as needed for Kaldi
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential g++ libatlas-base-dev subversion make automake libtool autoconf patch zlib1g-dev wget

# Installing the environment required: xserver, xdm, flux box, rox-filer and ssh
#RUN apt-get install --no-install-recommends -y xpra rox-filer openssh-server xserver-xephyr xdm fluxbox xvfb xterm sudo
RUN apt-get install --no-install-recommends -y openssh-server sudo

# Configuring xdm to allow connections from any IP address and ssh to allow X11 Forwarding. 
#RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config || :
#RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess || :
#RUN ln -s /usr/bin/Xorg /usr/bin/X || :
#RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
RUN mkdir /var/run/sshd

# Fix PAM login issue with sshd (but don't fail)
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd || :

# Upstart and DBus have issues inside docker. We work around in order to install firefox.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# Installing fuse package (libreoffice-java dependency) and it's going to try to create
# a fuse device without success, due the container permissions. || : help us to ignore it. 
# Then we are going to delete the postinst fuse file and try to install it again!
# Thanks Jerome for helping me with this workaround solution! :)
# Now we are able to install the libreoffice-java package  
# RUN apt-get -y install fuse  || :
# RUN rm -rf /var/lib/dpkg/info/fuse.postinst
# RUN apt-get -y install fuse

# Installing the apps: Firefox, flash player plugin, LibreOffice and xterm
# libreoffice-base installs libreoffice-java mentioned before
# RUN apt-get install -y libreoffice-base firefox libreoffice-gtk libreoffice-calc

# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Copy the files into the container
#ADD . /src

# Create the user
RUN useradd -m -d /home/docker -p `perl -e 'print crypt("?1zza4All", "aa"),"\n"'` -s /bin/bash docker
RUN sed -Ei 's/adm:x:4:/docker:x:4:docker/' /etc/group
RUN adduser docker sudo

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
RUN cd   /opt/kaldi-trunk/src   && find *bin -executable -type f -exec gzexe {} \;
RUN cd   /opt/kaldi-trunk/src   && find *bin -name "*~"          -exec rm    {} \;
RUN cd   /opt/kaldi-trunk/tools/openfst-1.3.4 && make clean

# for some reason non-root users do not get access to the "openfst-1.3.4" directory
#   (and simple chmod doesn't fix it)
RUN rm /opt/kaldi-trunk/tools/openfst; mkdir /opt/kaldi-trunk/tools/openfst; cd /opt/kaldi-trunk/tools/openfst-1.3.4; tar -cf ../t.tar .patched *; cd ../openfst; tar -xf ../t.tar; cd ..; rm t.tar

# Start xdm and ssh services.
EXPOSE 22

# Start SSH so we are ready to make a tunnel
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
#CMD ["/bin/bash", "/src/startup.sh"]
