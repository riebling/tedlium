# README #

This is the README for the QUESST 2015 Vagrant Virtual Machine.

## What This Is ##

In order to facilitate participation in MediaEval's 2015 QUESST task, 
we provide a Vagrant Virtual Machine (VM), which you can use to reproduce the results of a 
(not particularly sophisticated) baseline system, to verify that you are on a good track. Do not expect great results from this baseline,
but rather we want to demonstrate the main steps in developing a system, and in how to use the provided tools.

## Preliminaries ##

We do not provide separate systems or compiles for different operating systems, instead we distribute the example 
system in a Virtual Machine (VM). If you are not familiar with VMs, read up here: 
[The Speech Recognition Virtual Kitchen](http://www.speechkitchen.org/virtualization-setup "Virtualization Setup").
We are providing the QUESST 2015 VM as an "appliance" in the Virtual Kitchen's language.
In order to run the QUESST 2015 VM, you will need to first install Virtualbox for your platform. Get it at
[Virtualbox](https://www.virtualbox.org/wiki/Downloads "Choose 4.3.26"), and install it. Start it. There is no harm
in downloading and installing the current "Extension Pack", although you do not need it for the experiments described here.
Next, download and install Vagrant for your platform 
(Windows, Mac, or Linux): [VagrantUp](http://vagrantup.com/ "Vagrant Up"). Vagrant is only used to create the 
VM locally, so that you do not have to download it as one big piece. We assume you will use Vagrant with the "Virtualbox"
provider. If you do not want to do that, we assume you know what you are doing, and feel free to edit the Vagrantfile yourself
as needed, in order to create your VM, or let us know and we can provide the complete VM as a download.
While you're at it, you could also install [Vagrant-VBGuest](https://github.com/dotless-de/vagrant-vbguest/),
in order to facilitate keeping the software versions of Virtualbox and your VM's Virtualbox guest additions in sync.

## Getting The Virtual Machine ##

Once you have installed Virtualbox and Vagrant, extract the contents of the VM Archive (typically called `quesst2015-vm.tgz`, 
unless you checked it out from the `kitchen-sandbox/quesst2015` repository) into a folder 
(in fact, you have probably already done so), and open a shell there (i.e., open a Terminal window and `cd` into the
folder into which you extracted the archive). This should look like this
```
Florians-MacBook-Pro:quesst2015 metze$ ls
2xml.py            QUESST14_QbEDTW.py examples.sh        slurm.conf
DOTbash_aliases    README.md          forward.sh         slurm.sh
DOTconfig.tgz      Vagrantfile        provisioning.sh    xfce4-shutdown.sh
Makefile           dtw.sh             reconf-slurm.sh
```
If you want, edit `Vagrantfile`, so that the following lines corresponds to something your host computer can support
(2 processors, 8GB of RAM in this example). Pick a value that your current machine can well support (typically, you will want at least 3Gb per core).
```
  #   # Customize the amount of memory on the VM:
    vb.memory = "8192"
    vb.cpus = 2
  end
```

Now we are ready to get started. In the above shell directory, enter

```
Florians-MacBook-Pro:quesst2015 metze$ vagrant up
```
and (once the above command finished - this can take a while, depending on your network connectivity)
```
Florians-MacBook-Pro:quesst2015 metze$ vagrant ssh
```

As a result, you will have built your own VM with all the QUESST data and example tools, and you are now logged
in, without having to remember passwords, etc. Success! This little script downloaded the data, put it in the right place, and set-up
the tools. Basically, you should now see something like

```
vagrant@myvagrantbox:~$ ls
2xml.py  Example     Log       QUESST2015-dev      scripts_for_participants
dtw.sh   forward.sh  Makefile  scoring_quesst2015  slurm.sh
```

Not that you are now on a Ubuntu Linux 14.04 LTS box, which has the original `quesst2015` directory mounted under `/vagrant`, so you can easily
exchange data. For more information, read Vagrant's documentation.


## Using It ##

Please look at the provided `Makefile`. Basically, you have to execute the following steps in the above shell 
(the one you get when you are logged into the VM): 

### extract MLP features for both the data (in Audio) and the queries (dev, and possibly eval) ###

This will start a large number of jobs on the VM's slurm scheduler, which will extract features. Should not take too long,
but you may see warnings about the slurm scheduler temporarily not being able to accept any more jobs. Ignore them.
If some of the jobs crash, it is safe to just restart them using the `Makefile`.  
```
find QUESST2015-dev/dev_queries  -name '*.wav'|sed 's/^/Example\//'|sed 's/.wav/.hungarian.htk/'|xargs -n 1 make
find QUESST2015-dev/Audio        -name '*.wav'|sed 's/^/Example\//'|sed 's/.wav/.hungarian.htk/'|xargs -n 1 make
```

### fake the voice activity detection ###

or don't (as in this example), it's not strictly needed

### compute DTW matching (very time consuming) ###

Again, we will use the Makefile combined with the slurm scheduler:  
```
make Example/output/hungarian.lab
awk ' { printf ("Example/output/%s.lab\n", $0) } ' Example/output/hungarian.lab.utts | xargs -n 1 make
```

### normalize and calibrate the data ###

```
make Example/output/calibration.csv
```

### fuse (possibly multiple systems) and improve the joint ranking ###

```
make Example/output/fusion.csv
```

### prepare and get final scoring ###

```
make Example/output/score.out
```
You will find the results in the file you just made, look for actCnxe and actTWV (plus their min/ max values including the cut-off employed).

### remember ###

During login, you may also see a graphical user interface popping up, which is using `xfce4-panel`. Please ignore it for now.
Remember, the above is meant to show you how to build a complete functional STD system, and you should be able to also process
the evaluation data with the same steps, but do not expect great performance from this example. Things could also be implemented
much faster.


## Cleaning up ##

If you are done using the VM, simply log out. You can shut down the VM using the command
```
vagrant halt
```
from the host's command line (in the above directory). You can start it again and log in again by using the
```
vagrant up; vagrant ssh
```
sequence. If you want to destroy the VM and all its data, use
```
vagrant destroy
```
and all the data associated with the VM will be destroyed. If you want to see the configuration or fine-tune
aspects of the VM, you can also use Virtualbox' interface.

## Questions ##

Please contact [Florian Metze](mailto:fmetze@cs.cmu.edu). More help may be available at [https://bitbucket.org/srvk/kitchen-sandbox](https://bitbucket.org/srvk/kitchen-sandbox).
