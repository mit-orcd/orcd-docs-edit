# How to Create Modules

In an HPC context, a [module](../software/modules.md) is simply a file that can be used to set up your [environment](../glossary.md#environment) for a particular workflow. The ORCD administration team uses modules to make commonly-used software available to Engaging users, but they can be used for personally-installed software as well. This document explains how to leverage modules to streamline environment setup and configuration.

## Modulefile Basics

To understand how modulefiles are structured, let's look at an existing module that ORCD has set up for Julia 1.12.6:

```bash
[secorey@login008 ~]$ module show julia/1.12.6
-----------------------------------------------------------------------------
   /orcd/software/core/001/modulefiles/julia/1.12.6.lua:
-----------------------------------------------------------------------------
whatis("Name : Julia")
whatis("Version : 1.12.6")
whatis("Target : x86_64")
whatis("Short description : Julia is a high-level, high-performance dynamic progr
amming language for technical computing.")
conflict("julia")
prepend_path{"PATH","/orcd/software/core/001/pkg/julia/1.12.6/bin",delim=":"}
```

When we run `module show`, we can see the details of a module and know what happens when we load it. Note that this also reveals where the modulefile is located, which contains all of the information revealed by `module show`:

```bash
[secorey@login008 ~]$ cat /orcd/software/core/001/modulefiles/julia/1.12.6.lua
-- -*- lua -*-

--

whatis([[Name : Julia]])
whatis([[Version : 1.12.6]])
whatis([[Target : x86_64]])

whatis([[Short description : Julia is a high-level, high-performance dynamic pro
gramming language for technical computing.]])

local ver = "1.12.6"
local base = pathJoin("/orcd/software/core/001/pkg/julia/",ver)

conflict("julia")

prepend_path("PATH", pathJoin(base, "bin/"), ":")
```

This modulefile provides basic information about the software it points to and sets/updates [environment variables](../glossary.md#environment-variable) that will make the software available in your environment. Using the `prepend_path()` function, the key environment variable that this edits is `PATH`, which tells your shell session where to look for executables (e.g., the `julia` command). We can see how this behaves in practice:

```bash
[secorey@login006 ~]$ echo $PATH
/orcd/software/core/001/spack/pkg/gcc/12.2.0/yt6vabm/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
[secorey@login006 ~]$ module load julia/1.12.6 
[secorey@login006 ~]$ echo $PATH
/orcd/software/core/001/pkg/julia/1.12.6/bin:/orcd/software/core/001/spack/pkg/gcc/12.2.0/yt6vabm/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
```

After we load the module, the PATH environment variable has been updated, so now we can run `julia` commands. This is often all that is happening under the hood when you load a module. You can also use the `prepend_path()` function to edit other environment variables, like `LD_LIBRARY_PATH` or other software-specific options.

This modulefile contains other components as well, but these are less important. All the `whatis()` lines are purely informational and not required for the modulefile to work. The `conflict()` function will raise an error if you try to load this module and you already have a module named `julia` loaded.

## Modulefile Template

Below we provide a template on how to create a basic modulefile that adds software to your `PATH`:

```lua title="example_module.lua"
-- -*- lua -*-

--

-- Provide a description of the software (revealed when running `module whatis example_module`)
whatis([[Name : Example Software]]) -- name of your software
whatis([[Version : 1.0.0]]) -- version of your software
whatis([[Short description : My example software]]) -- short description of what the software does

-- Edit the PATH environment variable
-- Format `prepend_path(environment variable, path to software binaries, delimiter)`
prepend_path("PATH", "/path/to/my/software/bin", ":")
```

You may also find some of these additional functions useful:

```lua
setenv("MY_ENV_VAR", "value") -- sets an environment variable
depends_on("other_module_1", "other_module_2") -- automatically loads other modules when this one gets loaded
source_sh("shell_name", "shell_script") -- automatically source a shell script when this module gets loaded
conflict("other_module_1") -- raise an error if another module is loaded
```

For more information on modulefile functions, refer to the [lmod documentation](https://lmod.readthedocs.io/en/latest/050_lua_modulefiles.html).

### Module Path

If you create a modulefile, lmod will not find it unless it knows where to look. This can be done using the `module use` command. For example, if you have placed your modulefile in `~/software/modulefiles`, then you would need to run `module use ~/software/modulefiles` before you can load your module. However, it's best practice to place your modulefiles in `~/privatemodules`, because lmod will look there by default.
