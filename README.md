# Sockeye-Rstudio

- Toy workspace to show how to work with Rstudio and sockeye

## What you will need:
- dockerhub account
- docker image you want to use
- access to sockeye

## Steps for running Rstudio on Sockeye
1. Go to your project directory with:

        cd $PROJECT_PATH

2. Make a new folder `images` to store the `.sif` images needed to run rstudio, and go into it with the following commands:

        mkdir {name-of-folder}
        cd {name-of-folder}

3. Build the dockerhub image as a SIF file:

        module load apptainer
        apptainer build {name-of-sif-image}.sif docker://{docker-image-path}

4. Go to your scratch directory, where your project should be in 

        cd $SCRATCH_PATH/{your-project-path}

5. Within the folder with your jobscript, run

        sbatch {your-job-script}.sh

    Wait a couple seconds, then view the contents of connection_jobid.txt (in your job dir, e.g. "connection_1234.txt") for SSH tunnel and connection instructions.

    When you're done, delete your job with 

        scancel {jobid}
        rm {jobid}.txt


        

## Making your own docker image

### REMINDER:
- if using `make` commands, be sure to edit the Makefile to your docker account and for your project

1. Go into `code/install_r_packages.r` and specify what packages you want to install
2. Build docker image by running `Make build` in the terminal of your project directory. If `make` command is not installed, you can also run:

        docker build -t {your-docker-acct}/{docker-image-name} .

3. Push docker image to dockerhub with either `Make push` or the following:

        docker push sleung124/rstudio-sockeye-tutorial