# Welcome
Welcome to the start page of the Speech Recognition Virtual Kitchen Docker and Vagrant sandbox Github Wiki

## [Overview]
This page describes several machines from the [Speech Recognition Virtual Kitchen](http://speechkitchen.org) implemented as [Vagrant](https://www.vagrantup.com/) machines

## [Wiki](https://github.com/srvk/srvk-sandbox/wiki/browse/VagrantMachines) ##

### Machine Descriptions
* [Prix Fixe]() ( coming soon )
* [offline-transcriber] This is an installation of Tanel Alumaes kaldi-offline-transcriber in a Docker container, using the live-decode one
* [swbd-transcriber] This transcribes telephony conversations, using the offline-transcriber.

You might get an error: https://bitbucket.org/fmetze/kitchen-sandbox/wiki/swbd-transcriber%20error 
* [ivw (Interaction in Virtual Worlds)](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/ivw)
* [Mario XFCE](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/Mario-XFCE)
* [Mario Base Box](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/Mario-base)
* [Kaldi Base Box](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/Mario-kaldi)
* [Arabic Transcriber](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/Arabic-transcriber)
 [WIKI](https://github.com/srvk/srvk-sandbox/wiki/ArabicTranscriber)
* [Kaldi Language Model Builder](https://github.com/srvk/srvk-sandbox/wiki/browse/VagrantMachines/KaldiLmBuild) an add-on to Kaldi based virtual machines to build language models from sample text
* [tedlium](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/tedlium) a fully open-source Kaldi training setup which also has a graphical user interface with error analysis for speech developers.

# Vagrant Machine Index #

## Arabic Transcriber ##
[Github URL](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/Arabic-transcriber)

## KaldiLmBuild ##
Language Model building Kaldi experiment add-on
[KaldiLmBuild](https://github.com/srvk/srvk-sandbox/wiki/Kaldi-Language-Model-Build)

## Tedlium ##

Base VM: TEDLIUM – Training a Kaldi model using the TED-LIUM data set

*     Download: [Tedlium Git URL](https://github.com/srvk/srvk-sandbox/tree/master/Vagrant/tedlium)
*     Requirements: 16 GB RAM 4 cores
*     Recommended: Vagrant 1.7.2
*     [Tedlium README](http://speechkitchen.org/tedlium-readme)
*     FORUM: http://speechkitchen.org/forums/forum/kaldi-tedlium-forum/

The TEDLIUM VM is a complete training experiment using training data and transcripts from TED talks released in the TEDLIUM_release1 data set. This is an advanced VM that requires a LOT of resources, resulting in pretty good (but still quite large) acoustic and language models. There is additional support (by way of an add-on experiment download) for neural net based decoding, including DNN models and PDNN tools.
