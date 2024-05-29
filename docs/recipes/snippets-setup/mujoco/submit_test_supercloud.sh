#!/bin/bash``

export MUJOCO_ENV_HOME=$HOME/software/mujoco/mujoco_env
export MUJOCO_ENV=/state/partition1/user/$USER/mujoco_env

if [ ! -d "$MUJOCO_ENV" ]; then
    echo "Copying $MUJOCO_ENV_HOME to $MUJOCO_ENV"
    mkdir -p /state/partition1/user/$USER
    cp -r $MUJOCO_ENV_HOME $MUJOCO_ENV
fi

module load anaconda/2022a
source $MUJOCO_ENV/bin/activate

python mujoco_test.py