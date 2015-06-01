#!/bin/bash

#SBATCH -s
#SBATCH -n 1
#SBATCH -J tester
#SBATCH -o Log/%j.o
#SBATCH -e Log/%j.e
#SBATCH -D /opt/kaldi-offline-transcriber
#SBATCH --get-user-env

echo "Starting at `date`, in `pwd`"
sleep 20
#./speech2text.sh --nnet2-online false --nthreads 4 --trs build/output/`basename -s .flac ${1}`.trs ${1} 
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
