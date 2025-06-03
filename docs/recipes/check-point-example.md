# Checkpoint Example with Job Array

It's quite common to have a large amount of files that need to be processed but are all processed by the same program. This is often referred to as "pleasantly parallel". Instead of running a job serially, processing one file at a time, we use the cluster and an array job to process many or all of the files or data at once using many cpus or gpus in parallel.

When running large-scale computations on engaging, especially using array jobs, checkpointing is a crucial technique to ensure fault tolerance and efficient resource usage.  

What is Checkpointing?

Checkpointing is the process of saving the state or progress of a running job at specific intervals. If the job is interrupted (e.g., due to time limits, system failures, or preemption), it can be resumed from the last saved point rather than starting over. 

Why Checkpoint?

You can avoid losing progress if a task is interrupted. Checkpointing can help you to make your job stay within time limits by breaking the work into smaller chunks. If the tasks are stopped due to time limits, the checkpointing process looks for or reads files created while running. When your job is restarted it picks up where it left off.  
 
How does it work?

Job Initialization: Each array task starts and checks for an existing checkpoint file (or some content in a file).
Periodic Saving: During execution, the task periodically writes its state (e.g., variables, progress markers, partial outputs) to a checkpoint file.
Restart Logic: If the job is resubmitted or restarted, it reads from the checkpoint file and resumes from the last saved point. A job can also restart by checking if a file exists. 

There are two common ways to do checkpointing, by the checking for the existence of a file or by checking the contents of a file. 

The following python examples are for illustration:

Example 1 - Checking to see if a filename exists to determine the restarting point after a job is interrupted or killed: 

```python
import os
import time

def checkpoint_by_file():
    for i in range(1, 11):
        checkpoint_file = f"step_{i}.done"
        if os.path.exists(checkpoint_file):
            print(f"Step {i} already completed. Skipping.")
            continue
        print(f"Running step {i}...")
        time.sleep(1)  # Simulate work
        with open(checkpoint_file, "w") as f:
            f.write("done")
        print(f"Step {i} completed and checkpointed.")

checkpoint_by_file()

```

Example 2 - Checking the contents of a file exist to determine the restarting point after a job is interrupted: 

```python
import os
import time

def checkpoint_by_content():
    checkpoint_file = "checkpoint.txt"
    last_completed = 0

    if os.path.exists(checkpoint_file):
        with open(checkpoint_file, "r") as f:
            last_completed = int(f.read().strip())

    for i in range(last_completed + 1, 11):
        print(f"Running step {i}...")
        time.sleep(1)  # Simulate work
        with open(checkpoint_file, "w") as f:
            f.write(str(i))
        print(f"Step {i} completed and checkpoint saved.")

checkpoint_by_content()
```