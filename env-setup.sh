####
#### Source this file to set up the proper conda + ZTF environment
####

#
# Setup our Conda environment
#
. /epyc/opt/anaconda/etc/profile.d/conda.sh
conda activate /epyc/projects/ztf-jupyter/conda-ztf-env

# Anaconda has a binary named `pager` which messes up man
export MANPAGER=less
