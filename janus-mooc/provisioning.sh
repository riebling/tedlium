#!/bin/bash

echo "### WELCOME ###"
whoami
pwd
ls /vagrant
echo "### now working ###"

sudo apt-get update -y

sudo usermod -a -G audio vagrant

# software for the kitchen
sudo apt-get install -y xfce4-panel xfce4-terminal xfce4-quicklauncher-plugin xfce4-xkb-plugin gnome-icon-theme gnome-icon-theme-full tango-icon-theme lxappearance thunar software-properties-common gxmessage xterm
# sudo apt-get install -y chromium-browser xfce4-settings

# basic configuration for the kitchen
sudo -u vagrant tar -xvjf /vagrant/DOTconfig.tar.bz2
sudo -u vagrant tar -xvjf /vagrant/janus.tar.bz2
sudo -u vagrant cp /vagrant/DOTbash_aliases .bash_aliases
sudo -u vagrant cp /vagrant/DOTjanusrc .janusrc
sudo -u vagrant cp /vagrant/slurm.sh .

# set up slurm scheduler
sudo apt-get install -y slurm-llnl
/usr/sbin/create-munge-key
mkdir /var/run/munge /var/run/slurm-llnl
cp /vagrant/slurm.conf /etc/slurm-llnl
cp /vagrant/reconf-slurm.sh /root/
# ^ need to automatically set the number of processors correctly (during provisioning)

# software for janus
sudo apt-get install -y g++ libopenblas-dev libblas-dev git tk-dev tcl-dev portaudio19-dev libreadline6-dev

sudo add-apt-repository ppa:jon-severinsson/ffmpeg
sudo apt-get update
sudo apt-get install ffmpeg-dev

# other software
sudo apt-get install -y Dillo


echo "### DONE ###"
