# ORCD Engaging System

ORCD primarily operates and provides support and training for the Engaging system, which is available to all researchers. Engaging runs with a Slurm scheduler and has a web portal for interactive computing.

## Maintenance Schedule

The maintenance schedule for Engaging is:

- Monthly maintenance on the 3rd Tuesday of the month lasting about a day.
- Weekly restarts of login nodes Monday mornings starting at 7am for about 15 minutes. If Monday is a holiday this restart will occur on Tuesday.

## System description

The Engaging is the ORCD HPC resource and is a mixed CPU and GPU computing cluster that is openly available to all research projects at MIT. It has around 50,000 x86 CPU cores and over 1000 GPU cards including A100, RTX6000, L40S, H100, and H200 GPUs. New, modern hardware is consistently being added to the Engaging cluster. Engaging offers fast flash based storage for each user's scratch space. Hardware access is through the Slurm  resource scheduler that supports batch and interactive workloads and allows dedicated reservations. The cluster has a large shared file system for working datasets. Additional compute and storage resources can be purchased by PIs. A wide range of standard software is available and the Docker compatible Apptainer container tool is supported. User-level tools like Miniforge for Python, R libraries, and Julia packages are all supported. A range of PI group maintained custom software stacks are also available through the widely adopted environment modules toolkit. A standard, open-source, web-based portal supporting Jupyter notebooks, RStudio, and XFCE graphical desktop is available at [https://orcd-ood.mit.edu](https://orcd-ood.mit.edu). Further information and support is available from <orcd-help-engaging@mit.edu>.

## How to Get an Account on Engaging

Accounts on the engaging cluster are connected to your main MIT institutional Kerberos ID. 
Connecting to the cluster for the first time through its [web portal](https://orcd-ood.mit.edu) automatically activates an account with basic access to resources. See [this page](accessing-orcd/ondemand-login.md) for instructions on how to log in.

## Engaging Quick Links

- OnDemand web portal: [https://orcd-ood.mit.edu](https://orcd-ood.mit.edu)
- Help: Send email to <orcd-help-engaging@mit.edu>

