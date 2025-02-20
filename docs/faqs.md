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

We reccomend using Conda to manage R packages. Please refer to the
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

For partitions owned by labs, please email <orcd-help-engaging@mit.edu>.
