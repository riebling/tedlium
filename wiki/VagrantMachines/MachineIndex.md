# Vagrant Machine Index #

## Arabic Transcriber ##
[Github URL](https://bitbucket.org/srvk/kitchen-sandbox/wiki/browse/VagrantMachines/ArabicTranscriber)

## KaldiLmBuild ##
Language Model building Kaldi experiment add-on
[KaldiLmBuild](https://bitbucket.org/srvk/kitchen-sandbox/wiki/VagrantMachines/KaldiLmBuild/README)

## Tedlium ##

1. Enhanced VM: TEDLIUM + Offline Transcriber

*     Download: 
*     Requirements: 4 GB host RAM, 2 cores
*     Recommended: Vagrant 1.7.2
*     README
*     FORUM

In addition to the contents of the base Tedlium VM, this also includes offline transcriber functionality which converts audio files to text transcriptions. It can function in a ‘black box’ mode where input files copied to a folder on the host computer automatically produce transcription files in another host folder. This VM also features tools to adapt your own language model from a training text file.

2. Base VM: TEDLIUM – Training a Kaldi model using the TED-LIUM data set

*     Download: [Tedlium Git URL](https://bitbucket.org/srvk/kitchen-sandbox/src/573a2e80c1d6d7dfdb74ce0b145548901fee4d90/Vagrant/tedlium/?at=master)
*     Requirements: 16 GB RAM 4 cores
*     Recommended: Vagrant 1.7.2
*     [Tedlium README](https://bitbucket.org/srvk/kitchen-sandbox/wiki/VagrantMachines/Tedlium/README)
*     FORUM

The TEDLIUM VM is a complete training experiment using training data and transcripts from TED talks released in the TEDLIUM_release1 data set. This is an advanced VM that requires a LOT of resources, resulting in pretty good (but still quite large) acoustic and language models. There is additional support (by way of an add-on experiment download) for neural net based decoding, including DNN models and PDNN tools.