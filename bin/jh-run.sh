#!/bin/bash
#
# Run JupyterHub
#

docker \
	run --rm -it -p 9976:9976 \
	--cpus=16 \
	--memory=128g \
	--name=ztf-jupyterhub \
	--hostname=ztf-jupyterhub \
	--env-file=/epyc/projects/ztf-jupyter/env \
	-v /var/lib/mysql/mysql.sock:/var/run/mysqld/mysqld.sock \
	-v /epyc/opt/anaconda:/epyc/opt/anaconda \
	-v /epyc/data/ztf:/epyc/data/ztf \
	-v /opt/rh:/opt/rh \
	-v /epyc/projects/ztf-jupyter/home:/home \
	-v /epyc/projects/ztf-jupyter:/epyc/projects/ztf-jupyter \
	jupyterhub-ztf
