#!/bin/bash

echo "### WELCOME ###"
whoami
pwd
ls /vagrant
echo "### now working ###"

sudo apt-get update -y

sudo usermod -a -G audio vagrant

# software for the kitchen
sudo apt-get install -y xfce4-panel xfce4-quicklauncher-plugin xfce4-systemload-plugin xterm gnome-icon-theme gnome-icon-theme-full tango-icon-theme lxappearance thunar software-properties-common gxmessage
# sudo apt-get install -y chromium-browser

# basic configuration for the kitchen
sudo -u vagrant tar -xvzf /vagrant/DOTconfig.tgz
sudo -u vagrant cp /vagrant/DOTbash_aliases .bash_aliases
sudo -u vagrant cp /vagrant/slurm.sh /vagrant/Makefile /vagrant/forward.sh /vagrant/dtw.sh /vagrant/2xml.py .
sudo -u vagrant mkdir -p Log Example

# set up slurm scheduler
sudo apt-get install -y slurm-llnl
/usr/sbin/create-munge-key
mkdir /var/run/munge /var/run/slurm-llnl
cp /vagrant/slurm.conf /etc/slurm-llnl
cp /vagrant/reconf-slurm.sh /root/
# ^ need to automatically set the number of processors correctly (done during provisioning)

# software for mediaeval
sudo apt-get install -y python-numpy python-scipy python3-numpy python3-scipy python3-dev python3-pip python3-nose g++ libopenblas-dev git gawk bc default-jre
sudo pip3 install Theano

# data for mediaeval
sudo apt-get -y install sshpass
SSHPASS=`wget -qO- https://cmu.box.com/shared/static/o7hwc4cmgbvjzv2bgspfyohfpywena7o`
sudo -u vagrant sshpass -p $SSHPASS sftp -Cp  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no mediaeval_sws@zdislava.fit.vutbr.cz:data/scoring_quesst2015.tgz .
sudo -u vagrant sshpass -p $SSHPASS sftp -Crp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no mediaeval_sws@zdislava.fit.vutbr.cz:data/scripts_for_participants .
sudo -u vagrant sshpass -p $SSHPASS sftp -Cp  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no mediaeval_sws@zdislava.fit.vutbr.cz:data/QUESST2015-dev.tgz .
#sudo -u vagrant sshpass -p $SSHPASS sftp -Crp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no mediaeval_sws@zdislava.fit.vutbr.cz:data/dataset_noisy_shuffled   .
#sudo -u vagrant wget -qO - https://cmu.box.com/shared/static/9nbu4sey8hd6yb813hxxhjmqzlpggbjl.tgz | tar -xvzf -
sudo -u vagrant tar -xvzf QUESST2015-dev.tgz
#sudo -u vagrant ln -s QUESST2015-dev dataset_noisy_shuffled
sudo -u vagrant tar -xvzf scoring_quesst2015.tgz
sudo -u vagrant rm scoring_quesst2015.tgz QUESST2015-dev.tgz
#cd scoring_quesst2015
#sudo -u vagrant mv groundtruth_quesst2015_dev/quesst2015.ecf.xml groundtruth_quesst2015_dev/quesst2015.ecf.xml.org
#sudo -u vagrant sed 's/utters/Audio/' groundtruth_quesst2015_dev/quesst2015.ecf.xml.org > groundtruth_quesst2015_dev/quesst2015.ecf.xml
#cd ../QUESST2015-dev
#sudo -u vagrant ln -s utters Audio
#cd
sudo -u vagrant cp /vagrant/QUESST14_QbEDTW.py /home/vagrant/scripts_for_participants/BUT_DTW


echo "### DONE ###"

# python3 scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/src/forward.py scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/data/fbank scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/data/mlp_hungarian dataset_noisy_shuffled/dev_queries/quesst2015_dev_0001.wav quesst2015_dev_0001.post
# sbatch slurm.sh quesst2015_dev_0002
