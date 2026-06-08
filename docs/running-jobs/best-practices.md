# Best Practices for Submitting Jobs

The following recommendations will help you make efficient use of the available resources, get your jobs started sooner, and avoid spending unnecessary time in the queue.

## Request CPU and memory

- Specify `--ntasks`, `--cpus-per-task`, and `--mem` (or `--mem-per-cpu`) explicitly rather than relying on defaults — defaults are rarely optimal for your workload.

- Make sure your program actually uses the cores you request. For multithreading programs, such as OpenMP or NumPy programs, set thread counts such as `OMP_NUM_THREADS` to match `--cpus-per-task` so you neither under-use nor oversubscribe your cores. For distributed jobs, launch tasks with `mpirun` or `srun` so they land on the allocated resources.

- **Request only as much memory as your program actually needs, since requesting more than necessary can delay scheduling.** Note that `--mem` specifies the memory per node, so when scaling on multiple cores, prefer `--mem-per-cpu` over `--mem` so that memory scales with the CPU count.

- Submit to as many eligible partitions as possible to maximize your usage up to your per-user limit, for example: `-p mit_normal,mit_preemptable`.

## Request GPUs

- If your job can run on any type of GPU, request a generic GPU with `--gres=gpu:1`. To request a specific type, use `--gres=gpu:l40s:1` for an L40S or `--gres=gpu:h200:1` for an H200.

- If your job does not specifically require an H200, **prefer an L40S**. The L40S is sufficient for many workloads (especially those using less than 48 GB of GPU memory) and is far more available, which usually means shorter queue times.

- **Request an H200 only when necessary.** Typical cases that require an H200 include:

    - AI training with large models.
    - Simulations that require FP64 precision.
    - Any job that requires 48–144 GB of GPU memory.

- Request no more than 4 CPU cores per GPU when possible. Our Slurm configuration reserves 4 CPU cores per GPU for GPU jobs, so requesting more than that can delay scheduling.

    !!! note "CPU cores per GPU for deep learning applications"
        Many deep learning workloads need more than 4 CPU cores per GPU, since data loading and preprocessing (for example, PyTorch `DataLoader` workers) are CPU-bound and can otherwise starve the GPU. In that case, request 6–8 CPU cores per GPU as a good starting point, and increase only if you confirm the data pipeline is still the bottleneck. Keep in mind that nodes provide roughly 16 CPU cores per GPU, so try to stay below that limit to avoid being blocked by a shortage of available CPU cores and delaying scheduling.

- For multi-GPU jobs, verify that your code actually scales before requesting more GPUs — extra GPUs that aren't used will just delay scheduling without speeding up your job.

- Try to keep all of your GPUs within a single node, and use multi-node, multi-GPU jobs only when necessary — for example, distributed deep learning or MPI simulations that require more memory than the combined memory of 8 GPUs.

- Submit to as many eligible partitions as possible to maximize your usage up to your per-user limit, for example: `-p mit_normal_gpu,mit_preemptable`.

## Use resources efficiently

- Set a realistic `--time` limit — just long enough to cover your job's expected run time. Shorter walltimes can backfill into scheduling gaps and start sooner.

- Release interactive sessions when you don't need it. For both CPU and GPU jobs, an idle interactive session still holds its allocated resources, counts against your allocation, lowers your fair-share factor, and blocks other users.

## Check job info

- While a job is pending, run `squeue --me` and check the `NODELIST(REASON)` column to see why it is waiting (for example, `Priority`, `Resources`, or a QOS limit). This tells you whether the delay comes from your request or from cluster load.

- After a job finishes, **run `jobstats <jobid>` to see the actual CPU, memory, and GPU usage.** Use that information to tune your next submission — over-requesting resources keeps your jobs in the queue longer and blocks others.

## Structure your jobs efficiently

- Test your job in a short interactive session before submitting a large batch job. This catches configuration errors cheaply, without waiting in the queue or wasting a large allocation.

- Use job arrays (`--array`) to run many similar tasks instead of submitting them as separate jobs. Arrays are easier to manage and friendlier to the scheduler.

- Checkpoint long-running jobs so they can resume rather than restart from scratch. **This is especially important on `mit_preemptable`**, where a job can be preempted at any time, and for any job that approaches its `--time` limit.

## Make your jobs reproducible

- Pin your software environment in the job script — specific module versions, a named conda environment, or a fixed container image. This keeps results reproducible and prevents your job from breaking when defaults change.

## Storage and I/O

- **Keep heavy I/O off your pool directory** (`~/orcd/pool`). Reading and writing many or large files on shared filesystems slows down both your job and everyone else's. Stage temporary data on the scratch directory (`~/orcd/scratch`), then copy only the results back when the job finishes.

- **Avoid working with very large numbers of small files.** Bundling data into archives or container formats (for example, tar, HDF5, or WebDataset) reduces stress on the parallel filesystem and usually speeds up your job.