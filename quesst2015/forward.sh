#!/bin/bash

#SBATCH -s
#SBATCH -n 1
#SBATCH -o /home/vagrant/Log/%j.o
#SBATCH -e /home/vagrant/Log/%j.e
#SBATCH -D /home/vagrant/scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward
#SBATCH --get-user-env


# Begin
echo "Starting at `date`, in `pwd`"

# Generate the output from the Hungarian MLP bottleneck
python3 src/forward.py --posterior data/fbank data/mlp_${3} \
	${1} ${2}

# Done
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
