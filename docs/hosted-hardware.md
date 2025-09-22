---
tags:
  - Maintenance Schedule
---

# Hardware Purchases 

There are often cases where the [public partitions](running-jobs/overview.md#partitions) (`mit_preemptable`, `mit_normal` and `mit_normal_gpu`) are not sufficient for a lab's computational needs. 
In these cases we often recommend a hardware purchase to be hosted on Engaging. 

Our recommendations are generally vendor agnostic. However, specific vendors give us very compelling pricing based 
on negotiated volume discounts. To keep maintenance costs lower, we strive to standardize on hardware that 
is easily installed into Engaging. This allows our operations team to manage far more hardware, more efficiently, than a cluster with heterogenous hardware. There are some variations of hardware for special edge cases, but they are exceedingly rare. 

ORCD staff maintains relationships with multiple hardware vendors and is consistently negotiating for better pricing that is generally not available to lower volume customers. 

### Process
We prefer to meet with the group and learn about the type of work that is being done on the nodes and make recommendations. 
Next, we ask the group to provide a budget and a timeframe. We use this information to
work with our vendors to get quotes. Once the quotes have been agreed on, we forward them to the lab's administrator for purchase. For tracking purposes, the administrator forwards us the purchase order number once the order has been placed. On arrival to MGHPCC in Holyoke, hardware is carefully checked and installed in the racks. Operating system and networking and monitoring are installed and tested by the ORCD operations staff. Once completed, the Research Computing Support team runs a series of tests to confirm all is working as expected and then the hardware is released for use. 

### Maintenance
Once your hardware is in place, our staff will take care of all maintenance of the operating system, patches, security, access to the network,  and access to the shared storage resources. Our operations staff will coordinate any hardware repairs with the vendor and will work with the vendor to make repairs as appropriate with the warranty. A five year warranty is required. These nodes would be part of the regular [monthly maintenance](orcd-systems.md#maintenance-schedule).

### Slurm Partitions 
Scientists may specify the configuration of their partitions within reason. Generally the partition time limit is constrained only by the engaging maintenance schedule, which is one day per month (the third Tuesday of each month). All machines are required to be in the mit_preemtable queue, which allows them to be used by non owners when the hardware is idle. We generally start with a standard popular slurm partition configuration and then work with the lab to modify as needed. 

Once the nodes have been tested, they are released for use. You may grant users access via MIT Moira. Your new nodes will have access controlled by your user group. To give users access to your nodes, the corresponding usergroup must be modified. For example: 

orcd_ug_pi_"MIT kerberos of the pi"_all

You can make the additions here on the [WebMoira page](https://groups.mit.edu/webmoira/).

### Testing and burn in
ORCD staff maintains several testing suites to confirm that nodes are working as expected. We run these tests on all new hardware to confirm there are no problems before releasing the hardware for general use.

### Retirement
Hardware is retired after 5 years when the warranty period is over. The nodes are removed from the racks
and recycled responsibly. 
