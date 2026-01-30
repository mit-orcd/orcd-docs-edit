# Storage Services

## Storage Rental

Additional project and lab storage can be rented on ORCD shared clusters by individual
PI groups. This storage is mounted on the cluster and access to the storage is managed 
by the group through [MIT Web Moira](https://groups.mit.edu/webmoira/) (see [Accessing Group Resources](accessing-group-resources.md) for details).

The options for storage are:

| Storage Type | Description | Encryption at Rest  | Backup  | Namespace |Notes | 
| ----------- | ----------- |----------- |----------- |----------- |----------- |
| Data | Frequent data access | Optional | No |  Limited | Day to day research storage, active projects, instrument data buffers, etc. |
| Compute | Very frequent data access | Optional | No | Limited | Very fast access, special needs, high IO |

Please note that all types of storage **are not backed up by default**.

Storage is charged at the start of each month. The first month is prorated by the number of days left in the current month. A purchase must be a minimum of 20 TiB and in increments of 20 TiB.

If you anticipate needing more than a few 100 TiB let us know when you request your storage. We may suggest purchasing a dedicated server for your lab.

For more information, including pricing, and to purchase storage please send an email to <orcd-help@mit.edu>. If you are purchasing storage please include the following in your request:

- The storage type (compute or data)
- Amount in TiB (20 TiB increments)
- Cost object
- The lab PI