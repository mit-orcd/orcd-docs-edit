<hr />
<p>tags:
 - Engaging
 - SuperCloud
 - Howto Recipes
 - MuJoCo</p>
<hr />
<h1>Installing and Using MuJoCo</h1>
<p>MuJoCo is a free and open source physics engine that aims to facilitate research and development in robotics, biomechanics, graphics and animation, and other areas where fast and accurate simulation is needed.</p>
<p>You can learn about MuJoCo here: <a href="https://mujoco.org">https://mujoco.org</a>.</p>
<p>Whether you are installing on Engaging or SuperCloud, you’ll first have to install the MuJoCo binaries. This process is the same on all systems.</p>
<h2>Install the MuJoCo Binaries</h2>
<p>First, install MuJoCo itself somewhere in your home directory. This is as simple as downloading the MuJoCo binaries, which can be found on their web page. For the release that you want, select the file that ends with “linux-x86_64.tar.gz”, for example for 2.3.0 select <a href="https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz">mujoco-2.3.0-linux-x86_64.tar.gz</a>. Right click, and copy the link address. Then you can download on one of the login nodes with the “wget” command, and untar:</p>
<p><code>bash
wget https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz
tar -xzf mujoco-2.3.0-linux-x86_64.tar.gz</code></p>
<p>In order for mujoco-py to find the MuJoCo binaries, set the following paths:</p>
<p><code>bash
export MUJOCO_PY_MUJOCO_PATH=$HOME/path/to/mujoco230/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MUJOCO_PY_MUJOCO_PATH/bin</code></p>
<h2>MuJoCo on Engaging</h2>
<h3>Install Mujoco-Py</h3>
<p>First, make sure the <code>MUJOCO_PY_MUJOCO_PATH</code> and <code>LD_LIBRARY_PATH</code> environment variables are set pointing to your mujoco installation. You can use the “echo” command to do this:</p>
<p><code>bash
echo MUJOCO_PY_MUJOCO_PATH
echo LD_LIBRARY_PATH</code></p>
<p>If any of these are not set properly you can set them as described above (see <a href="#install-the-mujoco-binaries">here for MUJOCO_PY_MUJOCO_PATH, LD_LIBRARY_PATH</a>.</p>
<p>Next load either a Python or Anaconda module. In this example I loaded the latest anaconda3 module (run <code>module avail anaconda</code> to see the current list of available anaconda modules):</p>
<p><code>bash
module load anaconda3/2022.10</code></p>
<p>From here on you can follow the <a href="https://github.com/openai/mujoco-py">standard instructions to install mujoco-py</a>, using the <code>--user</code> flag where appropriate to install in your home directory, or install in an anaconda or virtual environment (do not use the <code>--user</code> flag if you want to install in a conda or virtual environment). Here I am installing in my home directory with <code>--user</code>:</p>
<p><code>bash
pip install --user 'mujoco-py&lt;2.2,&gt;=2.1'</code></p>
<p>Start up python and import mujoco_py to complete the build process:</p>
<!-- ```bash
python
import mujoco_py
```

If you’d like you can run the few example lines listed on install section of the mujoco-py github page to verify the install went through properly:

```python
import mujoco_py
import os
mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)
print(sim.data.qpos)
sim.step()
print(sim.data.qpos)
``` -->
<p>import mujoco_py
import os</p>
<p>mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)</p>
<p>print(sim.data.qpos)
sim.step()
print(sim.data.qpos)</p>
<h3>Using MuJoCo in a Job</h3>
<p>To use MuJoCo you’ll need to first load the same Python or Anaconda module you used to install mujoco-py. If you installed it into a conda environment or python virtual environment, load that environment as well. We recommend you do this in your job submission script rather than in your .bashrc or at the command line before you submit the job. This way you know your job is configured properly every time it runs. You can use the following test scripts to test your MuJoCo setup in a job environment, and as a starting point for your own job:</p>
<p>``` py title="mujoco_test.py"
import mujoco_py
import os</p>
<p>mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)</p>
<p>print(sim.data.qpos)
sim.step()
print(sim.data.qpos)
```</p>
<p>``` bash title="submit_test.sh"</p>
<h1>!/bin/bash</h1>
<h1>Load the same python/anaconda module you used to install mujoco-py</h1>
<p>module load python/3.8.3</p>
<h1>Run the script</h1>
<p>python mujoco_test.py
```</p>
<h2>MuJoCo on SuperCloud</h2>
<p>MuJoCo, particularly mujoco-py, can be tricky to install on SuperCloud as it uses file locking during the install and whenever the package is loaded. File locking is disabled on the SuperCloud shared filesystem performance reasons, but is available on the local disk of each node. Therefore, one workaround is to install mujoco-py on the local disk of one of the login nodes and then copy the install to your home directory. To load the package, the install then needs to be copied to the local disk.</p>
<p>We’ve found the most success by doing this with a python virtual environment. By using a python virtual environment you can install any additional packages you need with mujoco-py, and they can be used along with packages in our anaconda module, unlike conda environments.</p>
<p>If you haven't already, first follow the instructions above to <a href="#install-the-mujoco-binaries">install the MuJoCo binaries</a>.</p>
<h3>Create the Virtual Environment</h3>
<p>Next create the virtual environment on the local disk of the login node and install mujoco-py (install the version you would like to use):</p>
<p><code>bash
module load anaconda/2023a
mkdir /state/partition1/user/$USER
python -m venv /state/partition1/user/$USER/mujoco_env
source /state/partition1/user/$USER/mujoco_env/bin/activate
pip install 'mujoco-py&lt;2.2,&gt;=2.1'</code></p>
<p>Now install any other packages you need to run your MuJoCo jobs. With virtual environments you won’t see any of the packages you’ve previously installed with <code>pip install --user</code> or what you may have installed in another environment. You should still be able to use any of the packages in the anaconda module you’ve loaded, so no need to install any of those.</p>
<p><code>bash
pip install pkgname1
pip install pkgname2</code></p>
<p>Since you are installing into virtual environment, <strong>do not use the <code>--user</code> flag</strong>.</p>
<p>Once you’ve installed the packages you need, start Python and import mujoco_py to finish the build:</p>
<p><code>bash
python
import mujoco_py</code></p>
<p>Now that your environment is created, copy it to your home directory for permanent storage.</p>
<p><code>bash
cp -r /state/partition1/user/$USER/mujoco_env $/software/mujoco/</code></p>
<h3>Running a Job</h3>
<p>Now whenever you use mujoco-py the installation will need to be on the local disk of the node(s) where you are running. In your job script you can add a few lines of code that will check whether the environment exists on the local disk, and if not copy it. You can run these lines during an interactive job as well.</p>
<p>``` bash</p>
<h1>Set some useful environment variables</h1>
<p>export MUJOCO_ENV_HOME=$HOME/software/mujoco/mujoco_env
export MUJOCO_ENV=/state/partition1/user/$USER/mujoco_env</p>
<h1>Check if the environment exists on the local disk. If not copy it over from the home directory.</h1>
<p>if [ ! -d "$MUJOCO_ENV" ]; then
    echo "Copying $MUJOCO_ENV_HOME to $MUJOCO_ENV"
    mkdir -p /state/partition1/user/$USER
    cp -r $MUJOCO_ENV_HOME $MUJOCO_ENV
fi</p>
<h1>Load an anaconda module, then activate your mujoco environment</h1>
<p>module load anaconda/2023a
source $MUJOCO_ENV/bin/activate
```</p>
<h3>SuperCloud Test Scripts</h3>
<p>The following are some test scripts you can use to check that your configuration worked.</p>
<p>``` py title="mujoco_test.py"
import mujoco_py
import os</p>
<p>mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)</p>
<p>print(sim.data.qpos)
sim.step()
print(sim.data.qpos)
```</p>
<p>``` bash title="submit_test.sh"</p>
<h1>!/bin/bash</h1>
<p>export MUJOCO_ENV_HOME=$HOME/software/mujoco/mujoco_env
export MUJOCO_ENV=/state/partition1/user/$USER/mujoco_env</p>
<p>if [ ! -d "$MUJOCO_ENV" ]; then
    echo "Copying $MUJOCO_ENV_HOME to $MUJOCO_ENV"
    mkdir -p /state/partition1/user/$USER
    cp -r $MUJOCO_ENV_HOME $MUJOCO_ENV
fi</p>
<p>module load anaconda/2022a
source $MUJOCO_ENV/bin/activate</p>
<p>python mujoco_test.py
```</p>