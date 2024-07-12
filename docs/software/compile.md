---
tags:
 - Software
 - C/C++
 - Engaging
 - OpenMind
---

# Compiling Source Code in Linux

This page covers the basics of building programs from C source code, and automating this process using GNU Make. It is intended for scientists venturing into scientific programming, to help ease the frustrations that typically come up when starting to work in compiled programming languages.

## Preparation

=== "Engaging"
     A GCC compiler is needed to compile codes. Load a GCC module first, 
     ```
     module load gcc/12.2.0
     ```

## Building a single-file program

Let's start with a simple example: building a "hello world" C program with the GCC compiler. The program (*hello.c*) looks like this:
```
#include <stdio.h>
int main()
{
    printf("Hello World\n");
    return (0);
}
```

To build a working executable from this file, run:
```
gcc hello.c -o hello
```

This command creates an executable with a name of *hello*. Running this command prints the familiar message:
```
$ hello
Hello World
```

More happened here behind the scene. In fact, this command wraps up 4 steps of the build process: Preprocess, Compile, Assemble, and Link.

### Step 1: Preprocess
In this step, `gcc` calls preprocessing program `cpp` to interpret preprocessor directives and modify the source code accordingly.

Some common directives are:

- `#include`: includes contents of the named file, typically a header file, e.g. `#include <stdio.h>`.

- `#define`: macro substitution, e.g. `#define PI 3.14159`.

- `#ifdef ... #end`: conditional compilation, the code block is included only if a certain macro is defined, e.g:
```
#ifdef TEST_CASE
  a=1; b=0; c=0;
#endif
```

We could perform just this step of the build process like so:
```
cpp hello.c hello.i
```

Examining the output file (`vim hello.i`) shows that the long and messy *stdio.h* header has been appended to our simple code. 

### Step 2: Compile

In this step, the (modified) source code is translated from the C programming language into assembly code.

Assembly code is a low-level programming language with commands that correspond to machine instructions for a particular type of hardware. It is still just plain text, that says you can read assembly and write it too if you so desire.

To perform just the compilation step of the build process, we would run:
```
gcc -S -c hello.i -o hello.s
```

Examining the output file (`vim hello.s`) shows processor-specific instructions needed to run our program on this specific system. Interestingly, for such a simple program as ours, the assembly code is actually shorter than the preprocesses source code (though not the original source code).

### Step 3: Assemble

Assembly code is then translated into object code. This is a binary representation of the actions your computer needs to take to run your program. It is no longer human-readable, but it can be understood by computers.

To perform just this step of the build process, we would run:
```
gcc -c hello.s -o hello.o
```

You can try to view this object file like we did the other intermediate steps (`vim hello.o`), but the result will not be useful . Your text editor is trying to interpret binary machine language commands as ASCII characters, and (mostly) failing. Perhaps the most interesting result of doing so is that there are intelligable bits --- these are the few variables, etc, that actually are ASCII characters.

Also note that object files are not executables, you can't run them until after the next step.

### Step 4: Link

In the final step, `gcc` calls the linker program `ld` to combine the object file with any external functions it needs (e.g. library functions or functions from other source files). In our case, this would include `printf` from the C standard library.

To perform just this step of the build process, we would run:
```
gcc hello.o -o hello
```
This produces the executable `hello` finally. 

### Challege:

Compile and run the following program (*squares.c*):
```
#include <stdio.h>
main()
{ 
    int i;

    printf("\t Number \t\t Square of Number\n\n");

    for (i=0; i<=25; ++i)
    printf("\t %d \t\t\t %d \n", i, i*i);
}
```

Solution:
```
gcc squares.c -o squares
./squares
```

## Building a multi-file program

For most projects in the real world, it is convenient to break up the source code into multiple files. Typically, these include a main function in one file, and one or more other files containing functions / subroutines called by `main()`. In addition, a header file is usually used to share custom data types, function prototypes, preprocessor macros, etc.

As an example, we create a program with several source code files in a directory named *multi_string*, which consists of:

- *main.c*: the main driver function, which calls a subroutine and exits
- *WriteMyString.c*: a module containing the subroutine called by main
- *header.h*: one function prototype and one macro definition

??? Source codes for the *multi_string* program.
    
    *main.c*: 
    ```
    #include "header.h"
    #include <stdio.h>
    char    *AnotherString = "Hello Everyone";
    main()
    {
    printf("Running...\n");
    WriteMyString(MY_STRING);
    printf("Finished.\n");
    }
    ```

    *WriteMyString.c*:
    #include <stdio.h>
    extern char *AnotherString;
    void WriteMyString(char *ThisString)
    {
    printf("%s\n", ThisString);
    printf("Global Variable = %s\n", AnotherString);
    }


