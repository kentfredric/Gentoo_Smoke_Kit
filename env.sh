#!/bin/bash	
export CHROOTING=$( realpath $(dirname $0 ));
bash --rcfile "${CHROOTING}/env.rc"
