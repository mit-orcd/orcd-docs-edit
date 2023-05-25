# Installing and Using Mujoco

Whether you are installing on Engaging, SuperCloud, or Satori, you’ll first have to install the Mujoco binaries. This process is the same on all systems.

## Install the Mujoco Binaries

First, install Mujoco itself somewhere in your home directory. This is as simple as downloading the Mujoco binaries, which can be found on their web page. For the release that you want, select the file that ends with “linux-x86_64.tar.gz”, for example for 2.3.0 select [mujoco-2.3.0-linux-x86_64.tar.gz](https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz). Right click, and copy the link address. Then you can download on one of the login nodes with the “wget” command, and untar:

```bash
wget https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz
tar -xzf mujoco-2.3.0-linux-x86_64.tar.gz
```

In order for mujoco-py to find the Mujoco binaries, set the following paths:

```bash
export MUJOCO_PY_MUJOCO_PATH=$HOME/path/to/mujoco230/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MUJOCO_PY_MUJOCO_PATH/bin
```

## Mujoco on Engaging

### Install Dependency

On Engaging, Mujoco requires an additional dependency, patchelf, that is very straightforward to install. First select a version on [this page](https://github.com/NixOS/patchelf/releases), right click the link that includes “-x86_64.tar.gz” and select “Copy link address” or similar. In this example I am using version 0.17.0. Then in a terminal on Engaging, create and go to the directory where you want to put the dependency and download the software with the wget or curl command and untar the download:

```bash
cd path/to/mujoco/deps
wget https://github.com/NixOS/patchelf/releases/download/0.17.0/patchelf-0.17.0-x86_64.tar.gz
tar -xzf patchelf-0.17.0-x86_64.tar.gz
```

If you are using a different version the URL and tar file name will be different.

Once you’ve run this command you should see a “bin” directory. Put the full path to this bin directory on your `PATH` environment variable:

```bash
export PATH=$HOME/path/to/mujoco/deps/bin:$PATH
```

### Install Mujoco-Py

First, make sure the `MUJOCO_PY_MUJOCO_PATH` and `LD_LIBRARY_PATH` environment variables are set pointing to your mujoco installation, and your PATH environment variable includes the path to the patchelf bin directory. You can use the “echo” command to do this:

```bash
echo MUJOCO_PY_MUJOCO_PATH
echo LD_LIBRARY_PATH
echo PATH
```

If any of these are not set properly you can set them as described above (see [here for MUJOCO_PY_MUJOCO_PATH, LD_LIBRARY_PATH](#install-the-mujoco-binaries), and [here for patchelf](#install-dependency)).

Next load either a Python or Anaconda module. In this example I loaded the python/3.8.3 module:

```bash
module load python/3.8.3
```

From here on you can follow the [standard instructions to install mujoco-py](https://github.com/openai/mujoco-py), using the `--user` flag where appropriate to install in your home directory, or install in an anaconda or virtual environment. Here I am installing in my home directory with `--user`:

```bash
pip install --user 'mujoco-py<2.2,>=2.1'
```

Start up python and import mujoco_py to complete the build process:

```bash
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
```

### Using Mujoco in a Job

To use Mujoco you’ll need to first load the same Python or Anaconda module you used to install mujoco-py. If you installed it into a conda environment or python virtual environment, load that environment as well. We recommend you do this in your job submission script rather than in your .bashrc or at the command line before you submit the job. This way you know your job is configured properly every time it runs. You can use the following test scripts to test your Mujoco setup in a job environment, and as a starting point for your own job:

``` py title="mujoco_test.py"
import mujoco_py
import os

mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)

print(sim.data.qpos)
sim.step()
print(sim.data.qpos)
```

``` bash title="submit_test.sh"
#!/bin/bash

# Load the same python/anaconda module you used to install mujoco-py
module load python/3.8.3

# Run the script
python mujoco_test.py
```

## Mujoco on SuperCloud

Mujoco, particularly mujoco-py, can be tricky to install on SuperCloud as it uses file locking during the install and whenever the package is loaded. File locking is disabled on the SuperCloud shared filesystem performance reasons, but is available on the local disk of each node. Therefore, one workaround is to install mujoco-py on the local disk of one of the login nodes and then copy the install to your home directory. To load the package, the install then needs to be copied to the local disk.

We’ve found the most success by doing this with a python virtual environment. By using a python virtual environment you can install any additional packages you need with mujoco-py, and they can be used along with packages in our anaconda module, unlike conda environments.

If you haven't already, first follow the instructions above to [install the Mujoco binaries](#install-the-mujoco-binaries).

### Create the Virtual Environment

Next create the virtual environment on the local disk of the login node and install mujoco-py (install the version you would like to use):

``` bash
module load anaconda/2023a
mkdir /state/partition1/user/$USER
python -m venv /state/partition1/user/$USER/mujoco_env
source /state/partition1/user/$USER/mujoco_env/bin/activate
pip install 'mujoco-py<2.2,>=2.1'
```

Now install any other packages you need to run your Mujoco jobs. With virtual environments you won’t see any of the packages you’ve previously installed with `pip install --user` or what you may have installed in another environment. You should still be able to use any of the packages in the anaconda module you’ve loaded, so no need to install any of those.

``` bash
pip install pkgname1
pip install pkgname2
```

Since you are installing into virtual environment, **do not use the `--user` flag**.

Once you’ve installed the packages you need, start Python and import mujoco_py to finish the build:

``` bash
python
import mujoco_py
```

Now that your environment is created, copy it to your home directory for permanent storage.

``` bash
cp -r /state/partition1/user/$USER/mujoco_env $/software/mujoco/
```

### Running a Job

Now whenever you use mujoco-py the installation will need to be on the local disk of the node(s) where you are running. In your job script you can add a few lines of code that will check whether the environment exists on the local disk, and if not copy it. You can run these lines during an interactive job as well.

``` bash
# Set some useful environment variables
export MUJOCO_ENV_HOME=$HOME/software/mujoco/mujoco_env
export MUJOCO_ENV=/state/partition1/user/$USER/mujoco_env

# Check if the environment exists on the local disk. If not copy it over from the home directory.
if [ ! -d "$MUJOCO_ENV" ]; then
    echo "Copying $MUJOCO_ENV_HOME to $MUJOCO_ENV"
    mkdir -p /state/partition1/user/$USER
    cp -r $MUJOCO_ENV_HOME $MUJOCO_ENV
fi

# Load an anaconda module, then activate your mujoco environment
module load anaconda/2023a
source $MUJOCO_ENV/bin/activate
```

### SuperCloud Test Scripts

The following are some test scripts you can use to check that your configuration worked.

``` py title="mujoco_test.py"
import mujoco_py
import os

mj_path = mujoco_py.utils.discover_mujoco()
xml_path = os.path.join(mj_path, 'model', 'humanoid.xml')
model = mujoco_py.load_model_from_path(xml_path)
sim = mujoco_py.MjSim(model)

print(sim.data.qpos)
sim.step()
print(sim.data.qpos)
```

``` bash title="submit_test.sh"
#!/bin/bash

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
```