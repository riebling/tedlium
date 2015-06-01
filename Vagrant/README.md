General README for Vagrant

This folder contains a Vagrantfile describing the configuration of a
virtual machine.

Assuming you have installed Vagrant and VirtualBox (and that they are both recent
versions that go together), here are a few things you can do with this:

1. In the folder where the Vagrantfile resides, you can download, provision, and
    launch the virtual machine with the command
    
    vagrant up
    
2. Assuming this has been run, you now have a running VM and can ssh into it with

    vagrant ssh
    
3. In the VM, you have a Ubuntu 14.04 machine with whatever was configured from
    the Vagrantfile. Some X11 tools are provided, so you can start xfce4-panel
    giving pushbutton access to GUI apps xterm, Chromium browser, and Thunar
    file manager
    
4. Exit the VM:  

    exit

5. Shut down the VM (after exiting):

    vagrant halt
    
6. Delete the VM and clean up

    vagrant destroy

To automatically update Virtualbox guest additions, install:

https://github.com/dotless-de/vagrant-vbguest
