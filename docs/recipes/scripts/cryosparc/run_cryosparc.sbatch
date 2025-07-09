#!/bin/bash

#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=4G
#SBATCH -p mit_normal
#SBATCH -J cryosparc_master
#SBATCH -o output/cryosparc_master-%N-%j.out
#SBATCH --signal=B:10@60 # send the signal '10' at 60s before job finishes

export PATH=$CRYOSPARC_WORKDIR/cryosparc_master/bin:$PATH

function cleanup()
{
    date
    echo -n "Shutting down CryoSPARC @ "; date
    cryosparcm start
    cryosparcm cli "remove_scheduler_target_node('$worker_host')"
    cryosparcm stop
    echo "Done"
}

# Shut down CryoSPARC cleanly when timeout is imminent
trap cleanup 10

# Shut down CryoSPARC cleanly when scancel is invoked
trap cleanup 15

export MASTER_HOST=$(hostname)

# Allow master node software to run on different nodes:
sed -i.bak 's/export CRYOSPARC_MASTER_HOSTNAME.*$/export CRYOSPARC_MASTER_HOSTNAME=\"'"$MASTER_HOST"'\"/g' $CRYOSPARC_WORKDIR/cryosparc_master/config.sh
grep -qxF "export CRYOSPARC_FORCE_HOSTNAME=true" "$CRYOSPARC_WORKDIR/cryosparc_master/config.sh" || echo 'export CRYOSPARC_FORCE_HOSTNAME=true' >> "$CRYOSPARC_WORKDIR/cryosparc_master/config.sh"

source $CRYOSPARC_WORKDIR/cryosparc_master/config.sh

cryosparcm start

# Print instructions for pulling up the UI:
cat 1>&2 <<END

To open the CryoSPARC user interface, port forward to the compute node in a new shell window on your local computer:

	ssh -L 61000:$(hostname):61000 ${USER}@orcd-login001.mit.edu

Now, point your web browser to http://localhost:61000

When you're finished, run:

scancel $SLURM_JOB_ID

END

sleep infinity &
wait
