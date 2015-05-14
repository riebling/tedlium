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

### [Overview](https://github.com/riebling/srvk-sandbox/wiki/VagrantMachines/MachineIndex)
* [Prix Fixe]() ( coming soon )
* [Interaction in Virtual Worlds]()
* [Arabic Transcriber](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines/ArabicTranscriber)
* [Kaldi Language Model Builder](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines/KaldiLmBuild) an add-on to Kaldi based virtual machines to build language models from sample text
* [Mario Base Box](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines/MarioBaseBox)
* [TEDLIUM](https://github.com/riebling/srvk-sandbox/wiki/browse/VagrantMachines/Tedlium) a fully open-source Kaldi training setup which also has a graphical user interface with error analysis for speech developers.

# Vagrant Machine Index #

## Arabic Transcriber ##
[Github URL](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/Arabic-transcriber)

## KaldiLmBuild ##
Language Model building Kaldi experiment add-on
[KaldiLmBuild](https://github.com/riebling/srvk-sandbox/wiki/Kaldi-Language-Model-Build)

## Tedlium ##

1. Enhanced VM: TEDLIUM + Offline Transcriber

*     Download: https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/tedlium
*     Requirements: 4 GB host RAM, 2 cores
*     Recommended: Vagrant 1.7.2
*     README: http://speechkitchen.org/tedlium-transcriber-readme/
*     FORUM: http://speechkitchen.org/forums/forum/kaldi-tedlium-forum/

In addition to the contents of the base Tedlium VM, this also includes offline transcriber functionality which converts audio files to text transcriptions. It can function in a ‘black box’ mode where input files copied to a folder on the host computer automatically produce transcription files in another host folder. This VM also features tools to adapt your own language model from a training text file.

2. Base VM: TEDLIUM – Training a Kaldi model using the TED-LIUM data set

*     Download: [Tedlium Git URL](https://github.com/riebling/srvk-sandbox/tree/master/Vagrant/tedlium)
*     Requirements: 16 GB RAM 4 cores
*     Recommended: Vagrant 1.7.2
*     [Tedlium README](http://speechkitchen.org/tedlium-readme)
*     FORUM: http://speechkitchen.org/forums/forum/kaldi-tedlium-forum/

The TEDLIUM VM is a complete training experiment using training data and transcripts from TED talks released in the TEDLIUM_release1 data set. This is an advanced VM that requires a LOT of resources, resulting in pretty good (but still quite large) acoustic and language models. There is additional support (by way of an add-on experiment download) for neural net based decoding, including DNN models and PDNN tools.
