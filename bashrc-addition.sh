
# Setup ZTF environment
if [ $UID -ne 0 ] && [ -z "$NOZTF" ]; then
	echo "Setting up ZTF environment (please wait)..."
	. /epyc/projects/ztf-jupyter/ztf-jupyterhub/env-setup.sh
fi
