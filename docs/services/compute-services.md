# Compute Services

Researchers can upgrade their [base-level](../running-jobs/overview.md#partitions) computing service for a per-account monthly account maintenance fee to get:

- Higher priority access to available compute resources
- Higher compute resource limits
- Longer job times
- Access to advance rentals

The current resources limits that come with a Standard and Advanced account levels are:

| Type | CPU Cores | GPUs  | Memory | Time Limit (CPU) | Time Limit (GPU) |  Priority |
| ----------- | ----------- |----------- |----------- |----------- |----------- |----------- |
| Standard | 256 | 2 | 1024 GB | 2 days | 1 day | Medium |
| Advanced | 512 | 4 | 2048 GB | 4 days | 2 days | Higher |

These allocations apply to the `mit_normal` and `mit_normal_gpu` [partitions](../running-jobs/overview.md#partitions). The "CPU Cores" and "Time Limit (CPU)" columns apply to the `mit_normal` partition, and the "GPUs" and "Time Limit (GPU)" columns apply to the `mit_normal_gpu` partition.

Once your account has been upgraded you will be provided a QOS string that you will need to add to your job flags to use your new allocations.

The charge for each can be found on the main ORCD site [Storage and Compute Services](https://orcd.mit.edu/resources/storage-and-compute-services) page.

For any questions or to upgrade your account please reach out to us at <orcd-help@mit.edu>.

## Advance Rentals

Advance rentals, available to those with a Standard or Advanced account level, provide researchers guaranteed time slots for specific compute equipment (subject to availability and request lead time). We do this through reservations in Slurm.

The charge can be found on the main ORCD site [Storage and Compute Services](https://orcd.mit.edu/resources/storage-and-compute-services) page.

Be sure to test your code thoroughly before setting up a reservation. Reservations cannot be changed or canceled 24 hours after they've been created. You should be completely ready to run your application once your reservation starts.

When your reservation is set up we will provide additional job flags that you will need to use to run jobs during your reservation.

For any questions or to request an advanced rental reservation please reach out to us at <orcd-help@mit.edu>.