Project Specific Filesystems
============================

Additional project and lab storage can be purchased on ORCD shared clusters by individual
PI groups. This storage is mounted on the cluster and access to the storage is managed 
by the group through MIT Web Moira, https://groups.mit.edu/webmoira/ (see below for details). 

Current pricing for storage is


   +------------------------+------------------+----------+--------------+
   | Storage Type           | Pricing          | Duration | Backup       |
   |                        |                  |          |              |
   +========================+==================+==========+==============+
   | NESE disk              | $2.50/month      | 12 month | No automated |
   |                        | 50TB minimum,    | minimum. | backup.      |
   |                        | 10TB increments. |          |              |
   +------------------------+------------------+----------+--------------+

Managing access using MIT Web Moira
-----------------------------------

Individual group storage is configured so that access is limited to a set
of accounts belonging to a web moira list that is defined for the group
store. The owner and administrators of group storage can manage
access by modifying the membership of the moira list by accessing the members 
list under https://groups.mit.edu/webmoira/list/. The name of the
list corresponds to the group name associated with the ORCD shared 
cluster storage.

Moira Web Interface Example
+++++++++++++++++++++++++++

The figure below shows a screenshot of the web moira management page at
https://groups.mit.edu/webmoira/list/cnh_research_computing for a hypothetical
storage group named _cnh_research_computing_. The intrface provides a 
self-service mechanism for controlling access to any storage belonging to
this group. MIT account ids can be added and 
removed as needed from this list by the storage access administrators as needed.

.. image:: moira-example.jpg
   :scale: 50%
   :alt: Screen shot of Moira interface
