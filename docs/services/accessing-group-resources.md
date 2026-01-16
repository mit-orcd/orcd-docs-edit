# Accessing Group Resources with MIT Web Moira

Individual group storage and hardware resources are configured so that access is limited to a set
of accounts belonging to a Moira list that is defined for the group
storage. The owner and administrators of group storage can manage
access themselves by modifying the membership of an associated moira list
under **https://groups.mit.edu/webmoira/list/[list_name]**. The name of the
list corresponds to a UNIX group name associated with your group's resources on Engaging. The naming scheme we use means this list name won't exactly match the UNIX group name you see on the system, but it will be similar.

If you are an admin of an ORCD group you will see that group listed under "Lists I Can Administer" when you log into [Web Moira](https://groups.mit.edu/webmoira/). Any ORCD groups will start with "orcd_ug" and will contain the Kerberos ID of the PI, or a short name for your DLCI or project. Click on the group name to go to the group management page. We will also send you a direct link to your group management page when we create your group.

## Moira Web Interface Example

The figure below shows a screenshot of the web moira management page at
**https://groups.mit.edu/webmoira/list/cnh_research_computing** for a hypothetical
storage group named ``cnh_research_computing``. The interface provides a 
self-service mechanism for controlling access to any storage belonging to
this group. MIT account IDs can be added and 
removed as needed from this list by the storage access administrators.

![Screen shot of Moira interface](moira-example.jpg)