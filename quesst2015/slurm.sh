#!/bin/bash


# ---- call as in:
#
#   sbatch slurm.sh quesst2015_dev_0001
#
#   squeue; ls Log
# 


#SBATCH -s
#SBATCH -n 1
#SBATCH -o /home/vagrant/Log/%j.o
#SBATCH -e /home/vagrant/Log/%j.e
#SBATCH -D /home/vagrant/scripts_for_participants/BUT_phn_post_and_btlneck_extr/SpeechDat/forward
#SBATCH --get-user-env


# Begin
echo "Starting at `date`, in `pwd`"

# Generate the output from the Hungarian MLP bottleneck
python3 src/forward.py \
	data/fbank \
	data/mlp_hungarian \
	~/dataset_noisy_shuffled/dev_queries/${1}.wav ~/${1}.btn.htk

# The same as the previous command but we output the posteriors
python3 src/forward.py --posteriors \
	data/fbank \
	data/mlp_hungarian \
	~/dataset_noisy_shuffled/dev_queries/${1}.wav ~/${1}.posteriors.htk

# You can process raw 16 bits data sampled at 8kHz by running
python3 src/forward.py --raw8khz \
	data/fbank \
	data/mlp_hungarian \
	../data/hungarian_cts/test.raw ~/test.raw.btn.htk

# The same with posteriors
python3 src/forward.py --raw8khz --posteriors \
	data/fbank \
	data/mlp_hungarian \
	../data/hungarian_cts/test.raw ~/test.raw.posteriors.htk

# You can also process data from the output of a command
#forward.py --command="gzip -cd" --raw8khz forward/data/fbank \
#  forward/data/mlp_hungarian test/test.raw.gz test.raw.gz.btn.htk
#forward.py --command="gzip -cd" forward/data/fbank \
#  forward/data/mlp_hungarian test/test.wav.gz test.wav.gz.btn.htk
#forward.py --command="gzip -cd" --posteriors forward/data/fbank \
#  forward/data/mlp_hungarian test/test.wav.gz test.wav.gz.posteriors.htk

# Done
echo "Done ($?) at `date`, ran on $SLURM_NODELIST ($SLURM_NNODES, $SLURM_NPROCS)"
