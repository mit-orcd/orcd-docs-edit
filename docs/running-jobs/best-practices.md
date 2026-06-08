# Best Practices for Requesting Resources

The following recommendations will help your jobs start sooner and avoid spending unnecessary time in the queue.

## Maximize the resources available to your job

(1) Submit to as many eligible partitions as possible, for example: `-p mit_normal_gpu,mit_preemptable`.

(2) If your job can run on any type of GPU, request a generic GPU with `--gres=gpu:1`. To request a specific type, use `--gres=gpu:l40s:1` for an L40S or `--gres=gpu:h200:1` for an H200.

Typical cases that require H200s include:

- AI training with large models.
- Simulations that require FP64 precision.
- Any job that needs more than 48 GB of GPU memory.

(3) For multi-GPU jobs, verify that your code actually scales before requesting more GPUs — extra GPUs that aren't used will just delay scheduling without speeding up your job.



## Avoid unnecessary pending time

(1) Request no more than 4 CPU cores per GPU when possible. Our Slurm configuration reserves 4 CPU cores per GPU for GPU jobs, so requesting more than that can delay scheduling.

(2) Request only as much memory as your program actually needs. When scaling across nodes, prefer `--mem-per-cpu` over `--mem` so memory scales with the CPU count.

(3) Set a realistic `--time` limit. Shorter walltimes can backfill into scheduling gaps and start sooner.

(4) Specify `--ntasks`, `--cpus-per-task`, and `--mem` (or `--mem-per-cpu`) explicitly rather than relying on defaults — defaults are rarely optimal for your workload.

(5) If your job does not specifically require an H200, prefer an L40S. The L40S is sufficient for many workloads (especially those using less than 40 GB of GPU memory) and is far more available, which usually means shorter queue times.

## Right-size your requests with feedback

After a job finishes, run `seff <jobid>` to see the actual CPU and memory usage. Use that information to tune your next submission — over-requesting resources keeps your jobs in the queue longer and blocks others.