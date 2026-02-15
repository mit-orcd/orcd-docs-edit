---
tags:
- Engaging
- Howto Recipes
- cuda
- GPU
---

# CUDA-Q
CUDA-Q is a GPU-accelerated package for quantum simulations. In general, simulations are exponentially more expensive with an increasing qubit number, and the CUDA-Q framework enables simulations of larger systems than possible with a CPU alone. We will walk through installing and performing simulations with CUDA-Q on Engaging.

## Installation
We will set up a [virtual environment](https://orcd-docs.mit.edu/software/python/#creating-python-virtual-environments) for CUDA-Q as follows:
In a directory, which we will assume is named `cudaq`, run the following commands
```
module load miniforge
python -m venv cudaq_env
source cudaq_env/bin/activate
pip install cudaq
```
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
Now, load the appropriate modules and activate the `cudaq` virtual environment:
```
source cudaq_env/bin/activate
```
Finally, we will run the program for 28 qubits using the command below, which should take a few seconds on a GPU but would be prohitibitive to run with a CPU alone. Note that the `-- target nvidia` is not needed because CUDA-Q should automatically detect the GPU and use it.
```
python test_cudaq.py 28 --target nvidia
```
You should get an output similar to the one below, but the numbers 512 and 488 could be slightly different due to stochasticity. The "target nvidia" indicates that a GPU is being used. If it wasn't, the output would read "Running on target qpp-cpu".

```
Running on target nvidia
{ 0000000000000000000000000000:512 1111111111111111111111111111:488 }
```

## Using Multiple GPUs
TODO - link this: https://nvidia.github.io/cuda-quantum/latest/using/examples/multi_gpu_workflows.html

We can run the program using 
```
mpiexec -np <N> python3 program.py
```
Above, N is the number of GPUs, which must be a power of 2.

