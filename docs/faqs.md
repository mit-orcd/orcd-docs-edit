# Frequently Asked Questions

**How do I get GPU access?**

Currently we have many public GPUs available to the MIT community on Satori and
we are working on getting more on Engaging. You can request GPUs for your job
by following [this documentation](running-jobs/requesting-resources.md#gpus).

If your lab would like to purchase GPUs to be hosted on Engaging, please contact
<orcd-help-engaging@mit.edu>.

**How do I check the status of my job?**

Instructions for checking job status can be found
[here](running-jobs/overview.md#checking-job-status).

**How can I submit a module request?**

We are open to creating new modules for the Engaging cluster. You can submit all
module requests to <orcd-help-engaging@mit.edu>.

**I am unable to install a package in R. How can I debug the issue?**

We recommend using Conda to manage R packages. Please refer to the
[R user guide](software/R.md).

**Can I use export controlled software on the cluster?**

Export controlled software has specific requirements around who is allowed to
access the software. Often, our clusters do not meet these requirements, so
we generally do not allow this software to be on our systems. Please refer to
the terms of use of the software and direct any questions to
<orcd-help@mit.edu>.

**Can you increase the time limit for my job?**

For public partitions on Engaging, such as `mit_normal`, we cannot increase the
time limit for any particular job, as these resources are shared. For jobs that
need to run longer than the time limit on the partition, we encourage
checkpointing, which is a way of periodically saving progress so that subsequent
jobs can pick up where another job left off. The implementation of checkpointing
is domain specific and can vary greatly. You can find more information on
checkpointing [here](https://rc-docs.northeastern.edu/en/latest/best-practices/checkpointing.html).

For partitions owned by other groups, please email <orcd-help-engaging@mit.edu>.

**How do I get an account?**

=== "Engaging"
    If you have an MIT Kerberos account, then you can get an account on
    Engaging. To register, navigate to the [Engaging OnDemand Portal](https://engaging-ood.mit.edu/)
    and log in.

=== "Satori"
    If you have an MIT Kerberos account, then you can get an account on Satori.
    To register, navigate to the [Satori Portal](https://satori-portal.mit.edu/)
    and log in.

=== "SuperCloud"
    Access to SuperCloud is more restrictive and the account generation process
    is more involved. For more information, see the
    [SuperCloud documentation](https://mit-supercloud.github.io/supercloud-docs/requesting-account/).

**How do I install a Python package?**

See our documentation on [Python](software/python.md).

**Why won't my application run on a different partition?**

On Engaging, the older nodes (such as the `sched_mit_hill` and `newnodes`
partitions) run on CentOS 7 while the newer nodes (such as `mit_normal` and
`mit_preemptable`) run on the Rocky 8 operating system (OS). Each set of nodes
has a different set of modules, so if you have set up software to run on one OS,
it will probably not work on the other OS.
