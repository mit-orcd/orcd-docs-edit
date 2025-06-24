#!/bin/bash

cd $CRYOSPARC_WORKDIR/cryosparc_master

DB_PATH=$CRYOSPARC_WORKDIR/cryosparc_database

./install.sh --license $CRYOSPARC_LICENSE_ID \
             --hostname $(hostname) \
             --dbpath $DB_PATH \
             --port 61000
