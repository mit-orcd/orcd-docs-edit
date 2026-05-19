# Best Practices for Requesting Resources


Here is the best practice for submitting jobs.

Try the following to make your jobs run on as many resources as possible.

(1) Submit jobs to all possible partitions -p ou_bcs_low,ou_bcs_normal and -p mit_normal_gpu,mit_preemptable.

(2) If your jobs can run on any type of GPUs, use this flag --gres=gpu:1 for the BCS partitions, then the job will run on H100 or A100. For the MIT partitions, use --gres=gpu:1 or --gres=gpu:l40s:1 for L40S, --gres=gpu:h100:1 for H100s, or --gres=gpu:h200:1 for H200s.

Try the following to avoid being pending unnecessarily.

(1) Request no more than 4 CPU cores per GPU when possible. There are 4 CPU cores reserved per GPU for GPU jobs in our Slurm configuration.

(2) Request as little memory as possible, just enough for your program.

(3) Usually, only jobs with large AI models need H100s. If your jobs do not have to run on H100s, try to use A100s instead. A100 is sufficient for many jobs and is much more available.


