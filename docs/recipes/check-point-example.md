---
tags:
 - Checkpointing
 - Job Arrays
 - Howto Recipes
---

# Checkpointing with Job Arrays

It's quite common to have a large number of files that need to be processed by the same program. Instead of running a job serially — processing one file at a time — you can use a job array to process many files in parallel across multiple CPUs or GPUs. This is often referred to as "pleasantly parallel."

When running large-scale computations on Engaging, especially using job arrays, checkpointing is a crucial technique to ensure that work is not lost if a job is interrupted.

## What is Checkpointing?

Checkpointing is the process of saving the progress of a running job at specific intervals. If a job is interrupted — due to a time limit, system failure, or preemption on the `mit_preemptable` partition — it can be resumed from the last saved point rather than starting over.

## Why Checkpoint?

- Avoid losing progress if a job is interrupted or preempted
- Stay within job time limits by breaking work into smaller chunks that can be resumed
- Make jobs more resilient on the `mit_preemptable` partition, where jobs can be stopped at any time

## How Does it Work?

1. **Job Initialization:** Each array task starts and checks for an existing checkpoint file.
2. **Periodic Saving:** During execution, the task periodically writes its progress to a checkpoint file.
3. **Restart Logic:** If the job is resubmitted or restarted, it reads the checkpoint file and resumes from where it left off.

There are two common approaches: checking whether a checkpoint file **exists**, or checking the **contents** of a checkpoint file.

!!! tip
    As a best practice, write checkpoint files to your pool or scratch storage rather than your home directory. These storage areas are better suited for frequent writes during a running job. See the [Filesystems](../filesystems-file-transfer/filesystems.md) page for more information.

## Example Slurm Script

The following script submits a job array where each task runs a Python script that uses checkpointing:

```bash
#!/bin/bash
#SBATCH --job-name=checkpoint_example
#SBATCH --output=logs/job_%A_%a.out
#SBATCH --array=1-10
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

module load miniforge

# Replace checkpoint_example.py with the name of your Python script
python checkpoint_example.py --task $SLURM_ARRAY_TASK_ID
```

## Examples

The examples below are shown in both Python and Bash. Use whichever fits your workflow.

## Python Examples

### Example 1: Checkpoint by File Existence

Each step creates a `.done` file when complete. On restart, completed steps are skipped.

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

### Example 2: Checkpoint by File Contents

A single checkpoint file tracks the last completed step. On restart, the job reads this file and picks up from the next step.

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

## Bash Examples

### Example 1: Checkpoint by Output File Existence

Before processing each input file, check whether the output file already exists. If it does, skip it. This is a common pattern when processing many input files in a job array.

```bash
#!/bin/bash

INPUT_FILE="input_${SLURM_ARRAY_TASK_ID}.dat"
OUTPUT_FILE="output_${SLURM_ARRAY_TASK_ID}.dat"

if [ -f "$OUTPUT_FILE" ]; then
    echo "Output already exists for task ${SLURM_ARRAY_TASK_ID}. Skipping."
    exit 0
fi

echo "Processing ${INPUT_FILE}..."
# Replace the line below with your actual processing command
cp "$INPUT_FILE" "$OUTPUT_FILE"
echo "Task ${SLURM_ARRAY_TASK_ID} complete."
```

### Example 2: Checkpoint by Progress Log File

A log file tracks the last completed step number. On restart, the script reads the log and resumes from the next step.

```bash
#!/bin/bash

CHECKPOINT_FILE="checkpoint.txt"
LAST_STEP=0

if [ -f "$CHECKPOINT_FILE" ]; then
    LAST_STEP=$(cat "$CHECKPOINT_FILE")
    echo "Resuming from step $LAST_STEP"
fi

for i in $(seq $((LAST_STEP + 1)) 10); do
    echo "Running step $i..."
    sleep 1  # Replace with your actual work
    echo "$i" > "$CHECKPOINT_FILE"
    echo "Step $i complete."
done
```

### Example 3: Checkpoint with Slurm `--requeue`

On Engaging, requeue is enabled by default — jobs that are preempted will automatically be resubmitted without any extra flags. However, you can include `--requeue` explicitly in your script to make this behavior clear. Combined with checkpoint logic, the job will pick up where it left off when it restarts.

```bash
#!/bin/bash
#SBATCH --job-name=checkpoint_requeue
#SBATCH --output=logs/job_%A_%a.out
#SBATCH --array=1-10
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --requeue

CHECKPOINT_FILE="checkpoint_${SLURM_ARRAY_TASK_ID}.txt"
LAST_STEP=0

if [ -f "$CHECKPOINT_FILE" ]; then
    LAST_STEP=$(cat "$CHECKPOINT_FILE")
    echo "Resuming task ${SLURM_ARRAY_TASK_ID} from step $LAST_STEP"
fi

for i in $(seq $((LAST_STEP + 1)) 10); do
    echo "Running step $i..."
    sleep 1  # Replace with your actual work
    echo "$i" > "$CHECKPOINT_FILE"
    echo "Step $i complete."
done
```

!!! note
    `--requeue` is especially useful when running jobs on the `mit_preemptable` partition, where jobs can be stopped at any time when the node owner submits a job. See [Running Jobs](../running-jobs/overview.md) for more information on partitions.
