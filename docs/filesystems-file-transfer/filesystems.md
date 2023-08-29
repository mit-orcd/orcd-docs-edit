# General Use Filesystems

Large HPC systems often have different filesystems for different purposes. ORCD systems are no different, and each have their own approach. This page documents these.

## SuperCloud

SuperCloud uses Lustre for all central/shared storage (accessible to all nodes in the system). This storage is not backed up. See the SuperCloud [Best Practices and Performance Tips](https://supercloud.mit.edu/best-practices-and-performance-tips) page for best practices using the Lustre filesystem. Quotas or limits are set on the storage as guardrails. Additional storage may be granted on a case by case basis. Local disk spaces will be faster than the Lustre shared filesystem, but all are temporary and can only be accessed on the node where they are created.

| Storage Type      | Path | Access | Backed up | Limits |
| ----------- | ----------- |----------- |----------- |----------- |
| Home Directory <br> Lustre  | `/home/gridsan/<username>` | User only | Not backed up | See [User Profile Page](https://txe1-portal.mit.edu/profile/user_profile.php) |
| Group Directories <br> Lustre | `/home/gridsan/groups/<groupname>` | Files shared within a group | Not backed up | See [User Profile Page](https://txe1-portal.mit.edu/profile/user_profile.php) |
| Job-specific Temporary Storage <br> Local Disk | Access using the `$TMPDIR` environment variable | User or Group | Not backed up <br>  Temporary directory created at the start of a job and cleaned up at the end of the job | NA |
| Local Disk Space | Create the directory `/state/partition1/user/$USER` as needed | User or Group | Not backed up <br> Cleaned up monthly during downtimes | NA |

## Engaging

Users each get a small home directory that is backed up and meant for important files. Larger scratch space is not backed up. [Additional storage can be purchased](project-filesystems.md). The Lustre scratch space will be faster than NFS for the majority of workloads, however having large numbers of small files will make it slower than NFS and can slow down the filesystem overall, so it is important to follow the [Lustre Best Practices](https://engaging-web.mit.edu/eofe-wiki/best_practices/lustre/). See the [Engaging Documentation Page on Storage](https://engaging-web.mit.edu/eofe-wiki/storage/) for more information.

| Storage Type      | Path | Quota | Backed up | Purpose/Notes |
| ----------- | ----------- |----------- |----------- |----------- |
| Home Directory <br> NFS  | `/home/<username>` | 100 GB | Backed up | Use for important files |
| Lustre | `/nobackup1/<username>` | 1 TB | Not backed up | Scratch space <br> Faster than NFS |
| NFS | `/pool001/<username>` | 1 TB | Not backed up | Scratch space |

## Satori

| Storage Type      | Path | Quota | Backed up | Purpose/Notes |
| ----------- | ----------- |----------- |----------- |----------- |
| Home Directory | `/home/<username>` | FILL IN | FILL IN | FILL IN |

## OpenMind

OpenMind provides a number of different storage options. See the [OpenMind Documentation page on Storage](https://github.mit.edu/MGHPCC/OpenMind/wiki/Which-directory-should-I-use%3F) for more information, best practices, and recommendations.

| Storage Type      | Path | Quota | Backed up | Purpose/Notes |
| ----------- | ----------- |----------- |----------- |----------- |
| Home Directory | `/home/<username>` | 5 GB | Backed up | Use for very important files |
| Weka |  `/om/user/<username>` (individual users) and `/om/<groupname>` (groups) | ?? | ?? | Fast internal storage |
| Weka Scratch | `/om/scratch/<week-day>` | ?? | Not backed up <br> purged 3 weeks after creation | Scratch space |
| Vast | `/om2/user/<username>` (individual users) and `/om2/<groupname>` (groups) | ?? | ?? | Fast internal storage |
| Vast Scratch | `/om2/scratch/<week-day>` | ?? | Not backed up <br> purged 3 weeks after creation | Scratch space |
| Lustre | `/nobackup1/` | ?? | Not backed up | Fast internal storage |
| Lustre Scratch | `/nobackup/scratch/<week-day>` | ?? | Not backed up <br> purged 3 weeks after creation | Scratch space <br>  See [Lustre Best Practices](https://www.nas.nasa.gov/hecc/support/kb/lustre-best-practices_226.html) page |
| NFS | `/om3`, `/om4`, `/om5` | ?? | ?? | Slow, internal long-term storage |
| NESE | `/nese` | ?? | ?? | Slow, internal long-term storage |
