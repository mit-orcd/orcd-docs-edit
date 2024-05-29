module load anaconda/2023a
mkdir /state/partition1/user/$USER
python -m venv /state/partition1/user/$USER/mujoco_env
source /state/partition1/user/$USER/mujoco_env/bin/activate
pip install 'mujoco-py<2.2,>=2.1'

pip install pkgname1
pip install pkgname2

python
import mujoco_py

cp -r /state/partition1/user/$USER/mujoco_env $/software/mujoco/

