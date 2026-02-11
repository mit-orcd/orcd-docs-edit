---
tags:
 - Engaging
 - SuperCloud
 - Physics
 - Howto Recipes
 - Install Recipe
---

!!! warning
    This page has been archived. The information present is not updated and may no longer be accurate.

# Installing and Using MuJoCo

MuJoCo is a free and open source physics engine that aims to facilitate research and development in robotics, biomechanics, graphics and animation, and other areas where fast and accurate simulation is needed.

You can learn about MuJoCo here: [https://mujoco.org](https://mujoco.org).

Whether you are installing on Engaging or SuperCloud, you’ll first have to install the MuJoCo binaries. This process is the same on all systems.

## Install the MuJoCo Binaries

First, install MuJoCo itself somewhere in your home directory. This is as simple as downloading the MuJoCo binaries, which can be found on their web page. For the release that you want, select the file that ends with “linux-x86_64.tar.gz”, for example for 2.3.0 select [mujoco-2.3.0-linux-x86_64.tar.gz](https://github.com/deepmind/mujoco/releases/download/2.3.0/mujoco-2.3.0-linux-x86_64.tar.gz). Right click, and copy the link address. Then you can download on one of the login nodes with the “wget” command, and untar:

```bash
--8<-- "docs/recipes/scripts/mujoco/mujoco-binaries.sh:login"
```

In order for mujoco-py to find the MuJoCo binaries, set the following paths:

```bash
--8<-- "docs/recipes/scripts/mujoco/mujoco-binaries.sh:path"
```

## Install Mujoco-Py

First, make sure the `MUJOCO_PY_MUJOCO_PATH` and `LD_LIBRARY_PATH` environment variables are set pointing to your mujoco installation. You can use the “echo” command to do this:

```bash
--8<-- "docs/recipes/scripts/mujoco/mujoco-binaries.sh:env-var"
```

If any of these are not set properly you can set them as described above (see [here for MUJOCO_PY_MUJOCO_PATH and LD_LIBRARY_PATH](#install-the-mujoco-binaries)).

Next load either a Python or Anaconda module. In this example I loaded the `miniforge` module (run `module avail miniforge` to see the current list of available Anaconda modules):

```bash
--8<-- "docs/recipes/scripts/mujoco/mujoco-engaging-setup.sh:module"
```

From here on you can follow the [standard instructions to install mujoco-py](https://github.com/openai/mujoco-py), using the `--user` flag where appropriate to install in your home directory, or install in an anaconda or virtual environment (do not use the `--user` flag if you want to install in a conda or virtual environment). Here I am installing in my home directory with `--user`:

```bash
--8<-- "docs/recipes/scripts/mujoco/mujoco-engaging-setup.sh:install"
```

Start up python and import `mujoco_py` to complete the build process:

```python
import mujoco_py
```

If you’d like you can run the few example lines listed on install section of the mujoco-py github page to verify the install went through properly:

```python
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mujoco/mujoco_test.py"
```

## Using MuJoCo in a Job

To use MuJoCo you’ll need to first load the same Python or Anaconda module you used to install mujoco-py. If you installed it into a conda environment or python virtual environment, load that environment as well. We recommend you do this in your job submission script rather than in your `.bashrc` or at the command line before you submit the job. This way you know your job is configured properly every time it runs.

You can use the following test scripts to test your MuJoCo setup in a job environment, and as a starting point for your own job:

``` py title="mujoco_test.py"
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mujoco/mujoco_test.py"
```

``` bash title="submit_test.sh"
--8<-- "https://github.com/mit-orcd/orcd-examples/raw/main/mujoco/submit_test_engaging.sh"
```
