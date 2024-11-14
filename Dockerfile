# use docker image set up for using R and RStudio
FROM docker.io/rocker/verse:4.1.0

# copy over all files/folders in current workspace
COPY . .

# Install R packages
RUN Rscript code/install_r_packages.r