The easiest way to compile such a program is to include all the required source files at the `gcc` command line:
```
gcc main.c WriteMyString.c -o my_string
./my_string
```

It is also quite common to separate out the process into two steps:

1. source code -> object code
```
gcc -c WriteMyString.c
gcc -c main.c
```

2. object code -> executable (or library)
```
gcc WriteMyString.o main.o -o my_string
```

The reason is that this allows you to reduce compiling time by only recompiling objects that need to be updated. This seems silly for a program with only a few source files, but becomes important when many source files are involved. We will use this approach later when we discuss automating the build process.

### Including header files

In the above process, it is not necessary to include the header file explicitly on the `gcc` command line. This makes sense since we know that the (bundeled) preprocessing step will append any required headers to the source code before it is compiled.

There is one caveat: the preprocessor must be able to find the header files in order to include them. Our example works because the *header.h* file is in the current directory when we run `gcc`. We can break it by moving the header to a new subdirectory, like so:
```
mkdir include
mv header.h include
gcc main.c WriteMyString.c -o my_string
```

The above commands give the output error:
```
main.c:4:10: fatal error: header.h: No such file or directory
    4 | #include "header.h"
      |          ^~~~~~~~~~
compilation terminated.
```

We can fix this by specifically telling gcc where it can find the requisite headers, using the `-I` flag:
```
gcc -I ./include main.c WriteMyString.c -o my_string
```

This is most often need in the case where you wish to use external libraries installed in non-standard locations. We will explore this case later. 

### Challenge

In the folder multi_fav_num you will find another simple multi-file program. Build this source code to a program named fav_num using separate compile and link steps. Once you have done this successfully, change the number defined in other.c and rebuild. You should not have to recompile main.c to do this.

Solution:
gcc -c main.c
gcc -c other.c
gcc main.o other.o -o fav_num
./fav_num

vim other.c

gcc -c other.c
gcc main.o other.o -o fav_num
./fav_num
Linking external libraries
NOTE: content in this section is (lightly) modified from this site.

A library is a collection of pre-compiled object files that can be linked into your programs via the linker. In simpler terms, they are machine code files that contain functions, etc, you can use in your programs.

A few example functions that come from libraries are:

printf() from the libc.so shared library
sqrt() from the libm.so shared library
We will return to these in a moment.

Shared libraries vs static libraries
A static library has file extension of .a (archive file). When your program links a static library, the machine code of external functions used in your program is copied into the executable. At runtime, everything your program needs is wrapped up inside the executable.

A shared library has file extension of ".so" (shared objects). When your program is linked against a shared library, only a small table is created in the executable. At runtime, the exectutable must be able to locate the functions listed in this table. This is done by the operating system - a process known as dynamic linking.

Static libraries certainly seem simpler, but most programs use shared libraries and dynamic linking. There are several reasons why the added complexity is thought to be worth it:

Makes executable files smaller and saves disk space, because one copy of a library can be shared between multiple programs.
Most operating systems allow one copy of a shared library in memory to be used by all running programs, saving memory.
If your libraries are updated, programs using shared libraries automatically take advantage of these updates, programs using static libraries would need to be recompiled.
Because of the advantage of dynamic linking, GCC will prefer a shared library to a static library if both are available (by default).

Building with shared libraries in default (known) locations
Let's start with an example that uses the sqrt() function from the math library:

#include <stdio.h>
#include <math.h>

void main()
{ 
    int i;

    printf("\t Number \t\t Square Root of Number\n\n");

    for (i=0; i<=360; ++i)
        printf("\t %d \t\t\t %d \n", i, sqrt((double) i));

}
Notice the function sqrt, which we use, but do not define. The (machine) code for this function is stored in libm.so, and the function definition is stored in the header file math.h.

To build successfully, we must:

#include the header file for the external library
Make sure that the preprocessor can find this header file
Instruct the linker to link to the external library
Let's go ahead and build the program. To compile and link this in separate steps, we would run:

gcc -c roots.c
gcc roots.o -lm -o roots
The first command preprocesses roots.c, appending the header files, and then translates it to object code. This step does need to find the header file, but it does not yet require the library.

The second command links all of the object code into the executable. It does not need to find the header file (it is already compiled into roots.o) but it does need to find the library file.

Library files are included using the -l flag. Thier names are given excluding the lib prefix and exluding the .so suffix.

