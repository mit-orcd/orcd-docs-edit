# Licensed Software

It is possible to use licensed software on Engaging. The overall steps are:

1. Obtain a license
2. Host or install the license
3. Install the software

## Step 1: Obtain a License

You may first want to check whether MIT, your department, or your group already has a license. MIT IS&T maintains site licenses for some commonly used software, which are listed on their [software grid page](https://ist.mit.edu/software-hardware). Some departments have similar services.

If you, your group, department, or MIT don't already have a license you will need to reach out to the company that owns the software to purchase one. ORCD does not purchase licenses for research software.

Once you get a license make sure you are aware of any requirements or restrictions for the license. Some have stricter requirements than others.

## Step 2: Host or Install the License

Some licenses consist of a single file, those are the simplest to install. You will need to put the license file on the cluster. Once you install your software there is usually a way to let the software know where your license file is, often through an environment variable.

For a network license you will need to have that license hosted on a server through a license manager. We recommend reaching out to IS&T and asking for either a [Managed Server](https://ist.mit.edu/managed-servers) or DLCI Server. They can work with you to set up the license manager and install the license. ORCD does not set up and maintain license servers for research software.

## Step 3: Install your Software

Install your licensed software following the install instructions. If you are the only one using the software you can install it in your home directory, or install it in a directory shared by your group. **Do not place licensed software or license files in world-readable directories.**

!!! warning "Licensed software should not be world readable"
    Do not place licensed software or license files in world-readable directories. Place the software in a directory only accessible by individuals covered by the license. If you need help creating a group space for sharing software reach out to <orcd-help@mit.edu> and we can help.

Licensed software can sometimes be tricky to install. We have recipes for some software available on these documentation pages, the quickest way to find them is to search for the software name in the search box in the top right corder, or check the [`#Install Recipes`](../tags.md#install-recipe) tag on the [Index](../tags.md) page. If you need any help reach out to <orcd-help@mit.edu>.
