#!/bin/bash

ls /home/docker/islpc21 > /tmp/p
diff /tmp/o /tmp/p | grep ">" | sed 's/> //' | awk ' { printf ("\"/home/docker/islpc21/%s\"\n", $0) } ' | xargs -n 1 -r sbatch /opt/kaldi-offline-transcriber/slurm.sh
mv /tmp/p /tmp/o
# find /home/docker/islpc21 -mmin -1 -and -type f -and -not \( -name "*.trs" -or -name ".txt" \) -exec sbatch /opt/kaldi-offline-transcriber/slurm.sh {} \;