Just as we did above, we can combine the build steps into a single command:

gcc roots.c -lm -o roots
IMPORTANT Because we are using shared libraries, the linker must be able to find the linked libraries at runtime, otherwise the program will fail. You can check the libraries required by a program, and whether they are being found correctly or not using the ldd command. For out roots program, we get the following

ldd roots
linux-vdso.so.1 =>  (0x00007fff8bb8a000)
libm.so.6 => /lib64/libm.so.6 (0x00007ffc69550000)
libc.so.6 => /lib64/libc.so.6 (0x00007ffc691bc000)
/lib64/ld-linux-x86-64.so.2 (0x00007ffc69801000)
Which shows that our executable requires a few basic system libraries as well as the math library we explicitly included, and that all of these dependencies are found by the linker.

Challenge
Before moving on, let's take a few minutes to break this build process. Try the following and read the error messages carefully. These are your hints to fixing a broken build process.

Delete #include <math.h> from roots.c
Omit -lm from the linking step
Sidebar: where does the preprocessor look to find header files?
The preprocessor will search some default paths for included header files. Before we go down the rabbit hole, it is important to note that you do not have to do this for a typical build, but the commands may prove useful when you are trying to work out why something fails to build.

o look for the header, we can run the following commands to show the preprocessor search path and look for files in therein:

cpp -Wp,-v
Which has the following output:

ignoring nonexistent directory "/usr/local/include"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-redhat-linux/4.4.7/include-fixed"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-redhat-linux/4.4.7/../../../../x86_64-redhat-linux/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-redhat-linux/4.4.7/include
  /usr/include
  End of search list.
  ^C
The last few lines show the paths where GCC will search for header files by default. We can then search these include paths for the file we want, math.h like so:

find /usr/include /usr/lib/gcc/x86_64-redhat-linux/4.4.7/include -name math.h
Which has the following output:

/usr/include/FL/math.h
/usr/include/c++/4.4.4/tr1/math.h
/usr/include/math.h
If we are really curious, we could open the header and see what it contains, but this is rarely necessary.

Sidebar: where does the linker look to find libraries?
The linker will search some default paths for included library files. Again, it is important to note that you do not have to do this for a typical build, but the commands may prove useful when you are trying to work out why something fails to build.

To look for the library, we can run the following command to get a list of all library files the linker is aware of, then search that list for the math library we need:

ldconfig -p 
ldconfig -p | grep libmath
The latter command gives the output:

libm.so.6 (libc6,x86-64, OS ABI: Linux 2.6.18) => /lib64/libm.so.6
libm.so.6 (libc6, hwcap: 0x0028000000000000, OS ABI: Linux 2.6.18) => /lib/i686/nosegneg/libm.so.6
libm.so.6 (libc6, OS ABI: Linux 2.6.18) => /lib/libm.so.6
libm.so (libc6,x86-64, OS ABI: Linux 2.6.18) => /usr/lib64/libm.so
libm.so (libc6, OS ABI: Linux 2.6.18) => /usr/lib/libm.so
We certainly have the math library available. In fact, there are a few versions of this library known to the linker. Thankfully, we can let the linker sort out which one to use.

We might also want to peek inside a library file (or any object code for that matter) to see what functions and variables are defined within. We can list all the names, then search for the one we care about, like so:

nm /lib/libm.so.6
nm /lib/libm.so.6 | sqrt
The output of this command contains the following line, which shows us that it does indeed include something called sqrt.

0000000000025990 W sqrt
Building with shared libraries in non-default (unknown) locations
note: the following command lines build the libctest.so shared library used in the example below:

gcc -Wall -fPIC -c ctest1.c ctest2.c
gcc -shared -Wl,-soname,libctest.so -o libctest.so ctest1.o ctest2.o
end note

Let's switch to a new bit of example code, called use_ctest.c that makes use of a (very simple) custom library in the ctest directory:

#include <stdio.h>
#include "ctest.h"
 
int main(){
    int x;
    int y;
    int z;
    ctest1(&x);
    ctest2(&y);
    z = (x / y);
    printf("%d / %d = %d\n", x, y, z);
    return 0;
}
Trying to compile this fails with an error:

gcc -c use_ctest.c

use_ctest.c:2:19: error: ctest.h: No such file or directory
As the error message indicates, the problem here is that an included header file is not found by the preprocessor. We can use the -I flag to fix this problem:

gcc -I ctest_dir/include -c use_ctest.c
When we try to link the program to create an executable, we know we need to explicitly add the library with the -l flag, but in this case we still get an error:

