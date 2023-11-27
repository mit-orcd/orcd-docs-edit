---
tags:
 - Engaging
 - Howto Recipes
 - spack
 - Rocky Linux
---

# Example of setting up a Spack environment that inherits from the system setup

This example shows a basic example of using the Spack tool to create a custom software environment.
The example illustrates configuring Spack to reuse libraries and software that are part of the core Spack setup on a cluster. 


## About Spack

The tool [Spack](https://spack.readthedocs.io) is a system for self-service building of a large number of different scientific software applications
and libraries. Spack is an open source tool maintained in public repositories under the [Spack github organization](https://github.com/spack). 
Development of Spack is led by a team at the [Lawrence Livermore National Laboratory](https://computing.llnl.gov/projects/spack-hpc-package-manager).


## Setting up a Spack environment that inherits a system setup

The Spack tool has many options and can be used in a variety of ways. Here we show how to configure Spack to _inherit_ pre-built 
software from a core set of system supported tools that have also been built with Spack. This recipe can be used to self-build custom 
software that is not available, or that needs special configuration options. Using Spack does not require any privileged system access. 
The approach for using Spack shown here allows regular accounts to build custom software that builds on top of core system tools like 
compilers, commincations and I/O libraries that have been been built and optimized previously using Spack.

!!! note "Prerequisites"

    This example assumes you have access to a Slurm partition and are working with a Rocky Linux environment.
    The example also uses git command, so some familiarity with git is useful.

#### 1. Configure an instance of Spack in a working directory under your account

A first step to using Spack is to download the software from its Github repository into a working directory using the following command.

```bash
mkdir -p /nobackup1/users/${USER}/spack-testing
cd /nobackup1/users/${USER}/spack-testing
git clone https://github.com/spack/spack.git
```

in this example we use ` /nobackup1/users/${USER}/spack-testing` as our workig directory.

Next we configure Spack, setting the it to use standard tools that have already been built from a pre-exisiting location.

??? note
    The compilation example shows using Spack in a way that uses pre-existing _upstream_ Spack built software 
    from another location. This can be useful on a cluster computer where a central team may have already installed and configured some standard foundation software tools, 
    such as a compiler and high-performance tools for using GPUs and/or for parallel communication. Configuring these foundation software tools can involve seaprate
    testing and performance settings, so using a pre-installed foundation is generally useful. To make a Spack _upstream_ work reliably we need to use the same tag of 
    Spack as used in the upstream and provide a path name to the upstream isntallation.

To configure Spack to use the following sequence of commands.

```bash
# Switch to build location
cd /nobackup1/users/${USER}/spack-testing

# Set any .spack files to be local to this test
export SPACK_USER_CONFIG_PATH=`pwd`/user_config

# Set checked out version of downloaded Spack to match upstream Spack version
(
 cd spack
 git checkout -b v0.19.1 v0.19.1
)

# Copy reference config files for upstream and set upstream location
mkdir -p `pwd`/user_config
cp /software/spack/etc/spack/*yaml user_config
cat  > user_config/upstreams.yaml << EOF
upstreams:
  orcd-rcf-2023:
   install_tree: /software/spack-20230328/opt/spack
EOF

source spack/share/spack/setup-env.sh
```

Here the directory `/software/spack-20230328/opt/spack` holds a pre-built set of spack software. By convention this directory
is dated and software in that directory is unchanged once published.

#### 2. Test Spack settings

Once Spack has been installed and configured to use the _upstream_ the setup can be checked with some basic Spack commands.

For a clean setup, the command `spack find -p` will list the packages that are part of the _upstream_.

```bash
$ spack find -p
```

??? example Example `spack find -p` output
        -- linux-rocky8-x86_64 / gcc@8.5.0 ------------------------------
    anaconda3@2022.05                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/anaconda3-2022.05-auh4o3tsby7ze6q6v3stn2hhvvnpoy5f
    apptainer@1.1.7                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/apptainer-1.1.7-6nplh4eg7jbwvore6n64kqjuq3azwiuz
    autoconf@2.69                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/autoconf-2.69-lh2icxcpszli5fqpmnnsm5ou3lsyzdrp
    autoconf-archive@2022.02.11          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/autoconf-archive-2022.02.11-g23hpccqxo2ophg6wu3mmgjbnfyzkzrg
    automake@1.16.5                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/automake-1.16.5-zzll4bdhsazmzw24ad6lllagpjgsbdrh
    berkeley-db@18.1.40                  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/berkeley-db-18.1.40-opmuvc3wtmhnsbxo5h3gx5vlx4ddb3qh
    bzip2@1.0.8                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/bzip2-1.0.8-435nqz2qylovfj5actxdd4he2nxwcudl
    ca-certificates-mozilla@2022-10-11   /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/ca-certificates-mozilla-2022-10-11-qwmkdfvqnxabvqmo4rmxw7odebhxlzms
    cmake@3.24.3                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/cmake-3.24.3-wl6znag5vxnnu7tbfuzfcglywjhnodif
    cryptsetup@2.3.5                     /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/cryptsetup-2.3.5-bcwrpxj7fukhr4xwzwd46x5fjvl5xbhs
    cuda@11.7.1                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/cuda-11.7.1-ekeihrzg7wdjpodjocdvbtn3x2w7aljt
    cuda@11.8.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/cuda-11.8.0-vg5grnoa6uej4lqz5xkdellrtmeuehks
    cuda@12.1.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/cuda-12.1.0-vt2eu3lvwhefwor7blj5efojdwhm62cz
    curl@7.61.1                          /usr
    curl@7.61.1                          /usr
    diffutils@3.6                        /usr
    expat@2.4.8                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/expat-2.4.8-etfv6vcrvjgw53l6lfhfv2h25oux4ztx
    gawk@4.2.1                           /usr
    gcc@12.2.0                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/gcc-12.2.0-or6pfydukwucqlbwbijl5pgpgknm4jc5
    gdbm@1.23                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/gdbm-1.23-styuucqsxu5ijztqioqp546ab3nsj4cg
    gettext@0.21.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/gettext-0.21.1-nbkxn62doo3mnrwhyzznzurz5weo44uh
    git@2.38.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/git-2.38.1-yqwdlmx5ucwdcncemgmj47x7rqscg74r
    gmp@6.2.1                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/gmp-6.2.1-7foizuxesi7lirofhor27whdct4kedsd
    go@1.18                              /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/go-1.18-6vwaqzbprbdkrxi3emir3qiwu53zp4ky
    go-bootstrap@1.4-bootstrap-20171003  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/go-bootstrap-1.4-bootstrap-20171003-xdtzbibtta32x6d3a2tjqinpwqwum5g4
    gperf@3.1                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/gperf-3.1-7y7t3u3e5lhsplaccinqt3e7tqi6m4fw
    icu4c@67.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/icu4c-67.1-n2fztxevgeb5a7t5vodovkwznnu5xuea
    json-c@0.16                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/json-c-0.16-judtni3yvmgutoq7a7tj5uevv5oyun4h
    libaio@0.3.110                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libaio-0.3.110-on6qmnvcztdfauplwanduvxwu3iqjaur
    libbsd@0.11.5                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libbsd-0.11.5-h7nbgyooe7umbegvngfaksiu7uasahri
    libffi@3.4.2                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libffi-3.4.2-hzkiqiihxyxckuxmqztlr4v6ufyzrh4s
    libfuse@3.11.0                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libfuse-3.11.0-v7icykteep5lzei5uql6kxps2xymz2xc
    libgpg-error@1.46                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libgpg-error-1.46-vi7oqicphj3clbnrmpcpmjrsmmjmnkpm
    libiconv@1.16                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libiconv-1.16-cq3qojm4g5p3d42wbrem7t5qmk2qdcml
    libidn2@2.3.0                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libidn2-2.3.0-xd6wkumburbremywdntadetw5uqu5ugg
    libmd@1.0.4                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libmd-1.0.4-rd5v3y6b5o24fuh4d3g3jaak7q7oqxj5
    libseccomp@2.5.3                     /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libseccomp-2.5.3-3ankn2sfxzoppyfx7mmttudwrxt5zt7o
    libtool@2.4.7                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libtool-2.4.7-hijonj3epcaneytjc4hhxchou7kqmali
    libunistring@0.9.10                  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libunistring-0.9.10-qks2nzlgbmuuzkjobrbcems73y7mgeuv
    libxml2@2.10.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/libxml2-2.10.1-tlwgeznt7noqbe4tyvgo7eioiy5bbpo7
    lvm2@2.03.14                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/lvm2-2.03.14-sbkkyskkrodufpgk2ud4cos4ph45s2tu
    lz4@1.9.4                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/lz4-1.9.4-4sfz3ea2nptxb277ei5qmrwkg3mtiwk5
    lzo@2.10                             /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/lzo-2.10-s5aj5dynoqnxwhr32vm75xonv7p4wrag
    m4@1.4.18                            /usr
    meson@0.63.3                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/meson-0.63.3-hm2nezubvf5xijrhgc3uh5wx2hcd5qal
    mpc@1.2.1                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/mpc-1.2.1-b4jugmci4olazbau6km5s7cx7xepuchd
    mpfr@4.1.0                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/mpfr-4.1.0-qr6a26qzzqtjjxz6jvef6dhqrbakur3m
    ncurses@6.3                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/ncurses-6.3-etnd7s2o2ulyhufqqd6nxtof7xjuas2m
    ninja@1.11.1                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/ninja-1.11.1-jynu4yy4xs7dq44xzhwj74xvackjpizg
    openjdk@11.0.17_8                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/openjdk-11.0.17_8-fnbcj7icqvei4o3gl7moh7oa3gdvotan
    openssh@8.0p1                        /usr
    openssl@1.1.1s                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/openssl-1.1.1s-ji6rx4jcvel3p5kjkqfd6nwmmvmtxn42
    pcre2@10.39                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/pcre2-10.39-p2lvvislw46t7daf42lgbcpg3z5six3w
    perl@5.36.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/perl-5.36.0-y6fudwffjhkddghhmhd4zhfnwkjob24a
    pkgconf@1.8.0                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/pkgconf-1.8.0-hrm7ecblduqqvgjh6sb3iyhyxrtlxwcs
    popt@1.16                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/popt-1.16-erltgugfg2aqsue7simkmdfjiuy6tctm
    py-cython@0.29.32                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/py-cython-0.29.32-gtsyxkapdev76bfi3rdewdjy7av5phnb
    py-pip@22.2.2                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/py-pip-22.2.2-ltop5ehltqzvfxvui63u6h2xeq4pycgt
    py-setuptools@65.5.0                 /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/py-setuptools-65.5.0-eefyom7x7ajh2to7xpmhw2sxcp4iqotg
    py-wheel@0.37.1                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/py-wheel-0.37.1-eiquxjgcdtft4ha2d2p5tku6is75y4u5
    python@3.10.8                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/python-3.10.8-dgzhxpu7ahjyzpdkcfi65rh5nwgp5gxi
    r@4.2.2                              /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/r-4.2.2-bqgbdpcoq6n7xnobc6eefarat576ixmt
    readline@8.1.2                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/readline-8.1.2-iyif6uwyiflgbmgmtgq7nmnhtjxrcfo3
    shadow@4.8.1                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/shadow-4.8.1-gi367ocnga5efplcgvdhp4hrcy3jcgi2
    singularity@3.8.7                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/singularity-3.8.7-nsuy6hdcodpm2y6yczucnrz6obpixhmg
    sqlite@3.39.4                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/sqlite-3.39.4-o4e2hd5l54u56a3dbntkgrsyg6dfgq6u
    squashfs@4.5.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/squashfs-4.5.1-qfa6ofykjfnfpu5iywx6fso5bqozck3w
    squashfs-mount@0.1.0                 /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/squashfs-mount-0.1.0-2mhkxmwy4x6cxh2anqutgb6pt2t4wihn
    squashfuse@0.1.104                   /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/squashfuse-0.1.104-kcbuffjjkyknvhzmfr36ktuo2hmjbpcu
    tar@1.30                             /usr
    texinfo@6.5                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/texinfo-6.5-5czyvd67wrejtbmggz4qbascphsi5mvc
    util-linux@2.38.1                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/util-linux-2.38.1-ofov7dvbixtuo7h3dtyjzwifhbbyxdke
    util-linux-uuid@2.38.1               /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/util-linux-uuid-2.38.1-h7wduoujz2xunzmz72zqhsvozv3fyf3l
    util-macros@1.19.3                   /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/util-macros-1.19.3-avyhv6pynclxfdsftucqrtjbtanjbmd6
    which@2.21                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/which-2.21-6cqh4o7dn6bt42min3ac5ynflaemyet6
    xz@5.2.7                             /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/xz-5.2.7-axjh2zsdc4pyjgrhysfldoi2ynp4dhgz
    zlib@1.2.13                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/zlib-1.2.13-dcpzngybj4fisn6ojapnels3yfwcxqgk
    zstd@1.5.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/zstd-1.5.2-p276rtd7imzam6ukdiq35iif3qmzpwd3
    
    -- linux-rocky8-x86_64 / gcc@12.2.0 -----------------------------
    alsa-lib@1.2.3.2                     /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/alsa-lib-1.2.3.2-da4dhnudfslxlganozpe6kgegttb5wqt
    apr@1.7.0                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/apr-1.7.0-jhqfvgatkd35nagfkfplcvledlilszlp
    autoconf@2.69                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/autoconf-2.69-llmf6eoq46fjuega6mzjc6kjpeta2abx
    automake@1.16.5                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/automake-1.16.5-t3rctjlwqpmn5x433eeeusphmtypv6g7
    berkeley-db@18.1.40                  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/berkeley-db-18.1.40-ehlkmyphsdbfkgvt6wtznpvs6gpelo4a
    bison@3.8.2                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/bison-3.8.2-c4tgrq23hiatbdxkxdsvuzure2uu3igf
    bzip2@1.0.8                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/bzip2-1.0.8-y2uodljjpotqgdgf4ync654ow6zq3yui
    ca-certificates-mozilla@2022-10-11   /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/ca-certificates-mozilla-2022-10-11-acak7eo66b264d5tnlrgdsqquriqzikw
    cmake@3.24.3                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/cmake-3.24.3-7kayesehfqsqbz3anbeuesrhg7jivrh7
    cuda@11.7.1                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/cuda-11.7.1-xle3mjjckqm7fvknkbdletwmbz2ogima
    cuda@12.1.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/cuda-12.1.0-loulnd3xxa433rvdvtzu67nb4muiyxqt
    curl@7.61.1                          /usr
    curl@7.61.1                          /usr
    diffutils@3.6                        /usr
    expat@2.4.8                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/expat-2.4.8-fw7viptexxob2jlhoimbbx2iuelorefg
    ffmpeg@4.4.1                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/ffmpeg-4.4.1-o2bzn3dn2oxv3z2gxmjdbqdrg2cujdub
    fftw@2.1.5                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/fftw-2.1.5-2lny4n4bvggncd4pb2qorsrbldm4ycuo
    fftw@3.3.10                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/fftw-3.3.10-qiaruimvw6zu2h4f5eolqom7tixem6vk
    findutils@4.6.0                      /usr
    flac@1.4.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/flac-1.4.2-atmh3mwbqtzsjr4yhvfveohbi3t5jcax
    flex@2.6.3                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/flex-2.6.3-n4ex34zvvefzgb3kujwzymjcjx7bqy72
    gawk@4.2.1                           /usr
    gdbm@1.23                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/gdbm-1.23-medv6udj2ovi3p7sjpffxzfl4t4yb6i2
    gdrcopy@2.3                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/gdrcopy-2.3-6mhshpnmk5eluz3l7kkiiwaijetaugaz
    gettext@0.21.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/gettext-0.21.1-srssurbwe76knqj3m2a2g3yl6htki75r
    git@2.38.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/git-2.38.1-4w3cqhsyia6sk4stgr7fwgxg5zjfq43q
    go@1.18                              /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/go-1.18-xajf4hxll2v2nbp245hkfm3rvshyiplo
    go-bootstrap@1.4-bootstrap-20171003  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/go-bootstrap-1.4-bootstrap-20171003-n4hjfyquubd67s4v6oqf6fzp6gtv534q
    gperf@3.1                            /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/gperf-3.1-6wd6t4cievsiag4lits2re4ofon3appr
    hdf5@1.12.2                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/hdf5-1.12.2-v654jvmidpawxfmahj6wdlmmuwiwm2c4
    hwloc@2.8.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/hwloc-2.8.0-qsndok6gy4kvtirjvpznepexvhwofhkx
    hwloc@2.8.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/hwloc-2.8.0-a56oj35bkhqi7rpsxyrzv2cvjhk6f4nl
    icu4c@67.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/icu4c-67.1-wx5f74frcoecrzjdmam7kkd476izknol
    jasper@3.0.3                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/jasper-3.0.3-pj2br7l253hf2cpp372pbcyqondoig5e
    knem@1.1.4                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/knem-1.1.4-lf6nroe2ungmj4jfktllyn3lb634phai
    lammps@20220623                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/lammps-20220623-murlzo54sqte5xacqcusa6pdmuv7lbju
    libbsd@0.11.5                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libbsd-0.11.5-wem5x2oesmhxmfp7x63sgdop57ribigd
    libevent@2.1.12                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libevent-2.1.12-dnasb7atyzwlagnyyrplzk5if6efrfbe
    libffi@3.4.2                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libffi-3.4.2-ag3cenfsq7igpp33kkdgs5l6llm7mfaa
    libgpg-error@1.46                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libgpg-error-1.46-22mz7z6jfw5ppc76fszhudaihzftnjkj
    libiconv@1.16                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libiconv-1.16-y7hkdyocmeei7gipuzq6dauwoscds65d
    libidn2@2.3.0                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libidn2-2.3.0-6qhikuoappueuwjrkw3oqase4qxz6bqg
    libjpeg-turbo@2.1.3                  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libjpeg-turbo-2.1.3-ig3drj7aya7pibjynlbjdki4wj26nvq3
    libmd@1.0.4                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libmd-1.0.4-jxvqhjl7uir2utgpdxzxho744wnbyicj
    libnl@3.3.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libnl-3.3.0-tf5fu6kqufhtdnnt4v3xyzpyomqlod3x
    libogg@1.3.5                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libogg-1.3.5-dpk3c3tn6gniweiser6qrnfyansoikk7
    libpciaccess@0.16                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libpciaccess-0.16-id32hkaz34tj6rm436wmiaoes7jtjomj
    libpng@1.6.37                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libpng-1.6.37-bpm4irmoa3ly7mn2v2eezr4nvoxt57uz
    libseccomp@2.5.3                     /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libseccomp-2.5.3-2ycxcvstoyoq744dmw4iy6ibuaxvnyln
    libtool@2.4.7                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libtool-2.4.7-lmcpaypsio2xylqqkhyis36sem4q2uqx
    libunistring@0.9.10                  /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libunistring-0.9.10-mmqjji2rjgwtysz2i7eh23v34ynecsn5
    libvorbis@1.3.7                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libvorbis-1.3.7-n6p4ft4hjegtrndwx54qid5imn3f4btp
    libxml2@2.10.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/libxml2-2.10.1-avncq4uc2k673jnoxdeqijalhwxfu452
    m4@1.4.18                            /usr
    nasm@2.15.05                         /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/nasm-2.15.05-t4dj6jrogzp26ylmy7meqdm5uerw2vou
    ncurses@6.3                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/ncurses-6.3-c5ckfq5br4hzxtjpinax3wmblpxcwccq
    netcdf-c@4.9.0                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/netcdf-c-4.9.0-qvvpxf6y5i6kdtnre7jfsatj4f7uxciy
    netcdf-cxx@4.2                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/netcdf-cxx-4.2-insnzalmami3zcunpthcs5fsowd23tvl
    netcdf-fortran@4.6.0                 /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/netcdf-fortran-4.6.0-7dvzbuupe2zhxil5fwqnptqz4hahht7j
    netlib-lapack@3.10.1                 /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/netlib-lapack-3.10.1-pj6b3k7bcoyjmykagfm3nsrk2oy34twc
    netlib-scalapack@2.2.0               /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/netlib-scalapack-2.2.0-k3ud6nm3wvznohhrotikdmr3es76m277
    numactl@2.0.14                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/numactl-2.0.14-n3atoewxkrcnzrv35ggcghde7uknwnc2
    openblas@0.3.21                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/openblas-0.3.21-xi3b3vdolnvrzjvps3uwj27kf6t2o364
    openjdk@11.0.17_8                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/openjdk-11.0.17_8-5wygspwasmwjni2gyaeztltsrl6hsj4p
    openmpi@4.1.4                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/openmpi-4.1.4-3r4zaihkaqj2gmfvtzk4adiu3qxlzgj5
    openssh@8.0p1                        /usr
    openssl@1.1.1s                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/openssl-1.1.1s-teeyrkysydy6st2gjgmlilsqhdvhytxg
    opus@1.3.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/opus-1.3.1-7dxwmz2br23leut5k2hhzw4vgen7hwi5
    orca@5.0.3                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/orca-5.0.3-nqqov677gwq2dl3nr3sz43c53qfxbo5k
    pcre2@10.39                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/pcre2-10.39-w5l7yn7eifteexie5rrro7onvwgkdrqs
    perl@5.36.0                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/perl-5.36.0-d345fqycp52qf5jf35in4tkz3bg7en2t
    pkgconf@1.8.0                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/pkgconf-1.8.0-wxuqfjdqv4bjudl2aixkqcowfz35q62u
    pmix@4.1.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/pmix-4.1.2-vf7opodohxp5ffpy7npnjv4odjloncml
    pmix@4.1.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/pmix-4.1.2-d7f7fwzoomvmc6hwotduhlzmdoc6oz7o
    py-cython@0.29.32                    /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/py-cython-0.29.32-umku6chzt6j4xfzysaxhu4drnk3gnk6p
    py-docutils@0.19                     /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/py-docutils-0.19-imomhs5czwwjpjwka3pchqoqmvhkybta
    py-pip@22.2.2                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/py-pip-22.2.2-ru3kxolfjtu3dna4ou6ebnd34xxqdgug
    py-setuptools@65.5.0                 /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/py-setuptools-65.5.0-2ze2pnic7bshbeu635yejl6325b57bfh
    py-wheel@0.37.1                      /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/py-wheel-0.37.1-2fvi4pmz4mnqmufgbdusfg3jbxq2xkrn
    python@3.10.8                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/python-3.10.8-flipoyygqdyq56ytifzzitgmb7x4bdno
    rdma-core@41.0                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/rdma-core-41.0-y7we5jx3cbxrdetx4czervl3x5u6sw4d
    readline@8.1.2                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/readline-8.1.2-5zhrz242nlulabfgalogdv6vgxfnigae
    slurm@22.05.6                        /usr
    sox@14.4.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/sox-14.4.2-bqoteuefvqj4rzmj2i5u7juxmtu2ee77
    sqlite@3.39.4                        /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/sqlite-3.39.4-uvuc44zwmae3ypmqvjrpymleierkahwj
    squashfs@4.5.1                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/squashfs-4.5.1-4ljrto75iqeuy5sqzk2sdqhml7crwqcz
    tar@1.30                             /usr
    texinfo@6.5                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/texinfo-6.5-7d4leckhlhuoohssq3ynjawy6seiov3o
    ucx@1.13.1                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/ucx-1.13.1-xxapazpv4rciyeuajxom5vfll4djhakq
    util-linux-uuid@2.38.1               /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/util-linux-uuid-2.38.1-f36megz6i272yo6gqj2h72byzupu2u3f
    util-macros@1.19.3                   /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/util-macros-1.19.3-74pwk3n734nymhilw7fvcjhkdzr22xa5
    which@2.21                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/which-2.21-lhdkb5lm2223g5r4cw5ksgod2ahbhf42
    xpmem@2.6.5-36                       /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/xpmem-2.6.5-36-omne2gv2jqp4wmdqfnb6wfozhda6mznn
    xz@5.2.7                             /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/xz-5.2.7-a7ikzndwlj3et447m7ycfy3rjnllhr6c
    yasm@1.3.0                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/yasm-1.3.0-up3oys25bdxvv5n2cdvhyaodk4pjm46t
    zlib@1.2.13                          /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/zlib-1.2.13-xzya3i6ni4zkbycrk2bnbwba3dtfjpag
    zstd@1.5.2                           /nfs/software001/home/software-r8-x86_64/spack-20230328/opt/spack/linux-rocky8-x86_64/gcc-12.2.0/zstd-1.5.2-qsb6yicesijb5zudq2q6cmkrywv2axyc
