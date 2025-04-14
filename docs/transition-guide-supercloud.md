# SuperCloud to Engaging Transition Guide

Updates to SuperCloud's access policies mean that starting May 1 access to SuperCloud will be limited to Lincoln Laboratory collaborators. As ORCD expands Engaging we welcome any MIT researchers who are not Lincoln collaborators and are looking for a place to run their computational workloads. The ORCD team is here to help make that transition as smooth as possible.

This page is maintained to answer questions and document how to migrate to ORCD's Engaging system. We will continue to update this page with answers to more questions and documentation.

## Frequently Asked Questions

### What are my options?

There are other computing options available to the MIT community. ORCD runs the Engaging system which has both resources available to the entire MIT community and resources purchased by individual PIs and DLCs made available to their researchers.

Some DLCIs maintain their own set of resources. See [this page](https://orcd.mit.edu/resources/dlci-shared-hardware) for a list.

### What is the timeline?

- Through April 30: All SuperCloud users can run jobs
- Starting May 1: Running jobs limited to Lincoln Collaborators
- Through May 31: Non-collaborators may continue to access SuperCloud for data migration
- June 1: SuperCloud access limited to Lincoln Collaborators

### How do I migrate to another system?

There are three main steps or milestones for moving to a new system. These will be similar to the steps you take when getting a new account on any system.

- Transfer data: Identify what data you need to keep and transfer it to the new system. We will provide documentation on this page in the near future for recommended ways to transfer large amounts of data.
- Build any missing software: Check the software stack of the new system and see what you may need to rebuild or request. Engaging maintains a software stack through modules that includes many of the software packages provided on SuperCloud. Names may be different, so run `module avail` to check for differences.
- Run jobs: Run small tests before running larger production jobs. Both SuperCloud and Engaging use Slurm, but Engaging does not have the `LL` commands such as `LLsub`, `LLfree`, and `LLstat`. Some `sbatch` flags may differ between the two systems as well. We will provide documentation on this page in the near future for the Engaging equivalent for common SuperCloud job workflows. You can also consult the section on Running Jobs in this documentation.

### Where can I get help?

The ORCD team can help with migrating data and workloads to Engaging. ORCD has regular office hours (see the [Office Hours Schedule](https://orcd.mit.edu/news-and-events/office-hours)). You can also request help through <orcd-help@mit.edu>.

### How can I get an account on Engaging?

It is fairly quick and simple to create your account Engaging. Accounts on the engaging cluster are connected to your MIT institutional kerberos id. To get an account log into the [Engaging OnDemand Web Portal](https://engaging-ood.mit.edu). Connecting to Engaging OnDemand for the first time automatically activates an account with basic access to resources. See [this page](accessing-orcd/ondemand-login.md) for instructions on how to log in. After you log in wait a few minutes for your account setup to complete before starting to run jobs.

### How do I know whether I have a Lincoln Collaboration?

The SuperCloud documentation on [Requesting an Account](https://mit-supercloud.github.io/supercloud-docs/requesting-account/) describes the ways to demonstration a Lincoln collaboration.

### If I have Lincoln Collaboration how do I update my account to reflect my collaboration?

Check your [User Profile page](https://txe1-portal.mit.edu/profile/user_profile.php) on the SuperCloud Web portal. The "Lincoln Laboratory Collaboration" section is in the column on the right and should list any collaborations you or your advisor/PI might have. If any collaborations are missing you can follow the instructions at the top of the page to update your information. Please indicate your collaborator status before May 1 to avoid account deactivation.

## Differences Between SuperCloud and Engaging

SuperCloud and Engaging are both shared HPC systems that use Slurm. Their high-level architecture is the same, both have login nodes and compute nodes connected by a network filesystems that can be accessed from each node. However, there are differences in the systems, practices, and policies between the two. This section describes some of those differences that are most helpful to know.

- Engaging maintenance is on the **3rd Tuesday** of each month
- Groups on Engaging are managed through Moira, so once groups are created the group admins can add or remove people themselves
- Engaging can be accessed both inside and outside the United States
- Compute nodes on Engaging can access the internet
- Engaging uses an OnDemand Web Portal that provides similar functionality to the SuperCloud Web Portal

### Running Jobs

- Nodes on Engaging are not exclusive by user, one node can have multiple users running jobs.
- Engaging partitions have a different naming convention and can have multiple different types of nodes. You must specify a partition when you launch jobs. See the [Partitions section](running-jobs/overview.md#partitions) for more information.
- The wrapper commands that start with `LL` are not available on Engaging, however the Slurm commands (start with `s`, such as `sbtach`) behave similarly. See the [Running Jobs Overview page ](running-jobs/overview.md) and the [Requesting Resources page](running-jobs/requesting-resources.md).

### Storage

- While each user on SuperCloud gets a home directory, on Engaging each user gets three spaces: home, pool, and scratch. Quotas on Engaging are also smaller than on SuperCloud. See [General Use Filesystems](filesystems-file-transfer/filesystems.md) for a description of each, what they are meant for, and their quotas.
- Each PI can request 5TB of shared group storage on Engaging.
- Additional storage space can be rented. See [Project Specific Filesystems](filesystems-file-transfer/project-filesystems.md) for more information and email <orcd-help@mit.edu> if you are interested in purchasing storage for your group.



