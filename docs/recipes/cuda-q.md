---
tags:
- Engaging
- Howto Recipes
- cuda
- GPU
---

# CUDA-Q
CUDA-Q is a GPU-accelerated package for quantum simulations. Large quantum systems can be simulated with this framework. We will walk through installing and performing simulations with CUDA-Q on Engaging.

## Installation
We will set up a [virtual environment](https://orcd-docs.mit.edu/software/python/#creating-python-virtual-environments) for CUDA-Q as follows:
In your directory of choice (we'll assume it's called `cudaq`), run the following commands (TODO - might want to break this up a bit)
```
module load miniforge
module load cuda (TODO - are these two needed here?)
module load openmpi
python -m venv cuda-q_env
source cudaq_env/bin/activate
pip install cudaq
```
Note that we load cuda (TODO describe this) and openmpi (TODO describe this).

Now that we've installed CUDA-Q, we will follow a few different examples from the [CUDA-Q docs](https://nvidia.github.io/cuda-quantum/latest/index.html).

## Basic Usage Example
We will run a small example to verify GPU acceleration, following the check [here](https://nvidia.github.io/cuda-quantum/latest/using/quick_start.html).

Paste the following code into a python file named `test_cudaq.py`:
```
import sys
import cudaq

print(f"Running on target {cudaq.get_target().name}")
qubit_count = int(sys.argv[1]) if 1 < len(sys.argv) else 2


@cudaq.kernel
def kernel():
    qubits = cudaq.qvector(qubit_count)
    h(qubits[0])
    for i in range(1, qubit_count):
        x.ctrl(qubits[0], qubits[i])
    mz(qubits)


result = cudaq.sample(kernel)
print(result)  # Example: { 11:500 00:500 }
```
Now, we will run this with a GPU and verify that it is faster than with a CPU alone.
First, request a node with a GPU using the following command:
```
salloc -p mit_normal_gpu -G 1
```
Now, load the appropriate modules and activate the `cudaq` (TODO - do we want this ticks here?) virtual environment:
```
module load miniforge
module load cuda
module load openmpi
source cudaq_env/bin/activate
```
Finally, we will run the program for 28 qubits, which would be prohitibitive to run with a CPU alone (TODO - double check this and make consistent with the statement above):
```
python test_cudaq.py --target nvidia
```
You should get an output of this format, but the numbers could be slightly different due to stochasticity:
```
Running on target nvidia
{ 0000000000000000000000000000:512 1111111111111111111111111111:488 }
```

## Using One GPU

## Using Multiple GPUs
TODO - link this: https://nvidia.github.io/cuda-quantum/latest/using/examples/multi_gpu_workflows.html

We can run the program using 
```
mpiexec -np <N> python3 program.py
```
Above, N is the number of GPUs, which must be a power of 2.