gcc use_ctest.o -lctest -use_ctest

/usr/bin/ld: cannot find -lctest
collect2: ld returned 1 exit status
Just like for the header, we need to explicitly specify the path to the library file:

gcc -Lctest_dir/lib  use_ctest.o -lctest use_ctest
Success, or so it would seem. What happens when we try to run our shiny new executable?

./ctest

./ctest: error while loading shared libraries: libctest.so: cannot open shared object file: No such file or directory
We can diagnose this problem by checking to see if the dynamic linker is able to gather up all the dependencies at runtime:

ldd ctest

linux-vdso.so.1 =>  (0x00007fffd75ff000)
libctest.so => not found
libc.so.6 => /lib64/libc.so.6 (0x00007f802d21b000)
/lib64/ld-linux-x86-64.so.2 (0x00007f802d5dd000)
The output clearly shows that it does not. The problem here is that the dynamic linker will only search the default paths unless we:

Permanently add our custom library to this search path. This option is not covered here - I am assuming that many of you will be working on clusters and other systems where you do not have root permissions.

Specify the location of non-standard libraries using the LD_LIBRARY_PATH variable. LD_LIBRARY_PATH contains a colon (:) separated list of directories where the dynamic linker should look for shared libraries. The linker will search these directories before the default system paths. You can define the value of LD_LIBRARY_PATH for a particular command only by preceeding the command with the definintion, like so:

LD_LIBRARY_PATH=ctest_dir/lib:$LD_LIBRARY_PATH ./use_ctest
Or define it for your whole shell as an environment variable:

export LD_LIBRARY_PATH=/ctest_dir/lib:$LD_LIBRARY_PATH
./use_ctest
Hard-code the location of non-standard libraries into the executable. Setting (and forgeting to set) LD_LIBRARY_PATH all the time can be tiresome. An alternative approach is to burn the location of the shared libraries into the executable as an RPATH or RUNPATH. This is done by adding some additional flags for the linker, like so:

gcc -Lctest_dir/lib  use_ctest.o -lctest -Wl,rpath,ctest_dir/lib,--enable-new-dtags- use_ctest
We can confirm that this worked by running the program (resetting LD_LIBRARY_PATH first if needed), and more explicitly, by examining the executable directly:

./use_ctest
readelf -d use_ctest
Challenge
Without using your history, try to re-compile and run the use_ctest program. For an additional challenge, try to do so using RUNPATH to hardcode the location of the shared library.

Automating the build process with GNU Make
The manual build process we used above can become quite tedious for all but the smallest projects. There are many ways that we might automate this process. The simplest would be to write a shell script that runs the build commands each time we invoke it. Let's take the simple hello.c program as a test case:

#!/bin/bash
gcc -c hello.c
gcc hello.o -o hello
This works fine for small projects, but for large multi-file projects, we would have to compile all the sources every time we change any of the sources.

The Make utility provides a useful way around this problem. The solution is that we (the programmer) write a special script that defines all the dependencies between source files, edit one or more files in our project, then invoke Make to re-compile only those files that are affected by any changes.

Make is a mini-programming language unto itself, so I will only touch upon the simplest useage. For the hello program, a makefile might look like this:

hello: hello.o
    gcc hello.o -o hello

hello.o: hello.c
    gcc -c hello.c

clean:
    rm hello hello.o

.PHONY: clean
The syntax here is target: prerequisite_1 prerequisite_2 etc. The command block that follows will be executed to generate the target if any of the prerequisites have been modified. The first (top) target will be built by default, or you can specify a specific target to build following the make command. When we run make for the first time, the computer will take the following actions:

Find the default target, which is our executable file hello.
Check to see if hello is up-to-date, hello does not exist, so it is not up-to-date and will have to be built
Check to see if the prerequisite hello.o is up-to-date, hello.o does not exist, so it is not up-to-date and will have to be built.
The prerequisite hello.c is not a target, so there is nothing left to check. The command gcc -c hello.c will be run to build hello.o
Now hello.o is up to date, so make builds the next target, hello by running the command gcc hello.o -o hello
Done.
We can then compile using the make command:

make clean 
make
Notice that if no changes are made to the source files, make does not recompile anything --- there is no need to do so.

Let's look at an example for our first multi-file program:

write: main.o WriteMyString.o
        gcc main.o WriteMyString.o -o write

main.o: main.c header.h
        gcc -c main.c

WriteMyString.o: WriteMyString.c
        gcc -c WriteMyString.c

clean: 
        rm write *.o
