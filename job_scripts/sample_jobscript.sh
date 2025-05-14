#!/bin/bash

#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --job-name=rstudio_job
#SBATCH --account=st-wang85-1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samuelleung124@gmail.com
#SBATCH -o output.txt
#PBS -e error.txt

################################################################################

# Change directory into the job dir
cd $SLURM_SUBMIT_DIR

# Load software environment
module purge
module load gcc/7.5.0 apptainer/1.3.1

# Set RANDFILE location to writeable dir
export RANDFILE=$TMPDIR/.rnd

# Generate a unique password for RStudio Server
export APPTAINERENV_PASSWORD=$(openssl rand -base64 15)

# Find a unique port for RStudio Server to listen on
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

# Set per-job location for the rserver secure cookie
export SECURE_COOKIE=$TMPDIR/secure-cookie-key

# Print connection details to file
cat > connection_${PBS_JOBID}.txt <<END

1. Create an SSH tunnel to RStudio Server from your local workstation using the following command:

ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@sockeye.arc.ubc.ca

2. Point your web browser to http://localhost:8787

3. Login to RStudio Server using the following credentials:

Username: ${USER}
Password: ${APPTAINERENV_PASSWORD}

When done using RStudio Server, terminate the job by:

1. Sign out of RStudio (Left of the "power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

scancel ${PBS_JOBID}

END

# CHANGE THESE FOR YOUR PROJECT
# IMAGEFILE is the name of your .sif file 
IMAGEFILE=rstudio-sockeye-tutorial.sif
# PROJDIR is the name of your project directory
PROJDIR=Rstudio-Sockeye

# HOME should be where your project directory is at
HOME=$SCRATCH_PATH/$PROJDIR

# IMAGE should be where your image directory is at
IMAGE=$PROJECT_PATH/rstudio/images/$IMAGEFILE

# Execute the rserver within the rocker/rstudio container
apptainer exec --bind $TMPDIR:/var/run/ --bind $TMPDIR:/var/lib/rstudio-server \
                --home $HOME $IMAGE \
                rserver --auth-none=0 --auth-pam-helper-path=pam-helper --secure-cookie-key-file \
                ${SECURE_COOKIE} --www-port ${PORT} --server-user ${USER}
