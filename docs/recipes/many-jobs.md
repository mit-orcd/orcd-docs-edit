---
tags:
 - Engaging
 - Slurm
 - Howto Recipes
---

# Serial and parallel executions

=== "Engaging"

It often happens that users need to submit many jobs to run a program many times with different input parameters or files.  

It is straightforward to execute the command `sbatch` in a loop, but this approach is inefficient for job scheduling. When the interation number is large, it will slow down the Slurm scheduler and affects all users. 

A good practice is to use job array, which is much more effecient. Refer to [this page](https://github.mit.edu/MGHPCC/OpenMind/wiki/How-to-submit-a-job-array%3F) for details of job array. 

However, if a user submits too many jobs in a short time period, even with a job array, it will still slow down the Slurm scheduler. The maximum number of jobs per user on the cluster is set to be 500, so that there are not too many jobs are queueing in a time peiriod. It is good for a user to submit up to 500 jobs with a job array.

??? Number of jobs of an array
    On this page, the word job means either an invividualy job or a task in a job array. For ecample, submitting a job array with 100 tasks means submitting 100 jobs. 

When a user needs to run a program for more than 500 times, it is recommended to combine serial execution and/or parallel execution with job array.

On this page, we will introduce serial execution and parallel execution, and how to intergrate them with job array. A Python code [mycode.py](./scripts/many-jobs/mycode.py) is used for all examples. 

## Serial execution

Serial execution means executing multiple programs serially within a job. Here is an example job script that runs 10 programs serially. 

```
#!/bin/bash            # Bash shell
#SBATCH -t 02:00:00    # Two hours
#SBATCH -N 1           # 1 node
#SBATCH -n 2           # 2 CPU cores
#SBATCH --mem=2GB      # 2 GB of memory

N_PROGRAMS=10
for i in `seq 1 $N_PROGRAMS`     # Loop from 1 to number of tasks (=10).
do
   python mycode.py  $i    # Run the program serially
done
```

Each program uses 2 CPU cores and 2 GB of memory.

The program is executed 10 times with different input parameters (i.e. the loop index )for each time. The next execution will start after the current execution is completed. 

Note that the serial execution increases the total run time. Request a wall time that is long enough for all the programs to be completed. 

**This approach is good for short run time programs.** If each program requires a long run time, the total run time would exceed the maximum wall time limit. 


## Run multiple programs parallelly in a job

Serial execution means executing multiple programs paralelly within a job. Here is an example job script that runs 10 programs parallelly. 
```
#!/bin/bash            # Bash shell
#SBATCH -t 02:00:00    # Two hours
#SBATCH -N 1           # 1 node
#SBATCH -n 20          # 20 CPU cores
#SBATCH --mem=20GB     # 20 GB of memory

N_PROGRAMS=10
for i in `seq 1 $N_PROGRAMS` # Loop from 1 to number of programs
do
   python name.py $i &       # Run a program parallely in background
done
wait          # Wait for all programs to be completed, then exit the batch job. 
```

Each program uses 2 CPU cores and 2 GB of memory, so the job requires 20 CPU cores and 20 GB of memory in total. 

The main difference from the previous exampe is the `&` mark at the end of command that runs the program, which runs the program in the background, and all 10 programs start to run almost simultaneously.

The `wait` command at the end ensures that the batch job will not be terminated until all background programs are completed.  

Use the loop index in the Python code to set up different input parameters for the program.

***This approach is good for cases when each program requires a small number of CPU cores and a small amount of memory.*** If each program requires many CPU cores or large memory, running multiple jobs in parallel would require too many CPUs or too much memory, which does not fit within one node. 

## Combine parallel run and job array

You can use job array on top of this approach to scale up the number of programs. For example, simply adding a line `#SBATCH --array=0-999` to the above script, you submit `10 * 1,000 = 10,000` programs simultaneously. ***This approach is useful to submit a large number of programs beyond the per-user job limit, when each program requires small resources (CPUs and memory)***.


## Combine sequential run and job array

Here is an example of combining a sequential run and a job array. ***This approach is useful to submit a large number of short run time programs beyond the per-user job limit.*** 

First, write a script to run multiple programs sequentially,
```
# This is the bash script named run_serial.sh
for i in `seq 1 10`          # Loop for serial runs
do
    index=$(($1*$2+$i))      # Calculate global index
    python name.py $index    # Use global index as input
done
```
Here is the job script to run the above script with a job array, 
```
#!/bin/bash                     # Bash shell
#SBATCH -t 02:00:00             # Two hours
#SBATCH -N 1                    # 1 node
#SBATCH --ntasks-per-core=1     # 1 task per CPU core: turn off hyperthreading.
#SBATCH -n 2                    # 2 physical CPU cores
#SBATCH --mem=2GB               # 2 GB of memory
#SBATCH --array=0-999           # Job array 

nmax=$SLURM_ARRAY_TASK_COUNT    # Num of tasks per array
id=$SLURM_ARRAY_TASK_ID         # Task ID
./run_serial.sh  $id  $nmax     # Execute a bash script
```
The input argument `$1` and `$2` of the run script is provided as the array task ID (`$SLURM_ARRAY_TASK_ID`) and total number of tasks in the array (`$SLURM_ARRAY_TASK_COUNT`), which are used to calculate the global index. Use the global index in the Python code to set up different input parameters for the program.

With this, you submit `10 * 1,000 = 10,000` programs simultaneously, which is beyond the per-user job limit.


## Combine sequential run, parallel run, and job array

Here is an example of combining a sequential run, a parallel run, and a job array. ***This approach is useful for submitting a large number of programs beyond the per-user job limit, when each program requires a short run time and small resources (CPUs and memory)***. 

First, write a script to run multiple programs sequentially and parallelly,
```
# This is the bash script named run_hybrid.sh
N_SERIAL=10
N_PARALLEL=10
for i in `seq 1 $N_SERIAL`        # Loop for serial runs
do
   for j in `seq 1 $N_PARALLEL`   # Loop for parallel runs
   do
     index=$(($1*$2+$i))          # Global index
     python name.py $index &      # Run a python program in background. Use global index as input
   done
   wait                           # Wait for all parallel runs complete, then go to the next step in the outer loop.
done 
```
Here is the job script to run the above script with a job array, 
```
#!/bin/bash               # Bash shell
#SBATCH -t 02:00:00       # Two hours
#SBATCH -N 1              # 1 node
#SBATCH --ntasks-per-core=1       # 1 task per CPU core: turn off hyperthreading.
#SBATCH -n 20             # 20 physical CPU cores
#SBATCH --mem=20GB        # 20 GB of memory
#SBATCH --array=0-999     # Job array 

nmax=$SLURM_ARRAY_TASK_COUNT     # Num of tasks per array
id=$SLURM_ARRAY_TASK_ID          # Task ID
./run_hybrid.sh $id $nmax        # Execute a bash script
```
With this, you submit `10 * 10 * 1,000 = 100,000` programs simultaneously, which is way beyond the per-user job limit.

> Note: The examples here are in bash. Users can use Python to implement them similarly. 



