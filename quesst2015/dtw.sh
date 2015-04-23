#!/bin/bash

#SBATCH -s
#SBATCH -n 1
#SBATCH -o /home/vagrant/Log/%j.o
#SBATCH -e /home/vagrant/Log/%j.e
#SBATCH -D /home/vagrant
#SBATCH --get-user-env


# Begin
echo "Starting at `date`, in `pwd`"

# Generate the DTW
T=`mktemp -d`
echo ${1} > ${T}/utts
python ./scripts_for_participants/BUT_DTW/QUESST14_QbEDTW.py \
       --dist="corr" --logging=INFO --feats="hungarian.htk" \
       /home/vagrant/Example/QUESST2015-dev/dev_queries \
       /home/vagrant/Example/QUESST2015-dev/Audio \
       Example/output/hungarian.lab.dev ${T}/utts Example/output
       # --vad="Example/output/vad"
rm -rf ${T}

# Done
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
