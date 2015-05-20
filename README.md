[![Build Status](https://travis-ci.org/DlangScience/NetCDF-D.svg?branch=master)](https://travis-ci.org/DlangScience/NetCDF-D)
NetCDF-D
========

D bindings to the NetCDF C library (https://github.com/Unidata/netcdf-c and http://www.unidata.ucar.edu/software/netcdf/)

Usage
-----

```import netcdf;``` and you're away.

Everything should work identically to the C version, with the exception of the backward compatibility and deprecated sections which have been removed. D version blocks have been used in place of C version macros. The names of the versions are kept the same.


Note that this is a binding a C library, where type sizes are somewhat implementation defined. I would recommend against using functions taking ```c_long```/```c_ulong``` in favour of ```int```/```uint``` and ```long```/```ulong```.[1]

Architectures / C compilers where C types don't comply with ```sizeof(int) == 4 && sizeof(long long) == 8``` or have ```float```/```double``` types laid out differently to the IEEE-754 standard single and double precision formats are not supported at this time.[2]


[1] Note that the function naming has not been changed. Functions with ```long```/```ulong``` in the name take ```c_long```/```c_ulong``` as parameters, functions with (u)longlong in the name take ```long```/```ulong```.

[2] Things will probably still work if you can avoid using the parts of the C API that use the offending types.


Licence
-------
NetCDF uses a very liberal custom licence (see NetCDF_COPYRIGHT), which also applies to these bindings. Dub doesn't know about this license and may blindly complain that it is incompatible with everything. This does not necessarily mean it is incompatible with the other licenses you are using.
