# Best Practices for Requesting Resources

The following recommendations will help your jobs start sooner and avoid spending unnecessary time in the queue.

## Maximize the resources available to your job

- Submit to as many eligible partitions as possible, for example: `-p mit_normal_gpu,mit_preemptable`.

- If your job can run on any type of GPU, request a generic GPU with `--gres=gpu:1`. To request a specific type, use `--gres=gpu:l40s:1` for an L40S or `--gres=gpu:h200:1` for an H200.

Typical cases that require H200s include:

- AI training with large models.
- Simulations that require FP64 precision.
- Any job that requires 48–144 GB of GPU memory.

- For multi-GPU jobs, verify that your code actually scales before requesting more GPUs — extra GPUs that aren't used will just delay scheduling without speeding up your job.



## Avoid unnecessary pending time

- Specify `--ntasks`, `--cpus-per-task`, and `--mem` (or `--mem-per-cpu`) explicitly rather than relying on defaults — defaults are rarely optimal for your workload.

- Request no more than 4 CPU cores per GPU when possible. Our Slurm configuration reserves 4 CPU cores per GPU for GPU jobs, so requesting more than that can delay scheduling.

    > **Note:** Many deep learning workloads need more than 4 CPU cores per GPU, since data loading and preprocessing (for example, PyTorch `DataLoader` workers) are CPU-bound and can otherwise starve the GPU. In that case, request 6–8 CPU cores per GPU as a good starting point, and increase only if you confirm the data pipeline is still the bottleneck. Keep in mind that nodes provide roughly 15–16 CPU cores per GPU, so stay below that limit to avoid being allocated extra GPUs and delaying scheduling.

- Request only as much memory as your program actually needs, since requesting more than necessary can delay scheduling. Note that `--mem` specifies the memory per node, so when scaling across nodes, prefer `--mem-per-cpu` over `--mem` so that memory scales with the CPU count.

- Set a realistic `--time` limit — just long enough to cover your job's expected run time. Shorter walltimes can backfill into scheduling gaps and start sooner.

- If your job does not specifically require an H200, prefer an L40S. The L40S is sufficient for many workloads (especially those using less than 48 GB of GPU memory) and is far more available, which usually means shorter queue times.

## Right-size your requests with feedback

After a job finishes, run `jobstats <jobid>` to see the actual CPU, memory, and GPU usage. Use that information to tune your next submission — over-requesting resources keeps your jobs in the queue longer and blocks others.