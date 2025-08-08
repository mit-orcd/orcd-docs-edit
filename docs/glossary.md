# Glossary

**Apptainer / Singularity:** A container platform designed for high-performance computing (HPC) environments. It allows users to create and run containers that encapsulate their applications and dependencies, ensuring reproducibility and portability across different systems.

**Batch Job:** A type of job submitted to the scheduler to run in the background without direct interactive supervision. These are typically used for longer-running programs and are submitted using a script.

**Binary / Executable File:** A pre-built program file that can be run directly without needing to be compiled from source code. These are often placed in the `bin` directory of a software installation.

**CLI (Command Line Interface):** A text-based user interface used to interact with software and operating systems by typing commands into a console or terminal.

**Container:** A lightweight, standalone, and executable software package that includes everything needed to run a piece of software, including the code, runtime, libraries, and system tools. Containers are isolated from each other and the host system, allowing for consistent and reproducible environments across different computing platforms.

**Container Image:** A static file that contains the complete filesystem and configuration needed to run a containerized application. It serves as a blueprint for creating containers.

**Compute Node:** The primary nodes within an HPC cluster where the actual computational work of user jobs is performed.

**Computing Cluster:** A collection of interconnected computers (nodes) that work together to perform complex computations, often used in high-performance computing (HPC) environments.

**CPU Core:** The smallest unit of processing on a node that can be used by a job. In HPC, jobs can request a specific number of CPU cores to perform parallel tasks.

**Environment:** The overall configuration and settings in which a program or job runs, including system variables, paths, and loaded modules.

**Environment Variable:** Named values in your shell environment that store configuration information for the operating system and running programs. Examples include `$PATH` (which tells Linux where to look for executable files) or `$SLURM_ARRAY_JOB_ID` (set by the scheduler during job execution).

**Filesystem:** The method and structure by which files and directories are organized and stored on a computer. ORCD's clusters use a shared filesystem accessible by all nodes in the cluster.

**Globus:** A data management service that enables secure, reliable, and efficient transfer of files across multiple systems and locations.

**GPU (Graphics Processing Unit):** A specialized processor designed to accelerate graphics rendering and parallel processing tasks, commonly used in high-performance computing for tasks such as machine learning and simulations.

**GUI (Graphical User Interface):** A user interface that allows users to interact with electronic devices through graphical icons and visual indicators, as opposed to text-based interfaces, typed command labels, or text navigation.

**Home Directory:** A personal directory allocated to each user on the cluster, located at `/home/$USER`. This is the default working directory for users when they log in.

**Interactive Job:** A job that allows users to interact with the application or process while it is running, typically through a command line interface or graphical user interface.

<!-- CHECK -->
**I/O (Input/Output):** The communication between a program and the filesystem, including reading from and writing to files. I/O performance can be a critical factor in the efficiency of HPC applications.

**Job:** A unit of work submitted to the scheduler (e.g., Slurm) to be executed on the compute nodes of an HPC cluster

**Local Filesystem:** The storage system that is physically attached to a node, as opposed to shared or networked filesystems. Local filesystems typically offer faster access times but are limited to the storage capacity of the individual node.

**Login Node:** A specialized node within an HPC cluster that users first connect to via SSH or a web portal. It is intended for tasks like file editing, package installation, data downloads, and submitting jobs to compute nodes, but not for heavy computations.

**Memory:** The hardware component (such as RAM or cache) where data and applications are temporarily stored for active use by the processor. Data in memory is volatile and is lost when the computer is powered off or restarted.

**Module:** A software tool that allows users to easily manage different versions of software, libraries, and compilers in a shared computing environment. Users can load or unload modules to configure their environment for specific tasks.

**MPI (Message Passing Interface):** A standardized library of functions for parallel computing that enables data communication between processes running across multiple CPU cores or nodes. It's primarily used for distributed-memory parallelism, where each process has its own memory.

**Node:** An individual computing unit within an HPC cluster, which can be a physical or virtual machine. Each node typically has its own CPU cores and memory.

**OpenMP:** A shared-memory parallelism technique where different parts of a program run concurrently as "threads" within a single process, sharing the same memory space. OpenMP is a common standard for implementing multithreading.

**Partition:** A logical grouping of compute nodes within an HPC cluster, managed by the scheduler (Slurm). Different partitions may have varying CPU types, GPU availability, memory limits, or time limits, and jobs are submitted to specific partitions.

<!-- CHECK -->
**Process:** An instance of a running program, which can consist of one or more threads. Each process has its own memory space.

**Python Environment:** A self-contained directory that includes a specific version of Python and a set of installed Python packages. This allows users to manage dependencies and avoid conflicts between different projects.

**Scratch Storage:** Temporary, high-speed storage areas optimized for I/O-heavy jobs. Data stored here is typically not backed up and is meant for actively running jobs rather than long-term storage.

**Slurm / Scheduler:** An open-source workload manager designed for high-performance computing (HPC) clusters. It is used to allocate resources, schedule jobs, and manage job queues on the cluster.

**Terminal / Shell / Command Line / Console:** A text-based interface used to interact with the operating system and run commands.

<!-- CHECK -->
**Thread:** A smaller unit of a process that can run concurrently with other threads within the same process, sharing the same memory space.
