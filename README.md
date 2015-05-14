# Welcome
Welcome to the start page of the Speech Recognition Virtual Kitchen Docker and Vagrant sandbox Github Wiki

### Git tips: ###
"git push" is more like 3 steps:

1.   git add <newfile>
1.   git commit
1.   git push

To update a brand new Git repo with a tree of pre-existing code:

1.   git clone https://github.com/your-git-username/new-empty-repo-name.git
1.   # copy the code into the current working directory
1.   git push origin master

Useful equivalent to "svn up":

* git reset --hard origin/master

## [VagrantMachines](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines) ##
This page describes several machines from the [Speech Recognition Virtual Kitchen](http://speechkitchen.org) implemented as [Vagrant](https://www.vagrantup.com/) machines

### Overview
* [Prix Fixe]() ( coming soon )
* [Interaction in Virtual Worlds](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/ivw)
* [Mario XFCE](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Mario-XFCE)
* [Mario Base Box](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Mario-base)
* [Kaldi Base Box](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Mario-kaldi)
* [Arabic Transcriber](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Arabic-transcriber)
 [WIKI](https://github.com/riebling/srvk-sandbox/wiki/ArabicTranscriber)
* [Kaldi Language Model Builder](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines/KaldiLmBuild) an add-on to Kaldi based virtual machines to build language models from sample text
* [TEDLIUM](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/tedlium) a fully open-source Kaldi training setup which also has a graphical user interface with error analysis for speech developers.

# Vagrant Machine Index #

## Arabic Transcriber ##
[Github URL](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Arabic-transcriber)

## KaldiLmBuild ##
Language Model building Kaldi experiment add-on
[KaldiLmBuild](https://github.com/riebling/srvk-sandbox/wiki/Kaldi-Language-Model-Build)

## Tedlium ##

Base VM: TEDLIUM – Training a Kaldi model using the TED-LIUM data set

*     Download: [Tedlium Git URL](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/tedlium)
*     Requirements: 16 GB RAM 4 cores
*     Recommended: Vagrant 1.7.2
*     [Tedlium README](http://speechkitchen.org/tedlium-readme)
*     FORUM: http://speechkitchen.org/forums/forum/kaldi-tedlium-forum/

The TEDLIUM VM is a complete training experiment using training data and transcripts from TED talks released in the TEDLIUM_release1 data set. This is an advanced VM that requires a LOT of resources, resulting in pretty good (but still quite large) acoustic and language models. There is additional support (by way of an add-on experiment download) for neural net based decoding, including DNN models and PDNN tools.
