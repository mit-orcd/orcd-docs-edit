# Checkpoint Example with Job Array

It's quite common to have a large amount of files that need to be processed but are all processed by the same program. This is often referred to as "pleasantly parallel". Instead of running a job serially, processing one file at a time, we use the cluster and an array job to process many or all of the files or data at once using many cpus or gpus in parallel.

When running large-scale computations on engaging, especially using array jobs, checkpointing is a crucial technique to ensure fault tolerance and efficient resource usage.  

What is Checkpointing?

Checkpointing is the process of saving the state of a running job at specific intervals. If the job is interrupted (e.g., due to time limits, system failures, or preemption), it can be resumed from the last saved state rather than starting over.

Why Checkpoint?

Engaging is a shared resource, in order to maintain a level of fairness, you will notice that partitions you use may have shorter length maximum time values than you require. For example, mit_normal has a 12 hour maximum time for a job. Sometimes your jobs may need a longer period of time to complete. Checkpointing can help if your job gets killed by running over the maximum time allowed for a partition. 

How does it work?

Job Initialization: Each array task starts and checks for an existing checkpoint file.
Periodic Saving: During execution, the task periodically writes its state (e.g., variables, progress markers, partial outputs) to a checkpoint file.
Restart Logic: If the job is resubmitted or restarted, it reads from the checkpoint file and resumes from the last saved point.

