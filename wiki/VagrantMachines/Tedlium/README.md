# TEDLIUM README #

This is a full Kaldi model training experiment including (and requiring) a lot of resources. Before we get started, in case you should need it, the sudo password for this and all Vagrant machines ‘vagrant’.

1. *Download the Training Data* This machine uses a VirtualBox Shared Folder to hold the open source [TEDLIUM_release1](http://speechkitchen.org/vms/Data/db.zip) training data. Please download this data (as a zip file) and unzip it into the folder on your host computer created for this Vagrant machine. It will create a folder named “db” which the TEDLIUM VM will then mount and use for it’s “immutable” training data. It’s 16 GB, and will unzip into 16 GB, so you’ll need at least 32 GB free disk just for this part(!) – then you can delete the zip file and get some of that space back. -or- use curl (to install on linux: "sudo apt-get install curl") and get it with `curl http://speechkitchen.org/vms/Data/db.zip | tar zx`

2. *Shared Folder Setup* the `vagrant up` step will automatically configure the shared folder.

3. Running the Experiment First, shut down as many programs on your host computer as you can. VirtualBox will need that memory. Ssh into the machine with `vagrant ssh`. Everything will happen here. Start with these commands:

	cd /kaldi-trunk/egs/tedlium/s5
	./run.sh

The run.sh command will set off a VERY LONG process with many stages of data processing. It can easily 24 hours to complete(!) What is going on is that the shell script run.sh contains a series of steps, shell commands that run more shell commands that fomat the data, perform training, alignment, build models, decode models, perform scoring, etc.

This is an example of a successful run of the TEDLIUM experiment, and can also be found in the file `/kaldi-trunk/egs/tedlium/s5/shell.log`:

[TedliumOutput.txt](TedliumOutput)

Results get placed in folder `exp/` and build upon previous results. For example, the final stage puts results in folder `exp/tri3_mmi_b0.1`.

## Scoring ##

One way to find scores is to change path to the above named folder, then issue the command:

    grep "Percent Total Error" */score_*/ctm.filt.filt.dtl

Results will look like:

[ScoreOutput](https://bitbucket.org/srvk/kitchen-sandbox/wiki/edit/VagrantMachines/Tedlium/ScoreOutput)

Another way to look at scores is to look in files with names patterned after this:

`/kaldi-trunk/egs/tedlium/s5/exp/tri3_mmi_b0.1/decode_test_it4/score_20/ctm.filt.filt.sys`

The number after the underscore in ‘score_20′ is one of a range of values of different language model weightings; one of the scores for some number in this range will be the best.
Results will look like this:


```
#!
SYSTEM SUMMARY PERCENTAGES by SPEAKER
,-------------------------------------------------------------------------------------------.
| exp/tri3_mmi_b0.1/decode_test_it4/score_20/ctm.filt |
|-------------------------------------------------------------------------------------------|
| SPKR | # Snt # Wrd | Corr Sub Del Ins Err S.Err | NCE | 
|-------------------------+--------------+-----------------------------------------+--------|
| aimeemullins | 129 2897 | 82.1 13.7 4.2 2.9 20.8 93.0 | -0.021 |
|-------------------------+--------------+-----------------------------------------+--------|
| billgates | 151 4344 | 82.2 13.2 4.6 3.0 20.9 96.0 | -0.020 |
|-------------------------+--------------+-----------------------------------------+--------|
| s182 | 14 302 | 72.2 18.5 9.3 0.7 28.5 92.9 | 0.178 |
|-------------------------+--------------+-----------------------------------------+--------|
| danbarber | 235 2384 | 70.6 21.2 8.2 3.3 32.7 84.7 | -0.050 |
|-------------------------+--------------+-----------------------------------------+--------|
| danbarber_2010_s103 | 1 24 | 50.0 33.3 16.7 0.0 50.0 100.0 | -1.265 |
|-------------------------+--------------+-----------------------------------------+--------|
| danielkahneman | 127 3016 | 81.5 15.5 3.0 2.1 20.6 91.3 | 0.177 |
|-------------------------+--------------+-----------------------------------------+--------|
| s164 | 11 168 | 45.8 23.2 31.0 1.8 56.0 90.9 | 0.169 |
|-------------------------+--------------+-----------------------------------------+--------|
| ericmead_2009p_ericmead | 52 1511 | 80.3 13.4 6.3 2.6 22.3 96.2 | -0.028 |
|-------------------------+--------------+-----------------------------------------+--------|
| garyflake | 35 1102 | 82.6 13.6 3.8 3.5 21.0 94.3 | 0.079 |
|-------------------------+--------------+-----------------------------------------+--------|
| jamescameron | 95 2972 | 81.0 13.3 5.7 3.1 22.1 100.0 | 0.091 |
|-------------------------+--------------+-----------------------------------------+--------|
| janemcgonigal | 108 3821 | 80.5 14.9 4.7 3.2 22.7 99.1 | -0.023 |
|-------------------------+--------------+-----------------------------------------+--------|
| michaelspecter | 124 2969 | 80.1 13.5 6.4 2.1 22.0 94.4 | 0.064 |
|-------------------------+--------------+-----------------------------------------+--------|
| robertgupta | 37 878 | 83.4 12.9 3.8 3.3 19.9 91.9 | 0.351 |
|-------------------------+--------------+-----------------------------------------+--------|
| robertgupta_2010u_s57 | 1 2 | 0.0 0.0 100.0 0.0 100.0 100.0 | 0.000 |
|-------------------------+--------------+-----------------------------------------+--------|
| tomwujec | 35 1122 | 79.6 15.2 5.2 3.1 23.5 94.3 | -0.109 |
|===========================================================================================|
| Sum/Avg | 1155 27512 | 80.0 14.7 5.3 2.8 22.9 93.0 | 0.036 |
|===========================================================================================|
| Mean | 77.0 1834.1 | 70.1 15.7 14.2 2.3 32.2 94.6 | -0.027 |
| S.D. | 68.0 1451.0 | 22.7 7.0 24.8 1.2 21.8 4.2 | 0.362 |
| Median | 52.0 1511.0 | 80.3 13.7 5.7 2.9 22.3 94.3 | 0.000 |
`-------------------------------------------------------------------------------------------'
```

## Add-on experiment: Training and Decoding DNN Models ##

Because it could take upwards of two weeks to compute in a VM, we have taken the liberty of preparing in advance a neural network model trained on tedlium data. It is available to download as an “add-on” experiment (945 MB), which unzips in the working directory `/kaldi-trunk/egs/tedlium/s5`. To run it, follow these steps (assuming you have already run the previous experiment on this page, since some of it’s data gets re-used):


```
#!bash

cd /kaldi-trunk/egs/tedlium/s5
wget http://speechkitchen.org/vms/Data/tri4_dnn.tgz
tar zxvf tri4_dnn.tgz
./run_pdnn_decode.sh
```

This will download the trained model, the PDNN neural net scripts, and GMM model and features necessary to decode. Neural net based decoding can be done without a GPU since it runs in the forward direction, which is less compute intensive. To see the resulting word error rate scores from this experiment, run the script

`./score.sh`

## Add-on Experiment 2: Decoding With Neural Net Models and Filterbank Features ##

This experiment is similar to the previous one, but uses different features. To try it out, download and unzip the tarball, and run as follows:


```
#!bash

cd /kaldi-trunk/egs/tedlium/s5
wget http://speechkitchen.org/vms/Data/dnn_fbank.tgz
tar zxvf dnn_fbank.tgz
rm -rf steps_pdnn # forces version update
./run_fbank_decode.sh

```

Scoring is done in a similar manner, running the script score.sh (which replaces the one from the previous add-on experiment). If all goes well, results will look like this:

	mario@Mario:/kaldi-trunk/egs/tedlium/s5$ ./score.sh
	exp/fbank/decode/score_10/ctm.filt.filt.dtl:Percent Total Error = 21.3% (5871)
	exp/fbank/decode/score_11/ctm.filt.filt.dtl:Percent Total Error = 21.4% (5888)
	exp/fbank/decode/score_12/ctm.filt.filt.dtl:Percent Total Error = 21.5% (5904)
	exp/fbank/decode/score_13/ctm.filt.filt.dtl:Percent Total Error = 21.8% (5998)
	exp/fbank/decode/score_14/ctm.filt.filt.dtl:Percent Total Error = 22.1% (6080)
	exp/fbank/decode/score_15/ctm.filt.filt.dtl:Percent Total Error = 22.6% (6216)
	exp/fbank/decode/score_16/ctm.filt.filt.dtl:Percent Total Error = 23.1% (6356)
	exp/fbank/decode/score_17/ctm.filt.filt.dtl:Percent Total Error = 23.6% (6490)
	exp/fbank/decode/score_18/ctm.filt.filt.dtl:Percent Total Error = 24.0% (6605)
	exp/fbank/decode/score_7/ctm.filt.filt.dtl:Percent Total Error = 22.5% (6185)
	exp/fbank/decode/score_8/ctm.filt.filt.dtl:Percent Total Error = 21.8% (5991)
	exp/fbank/decode/score_9/ctm.filt.filt.dtl:Percent Total Error = 21.4% (5900)

## Adapting Your Own Language Model ##

In the folder `~/kaldi-trunk/egs/tedlium/s5/lm_build` are tools and examples to allow you to adapt a language model based on your own training text file. [This page](http://speechkitchen.org/kaldi-language-model-building/) has all the details.
