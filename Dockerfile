# Designed to be run with bin/jh-run.sh
#

FROM jupyterhub/jupyterhub

MAINTAINER Mario Juric <mjuric@astro.washington.edu>

#
# Container fixups
#

# Do not exclude man pages & other documentation
# courtesy of https://github.com/tianon/docker-brew-ubuntu-core/issues/122#issuecomment-380529430
RUN rm /etc/dpkg/dpkg.cfg.d/excludes
# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
    rm -r /var/lib/apt/lists/*

# Install Jupyter into this container
RUN conda install jupyter -y

# Install missing ubuntu packages (needed by matplotlib, healpy, and oorb)
RUN apt-get update
RUN apt-get install -y libgl1-mesa-glx libgomp1 libgfortran3

# Useful utilities
RUN apt-get install -y man manpages-dev
RUN apt-get install -y joe vim emacs

# Install mysql
RUN apt-get install -y mariadb-server

# Install oauthenticator from git
RUN python3 -m pip install oauthenticator

# Create oauthenticator directory and put necessary files in it
RUN mkdir /srv/oauthenticator
WORKDIR /srv/oauthenticator
ENV OAUTHENTICATOR_DIR /srv/oauthenticator
ADD jupyterhub_config.py jupyterhub_config.py
RUN chmod 700 /srv/oauthenticator

# Inject our own Jupyter singleuser-server startup script
# It makes sure we switch to the /epyc/opt/anaconda environment
ADD single-user.sh /srv
RUN chmod +x /srv/single-user.sh

# Set up default kernels
RUN rm -rf /opt/conda/share/jupyter/kernels
RUN ln -s /usr/local/share/jupyter/kernels /opt/conda/share/jupyter/kernels
RUN mkdir -p /usr/local/share/jupyter
RUN ln -s /epyc/projects/ztf-jupyter/ztf-jupyterhub/kernels /usr/local/share/jupyter/kernels

# Add link to ztf to home directories (so notebooks can escape into the
# common dir)
RUN ln -s /epyc/projects/ztf-jupyter/common /etc/skel/common
RUN ln -s /epyc/data/ztf /etc/skel/ztf
RUN groupadd ztf

# Have bash source the LSST environment in an interactive shell
ADD bashrc-addition.sh bashrc-addition.sh
RUN cat bashrc-addition.sh >> /etc/bash.bashrc && rm bashrc-addition.sh

# Insert our startup script (re-creates users, as needed)
ADD start.sh /srv/oauthenticator/start.sh
RUN chmod 700 /srv/oauthenticator/start.sh
CMD ["/srv/oauthenticator/start.sh"]

# Copy couchbase libraries
ADD rh-libs/lib* /usr/lib/x86_64-linux-gnu/
RUN cd /usr/lib/x86_64-linux-gnu && ln -s libcouchbase.so.2.0.58 libcouchbase.so.2
