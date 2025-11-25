#!/bin/bash

module load miniforge

cd $CRYOSPARC_WORKDIR/cryosparc_master

DB_PATH=$CRYOSPARC_WORKDIR/cryosparc_database
PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

./install.sh --license $CRYOSPARC_LICENSE_ID \
             --hostname $(hostname) \
             --dbpath $DB_PATH \
             --port $PORT
