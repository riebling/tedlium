#!/bin/bash

# for slurm
/usr/sbin/munged -f
/usr/sbin/slurmctld
/usr/sbin/slurmd

# start SSH
/usr/sbin/sshd -D
