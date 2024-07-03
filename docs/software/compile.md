---
tags:
 - Software
 - C/C++
 - Engaging
 - OpenMind
---

# Building Software from Source Code in Linux

This page covers the basics of building small projects from C source code using the GCC compiler, and automating this process using GNU Make. It is intended for scientists venturing into scientific programming, to help ease the frustrations that typically come up when starting to work in compiled programming languages.

## Building a single-file program

Let's start with a simple example: building a "hello world" C program with the GCC compiler.

Our program (hello.c) looks like this:

```
#include <stdio.h>
main()
{
    (void) printf("Hello World\n");
    return (0);
}
```

To build a working executable from this file in the simplest way possible, run:

```
gcc hello.c
```

This command creates an executable with a default name of a.out. Running this command prints the familiar message:

```
$ a.out
Hello World
```

More happened here behind the scene. In fact, this command wraps up 4 steps of the build process: Preprocess, Compile, Assemble, and Link.



