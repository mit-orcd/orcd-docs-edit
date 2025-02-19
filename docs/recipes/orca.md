# Installing ORCA for Personal Use

ORCA is a licensed software that is free for academic use, but it cannot be
transferred to third parties (per the ORCA EULA). So, we cannot install newer
versions system-wide. Users must create an account and install it personally.
Here are the steps to do so:

1. Navigate to the [ORCA website](https://orcaforum.kofo.mpg.de/app.php/portal)
2. Register for an account and login
3. Click "Downloads" in the top bar

![ORCA top bar](../images/orca/orca_top_bar.png)

4. Select the version of ORCA you want

![ORCA versions](../images/orca/orca_versions.png)

5. Select the "Linux, x86-64, .tar.xz Archive” version

![ORCA installs](../images/orca/orca_installs.png)

6. Click "Download"

![ORCA download](../images/orca/orca_download.png)

7. Upload the `.tar.xz` file to Engaging using `scp`:

```bash
scp /path/to/orca_6_0_1_linux_x86-64_shared_openmpi416.tar.xz $USER@orcd-login001.mit.edu ~/
```

8. On Engaging, extract the `tar.xz` file:

```bash
tar -xf orca_6_0_1_linux_x86-64_shared_openmpi416.tar.xz
```

9. Add this version of ORCA to your path:

```bash
export PATH=/path/to/orca_6_0_1_linux_x86-64_shared_openmpi416:$PATH
```
