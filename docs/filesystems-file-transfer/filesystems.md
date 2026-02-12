# General Use Filesystems

Everyone on Engaging gets three spaces to store files: home, pool, and scratch. Each of these have a different purpose, size, and characteristics.

- **Home**: Your Home Directory is meant for your most important files, as it is backed up with snapshots. We recommend keeping your software and code in your home directory. Home is located on fast flash storage.
- **Pool**: Pool is a larger space meant as a staging area for larger datasets. It is a place to keep files that still need to be on Engaging, but aren't currently being used for computation. Pool is located on disk storage. Pool is **not backed up**.
- **Scratch**: Scratch space is meant for data used in actively running jobs. It will be faster to access Scratch during your job for the majority of workloads, but it is **not backed up** and should not be used for long term storage.

Both Pool and Scratch are **not backed up**. Any files that cannot be easily replaced should either be stored in Home, or backed up outside of Engaging. PIs can request an additional 5TB of shared Pool storage for their lab (see [below](#pi-shared-group-storage)) and [additional storage can be purchased](../services/storage-services.md).

See the table below for a description of each storage space.

| Storage Type      | <div style="width:18em">Path</div> | Quota | Backed up | Purpose/Notes |
| ----------- | ----------- |----------- |----------- |----------- |
| Home Directory <br> Flash  | `/home/<username>` | 200 GB | Backed up with snapshots | Use for important files and software |
| Pool <br> Hard Disk | `/home/<username>/orcd/pool` | 1 TB | **Not backed up** | Storing larger datasets |
| PI Shared Pool <br> Hard Disk | `/orcd/pool/<number>/<pikerb>_shared` | 5 TB | **Not backed up** | Storing larger datasets, shared group storage |
| Scratch <br> Flash | `/home/<username>/orcd/scratch` | 1 TB | **Not backed up** | Scratch space for I/O heavy jobs |

!!! warning  "Scratch and Pool are Not Backed Up"
    Scratch is meant for temporary storage while running compute jobs. It is not meant for long term storage and **is not backed up**. **If you have not logged in for 6 months files in scratch will be deleted**. Any files that you would like to keep long-term should be copied onto another storage location with backup.
    
    Pool, while meant for longer-term storage than Scratch, is also not backed up.

## PI Shared Group Storage

PIs can request 5TB of additional pool that can be shared with their group. We will set up a [Moira list](../services/accessing-group-resources.md) so PIs and their designated group admins can control access to the shared storage. To request a shared pool space send an email to <orcd-help-engaging@mit.edu>.

If your group needs more than 5TB of storage, or needs additional storage for a specific project, you can [rent storage](../services/storage-services.md) from ORCD.