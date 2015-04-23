#!/bin/bash

#SBATCH -s
#SBATCH -n 1
#SBATCH -o Log/%j.o
#SBATCH -e Log/%j.e
#SBATCH -D /opt/kaldi-offline-transcriber
#SBATCH --get-user-env

echo "Starting at `date`, in `pwd`"
./speech2text.sh --nnet2-online false --clean false --md5 true ${1}
# --trs build/output/`basename -s .flac ${1}`.trs ${1} 
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
