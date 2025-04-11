# SuperCloud to Engaging Transition Guide

Updates to SuperCloud's access policies mean that starting May 1 access to SuperCloud will be limited to Lincoln Laboratory collaborators. As ORCD expands Engaging we welcome any MIT researchers who are not Lincoln collaborators and are looking for a place to run their computational workloads. The ORCD team is here to help make that transition as smooth as possible.

This page is maintained to answer questions and document how to migrate to ORCD's Engaging system. We will continue to update this page with answers to more questions and documentation.

## Frequently Asked Questions

### What are my options?

There are other computing options available to the MIT community. ORCD runs the Engaging system which has both resources available to the entire MIT community and resources purchased by individual PIs and DLCs made available to their researchers.

Dome DLCIs maintain their own set of resources. See [this page](https://orcd.mit.edu/resources/dlci-shared-hardware) for a list.

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
