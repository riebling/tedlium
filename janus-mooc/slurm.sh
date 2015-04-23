#!/bin/bash

#SBATCH -s
#SBATCH -n 1
#SBATCH -o Log/%j.o
#SBATCH -e Log/%j.e
#SBATCH -D /home/vagrant
#SBATCH --get-user-env

echo "Starting at `date`, in `pwd`"
python3 scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/src/forward.py scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/data/fbank scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward/data/mlp_hungarian dataset_noisy_shuffled/dev_queries/${1}.wav ${1}.post
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
