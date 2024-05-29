wget https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz
tar -xzf mujoco-2.3.0-linux-x86_64.tar.gz

export MUJOCO_PY_MUJOCO_PATH=$HOME/path/to/mujoco230/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MUJOCO_PY_MUJOCO_PATH/bin

echo MUJOCO_PY_MUJOCO_PATH
echo LD_LIBRARY_PATH