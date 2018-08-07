#!/bin/bash

#
# Source the environment
#
. "$(dirname $0)"/env-setup.sh

#
# Launch the IPython kernel
#
exec python -m ipykernel_launcher -f "$@"
