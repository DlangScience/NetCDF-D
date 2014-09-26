/*! \file

Main header file for the C API.

Copyright 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002,
2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011 University
Corporation for Atmospheric Research/Unidata. See \ref copyright file
for more info.
*/

import core.stdc.config;

/*! The nc_type type is just an int. */
alias nc_type = int;

extern(C):

/*
 * The netcdf external data types
 */
enum NC_NAT    = 0;    /**< Not A Type */
enum NC_BYTE   = 1;    /**< signed 1 byte integer */
enum NC_CHAR   = 2;    /**< ISO/ASCII character */
enum NC_SHORT  = 3;    /**< signed 2 byte integer */
enum NC_INT    = 4;    /**< signed 4 byte integer */
enum NC_LONG   = NC_INT;  /**< deprecated, but required for backward compatibility. */
enum NC_FLOAT  = 5;    /**< single precision floating point number */
enum NC_DOUBLE = 6;    /**< double precision floating point number */
enum NC_UBYTE  = 7;    /**< u1 byte int */
enum NC_USHORT = 8;    /**< u2-byte int */
enum NC_UINT   = 9;    /**< u4-byte int */
enum NC_INT64  = 10;   /**< signed 8-byte int */
enum NC_UINT64 = 11;   /**< u8-byte int */
enum NC_STRING = 12;   /**< string */

enum NC_MAX_ATOMIC_TYPE = NC_STRING;

/* The following are use internally in support of user-defines
 * types. They are also the class returned by nc_inq_user_type. */
enum NC_VLEN     = 13;    /**< vlen (variable-length) types */
enum NC_OPAQUE   = 14;    /**< opaque types */
enum NC_ENUM     = 15;    /**< enum types */
enum NC_COMPOUND = 16;    /**< compound types */

/* Define the first user defined type id (leave some room) */
enum NC_FIRSTUSERTYPEID = 32;

/** Default fill value. This is used unless _FillValue attribute
 * is set.  These values are stuffed into newly allocated space as
 * appropriate.  The hope is that one might use these to notice that a
 * particular datum has not been set. */
/**@{*/
enum byte NC_FILL_BYTE     = -127;
enum char NC_FILL_CHAR     = 0;
enum short NC_FILL_SHORT   = -32767;
enum int NC_FILL_INT       = -2147483647;
enum float NC_FILL_FLOAT   = 9.9692099683868690e+36; /* near 15 * 2^119 */
enum double NC_FILL_DOUBLE = 9.9692099683868690e+36;
enum ubyte NC_FILL_UBYTE   = 255;
enum ushort NC_FILL_USHORT = 65535;
enum uint NC_FILL_UINT     = 4294967295;
enum long NC_FILL_INT64    = -9223372036854775806;
enum ulong NC_FILL_UINT64  = 18446744073709551614U;

@property char* NC_FILL_STRING() { return emptyStr.ptr; }

private __gshared static char[1] emptyStr;
/**@}*/

/*! Max or min values for a type. Nothing greater/smaller can be
 * stored in a netCDF file for their associated types. Recall that a C
 * compiler may define int to be any length it wants, but a NC_INT is
 * *always* a 4 byte signed int. On a platform with 64 bit ints,
 * there will be many ints which are outside the range supported by
 * NC_INT. But since NC_INT is an external format, it has to mean the
 * same thing everywhere. */
/**@{*/
enum byte NC_MAX_BYTE     = 127;
enum byte NC_MIN_BYTE     = -NC_MAX_BYTE-1;
enum char NC_MAX_CHAR     = 255;
enum short NC_MAX_SHORT   = 32767;
enum short NC_MIN_SHORT   = -NC_MAX_SHORT - 1;
enum int NC_MAX_INT       = 2147483647;
enum int NC_MIN_INT       = -NC_MAX_INT - 1;
enum float NC_MAX_FLOAT   = 3.402823466e+38;
enum float NC_MIN_FLOAT   = -NC_MAX_FLOAT;
enum double NC_MAX_DOUBLE = 1.7976931348623157e+308;
enum double NC_MIN_DOUBLE = -NC_MAX_DOUBLE;
enum ubyte NC_MAX_UBYTE   = NC_MAX_CHAR;
enum ushort NC_MAX_USHORT = 65535;
enum uint NC_MAX_UINT     = 4294967295;
enum long NC_MAX_INT64    = 9223372036854775807;
enum long NC_MIN_INT64    = -9223372036854775807-1;
enum ulong NC_MAX_UINT64  = 18446744073709551615U;
//what are these for?
enum long X_INT64_MAX     = 9223372036854775807;
enum long X_INT64_MIN     = -X_INT64_MAX - 1;
enum ulong X_UINT64_MAX   = 18446744073709551615U;
/**@}*/

/** Name of fill value attribute.  If you wish a variable to use a
 * different value than the above defaults, create an attribute with
 * the same type as the variable and this reserved name. The value you
 * give the attribute will be used as the fill value for that
 * variable. */
@property char* _FillValue() { return _FillValueStr.ptr; }
enum NC_FILL    = 0;    /**< Argument to nc_set_fill() to clear NC_NOFILL */
enum NC_NOFILL  = 0x100;    /**< Argument to nc_set_fill() to turn off filling of data. */

private __gshared static char[10] _FillValueStr = "_FillValue";

/* Define the ioflags bits for nc_create and nc_open.
   currently unused: 0x0010,0x0020,0x0040,0x0080
   and the whole upper 16 bits
*/

enum NC_NOWRITE       = 0x0000; /**< Set read-only access for nc_open(). */
enum NC_WRITE         = 0x0001; /**< Set read-write access for nc_open(). */
/* unused: 0x0002 */
enum NC_CLOBBER       = 0x0000; /**< Destroy existing file. Mode flag for nc_create(). */
enum NC_NOCLOBBER     = 0x0004; /**< Don't destroy existing file. Mode flag for nc_create(). */

enum NC_DISKLESS      = 0x0008; /**< Use diskless file. Mode flag for nc_open() or nc_create(). */
enum NC_MMAP          = 0x0010; /**< Use diskless file with mmap. Mode flag for nc_open() or nc_create(). */

enum NC_CLASSIC_MODEL = 0x0100; /**< Enforce classic model. Mode flag for nc_create(). */
enum NC_64BIT_OFFSET  = 0x0200; /**< Use large (64-bit) file offsets. Mode flag for nc_create(). */

/** \deprecated The following flag currently is ignored, but use in
 * nc_open() or nc_create() may someday support use of advisory
 * locking to prevent multiple writers from clobbering a file
 */
enum NC_LOCK          = 0x0400;    

/** Share updates, limit cacheing.
Use this in mode flags for both nc_create() and nc_open(). */
enum NC_SHARE         = 0x0800;    

enum NC_NETCDF4       = 0x1000; /**< Use netCDF-4/HDF5 format. Mode flag for nc_create(). */

/** Turn on MPI I/O.
Use this in mode flags for both nc_create() and nc_open(). */
enum NC_MPIIO         = 0x2000; 
/** Turn on MPI POSIX I/O.
Use this in mode flags for both nc_create() and nc_open(). */
enum NC_MPIPOSIX      = 0x4000; /**< \deprecated As of libhdf5 1.8.13. */
enum NC_PNETCDF       = 0x8000; /**< Use parallel-netcdf library. Mode flag for nc_open(). */

/** Format specifier for nc_set_default_format() and returned
 * by nc_inq_format. This returns the format as provided by
 * the API. See nc_inq_format_extended to see the true file format.
 * Starting with version 3.6, there are different format netCDF files.
 * 4.0 introduces the third one. \see netcdf_format
 */
/**@{*/
enum NC_FORMAT_CLASSIC         = 1;
enum NC_FORMAT_64BIT           = 2;
enum NC_FORMAT_NETCDF4         = 3;
enum NC_FORMAT_NETCDF4_CLASSIC = 4;

/**@}*/

/** Extended format specifier returned by  nc_inq_format_extended() 
 * Added in version 4.3.1. This returns the true format of the
 * underlying data.
 * The function returns two values
 * 1. a small integer indicating the underlying source type
 * of the data. Note that this may differ from what the user
 * sees from nc_inq_format() because this latter function
 * returns what the user can expect to see thru the API.
 * 2. A mode value indicating what mode flags are effectively
 * set for this dataset. This usually will be a superset
 * of the mode flags used as the argument to nc_open
 * or nc_create.
 * More or less, the #1 values track the set of dispatch tables.
 * The #1 values are as follows.
 */
/**@{*/
enum NC_FORMAT_NC3       = 1;
enum NC_FORMAT_NC_HDF5   = 2; /*cdf 4 subset of HDF5 */
enum NC_FORMAT_NC_HDF4   = 3; /* netcdf 4 subset of HDF4 */
enum NC_FORMAT_PNETCDF   = 4;
enum NC_FORMAT_DAP2      = 5;
enum NC_FORMAT_DAP4      = 6;
enum NC_FORMAT_UNDEFINED = 0;
/**@}*/

/** Let nc__create() or nc__open() figure out a suitable buffer size. */
enum NC_SIZEHINT_DEFAULT = 0;

/** In nc__enddef(), align to the buffer size. */
enum size_t NC_ALIGN_CHUNK = -1;

/** Size argument to nc_def_dim() for an unlimited dimension. */
enum long NC_UNLIMITED = 0;

/** Attribute id to put/get a global attribute. */
enum NC_GLOBAL = -1;

/** 
Maximum for classic library.

In the classic netCDF model there are maximum values for the number of
dimensions in the file (\ref NC_MAX_DIMS), the number of global or per
variable attributes (\ref NC_MAX_ATTRS), the number of variables in
the file (\ref NC_MAX_VARS), and the length of a name (\ref
NC_MAX_NAME).

These maximums are enforced by the interface, to facilitate writing
applications and utilities.  However, nothing is statically allocated
to these sizes internally.

These maximums are not used for netCDF-4/HDF5 files unless they were
created with the ::NC_CLASSIC_MODEL flag.

As a rule, NC_MAX_VAR_DIMS <= NC_MAX_DIMS.
*/
/**@{*/
enum NC_MAX_DIMS     = 1024;    
enum NC_MAX_ATTRS    = 8192;   
enum NC_MAX_VARS     = 8192; 
enum NC_MAX_NAME     = 256;
enum NC_MAX_VAR_DIMS = 1024; /**< max per variable dimensions */
/**@}*/

/** This is the max size of an SD dataset name in HDF4 (from HDF4 documentation).*/
enum NC_MAX_HDF4_NAME = 64; 

/** In HDF5 files you can set the endianness of variables with
    nc_def_var_endian(). This define is used there. */   
/**@{*/
enum NC_ENDIAN_NATIVE = 0;
enum NC_ENDIAN_LITTLE = 1;
enum NC_ENDIAN_BIG    = 2;
/**@}*/

/** In HDF5 files you can set storage for each variable to be either
 * contiguous or chunked, with nc_def_var_chunking().  This define is
 * used there. */
/**@{*/
enum NC_CHUNKED    = 0;
enum NC_CONTIGUOUS = 1;
/**@}*/

/** In HDF5 files you can set check-summing for each variable.
Currently the only checksum available is Fletcher-32, which can be set
with the function nc_def_var_fletcher32.  These defines are used
there. */
/**@{*/
enum NC_NOCHECKSUM = 0;
enum NC_FLETCHER32 = 1;
/**@}*/

/**@{*/
/** Control the HDF5 shuffle filter. In HDF5 files you can specify
 * that a shuffle filter should be used on each chunk of a variable to
 * improve compression for that variable. This per-variable shuffle
 * property can be set with the function nc_def_var_deflate(). */
enum NC_NOSHUFFLE = 0;
enum NC_SHUFFLE   = 1;
/**@}*/

/** The netcdf version 3 functions all return integer error status.
 * These are the possible values, in addition to certain values from
 * the system errno.h.
 */
bool NC_ISSYSERR(int err) { return err > 0; }

enum NC_NOERR = 0;   /**< No Error */
enum NC2_ERR  = -1;  /**< Returned for all errors in the v2 API. */

/** Not a netcdf id.

The specified netCDF ID does not refer to an
open netCDF dataset. */
enum NC_EBADID = -33;       
enum NC_ENFILE = -34; /**< Too many netcdfs open */
enum NC_EEXIST = -35; /**< netcdf file exists && NC_NOCLOBBER */
enum NC_EINVAL = -36; /**< Invalid Argument */
enum NC_EPERM  = -37; /**< Write to read only */

/** Operation not allowed in data mode. This is returned for netCDF
classic or 64-bit offset files, or for netCDF-4 files, when they were
been created with ::NC_CLASSIC_MODEL flag in nc_create(). */
enum NC_ENOTINDEFINE = -38;       

/** Operation not allowed in define mode.

The specified netCDF is in define mode rather than data mode. 

With netCDF-4/HDF5 files, this error will not occur, unless
::NC_CLASSIC_MODEL was used in nc_create().
 */
enum NC_EINDEFINE = -39;       

/** Index exceeds dimension bound.

The specified corner indices were out of range for the rank of the
specified variable. For example, a negative index or an index that is
larger than the corresponding dimension length will cause an error. */
enum NC_EINVALCOORDS = -40;       
enum NC_EMAXDIMS     = -41;       /**< NC_MAX_DIMS exceeded */
enum NC_ENAMEINUSE   = -42;       /**< String match to name in use */
enum NC_ENOTATT      = -43;       /**< Attribute not found */
enum NC_EMAXATTS     = -44;       /**< NC_MAX_ATTRS exceeded */
enum NC_EBADTYPE     = -45;       /**< Not a netcdf data type */
enum NC_EBADDIM      = -46;       /**< Invalid dimension id or name */
enum NC_EUNLIMPOS    = -47;       /**< NC_UNLIMITED in the wrong index */

/** NC_MAX_VARS exceeded. Max number of variables exceeded in a
classic or 64-bit offset file, or an netCDF-4 file with
::NC_CLASSIC_MODEL on. */
enum NC_EMAXVARS = -48;       

/** Variable not found.

The variable ID is invalid for the specified netCDF dataset. */
enum NC_ENOTVAR    = -49;       
enum NC_EGLOBAL    = -50;       /**< Action prohibited on NC_GLOBAL varid */
enum NC_ENOTNC     = -51;       /**< Not a netcdf file */
enum NC_ESTS       = -52;       /**< In Fortran, string too short* /
enum NC_EMAXNAME   = -53;       /**< NC_MAX_NAME exceeded */
enum NC_EUNLIMIT   = -54;       /**< NC_UNLIMITED size already in use */
enum NC_ENORECVARS = -55;       /**< nc_rec op when there are no record vars */
enum NC_ECHAR      = -56;       /**< Attempt to convert between text & numbers */

/** Start+count exceeds dimension bound.

The specified edge lengths added to the specified corner would have
referenced data out of range for the rank of the specified
variable. For example, an edge length that is larger than the
corresponding dimension length minus the corner index will cause an
error. */
enum NC_EEDGE    = -57;       
enum NC_ESTRIDE  = -58;       /**< Illegal stride */
enum NC_EBADNAME = -59;       /**< Attribute or variable name contains illegal characters */
/* N.B. following must match value in ncx.h */

/** Math result not representable.

One or more of the values are out of the range of values representable
by the desired type. */
enum NC_ERANGE    = -60;       
enum NC_ENOMEM    = -61;       /**< Memory allocation (malloc) failure */
enum NC_EVARSIZE  = -62;      /**< One or more variable sizes violate format constraints */ 
enum NC_EDIMSIZE  = -63;      /**< Invalid dimension size */
enum NC_ETRUNC    = -64;      /**< File likely truncated or possibly corrupted */
enum NC_EAXISTYPE = -65;      /**< Unknown axis type. */

/* Following errors are added for DAP */
enum NC_EDAP           = -66;      /**< Generic DAP error */
enum NC_ECURL          = -67;      /**< Generic libcurl error */
enum NC_EIO            = -68;      /**< Generic IO error */
enum NC_ENODATA        = -69;      /**< Attempt to access variable with no data */
enum NC_EDAPSVC        = -70;      /**< DAP server error */
enum NC_EDAS           = -71;      /**< Malformed or inaccessible DAS */
enum NC_EDDS           = -72;      /**< Malformed or inaccessible DDS */
enum NC_EDATADDS       = -73;      /**< Malformed or inaccessible DATADDS */
enum NC_EDAPURL        = -74;      /**< Malformed DAP URL */
enum NC_EDAPCONSTRAINT = -75;    /**< Malformed DAP Constraint*/
enum NC_ETRANSLATION   = -76;      /**< Untranslatable construct */
enum NC_EACCESS        = -77;      /**< Access Failure */
enum NC_EAUTH          = -78;      /**< Authorization Failure */

/* Misc. additional errors */
enum NC_ENOTFOUND   = -90;      /**< No such file */
enum NC_ECANTREMOVE = -91;      /**< Can't remove file */

/* The following was added in support of netcdf-4. Make all netcdf-4
   error codes < -100 so that errors can be added to netcdf-3 if
   needed. */
enum NC4_FIRST_ERROR = -100;

/** Error at HDF5 layer. */
enum NC_EHDFERR     = -101;    
enum NC_ECANTREAD   = -102;    /**< Can't read. */
enum NC_ECANTWRITE  = -103;    /**< Can't write. */
enum NC_ECANTCREATE = -104;    /**< Can't create. */
enum NC_EFILEMETA   = -105;    /**< Problem with file metadata. */
enum NC_EDIMMETA    = -106;    /**< Problem with dimension metadata. */
enum NC_EATTMETA    = -107;    /**< Problem with attribute metadata. */
enum NC_EVARMETA    = -108;    /**< Problem with variable metadata. */
enum NC_ENOCOMPOUND = -109;    /**< Not a compound type. */
enum NC_EATTEXISTS  = -110;    /**< Attribute already exists. */
enum NC_ENOTNC4     = -111;    /**< Attempting netcdf-4 operation on netcdf-3 file. */  

/** Attempting netcdf-4 operation on strict nc3 netcdf-4 file. */  
enum NC_ESTRICTNC3  = -112;    
enum NC_ENOTNC3     = -113;    /**< Attempting netcdf-3 operation on netcdf-4 file. */  
enum NC_ENOPAR      = -114;    /**< Parallel operation on file opened for non-parallel access. */  
enum NC_EPARINIT    = -115;    /**< Error initializing for parallel access. */  
enum NC_EBADGRPID   = -116;    /**< Bad group ID. */  
enum NC_EBADTYPID   = -117;    /**< Bad type ID. */  
enum NC_ETYPDEFINED = -118;    /**< Type has already been defined and may not be edited. */
enum NC_EBADFIELD   = -119;    /**< Bad field ID. */  
enum NC_EBADCLASS   = -120;    /**< Bad class. */  
enum NC_EMAPTYPE    = -121;    /**< Mapped access for atomic types only. */  
enum NC_ELATEFILL   = -122;    /**< Attempt to define fill value when data already exists. */
enum NC_ELATEDEF    = -123;    /**< Attempt to define var properties, like deflate, after enddef. */
enum NC_EDIMSCALE   = -124;    /**< Probem with HDF5 dimscales. */
enum NC_ENOGRP      = -125;    /**< No group found. */
enum NC_ESTORAGE    = -126;    /**< Can't specify both contiguous and chunking. */
enum NC_EBADCHUNK   = -127;    /**< Bad chunksize. */
enum NC_ENOTBUILT   = -128;    /**< Attempt to use feature that was not turned on when netCDF was built. */
enum NC_EDISKLESS   = -129;    /**< Error in using diskless  access. */ 
enum NC_ECANTEXTEND = -130;    /**< Attempt to extend dataset during ind. I/O operation. */ 
enum NC_EMPI        = -131;    /**< MPI operation failed. */ 

enum NC4_LAST_ERROR = -131; 

/* This is used in netCDF-4 files for dimensions without coordinate
 * vars. */
@property char* DIM_WITHOUT_VARIABLE() { return DIM_WITHOUT_VARIABLEStr.ptr; }
private __gshared static char[53] DIM_WITHOUT_VARIABLEStr= "This is a netCDF dimension but not a netCDF variable.";

/* This is here at the request of the NCO team to support our
 * mistake of having chunksizes be first ints, then size_t. Doh! */
enum NC_HAVE_NEW_CHUNKING_API = 1;


/*Errors for all remote access methods(e.g. DAP and CDMREMOTE)*/
enum NC_EURL        = NC_EDAPURL;   /* Malformed URL */
enum NC_ECONSTRAINT = NC_EDAPCONSTRAINT;   /* Malformed Constraint*/

/*
 * The Interface
 */

version(DLL_NETCDF) /* define when library is a DLL */
{
    int ncerr;
    int ncopts;
}

const(char)* nc_inq_libvers();

const(char)* nc_strerror(int ncerr);

int nc__create(const(char)* path, int cmode, size_t initialsz,
        size_t* chunksizehintp, int* ncidp);

int nc_create(const(char)* path, int cmode, int* ncidp);

int nc__open(const(char)* path, int mode, 
        size_t* chunksizehintp, int* ncidp);

int nc_open(const(char)* path, int mode, int* ncidp);

/* Learn the path used to open/create the file. */
int nc_inq_path(int ncid, size_t* pathlen, char* path);

/* Given an ncid and group name (NULL gets root group), return
 * locid. */
int nc_inq_ncid(int ncid, const(char)* name, int* grp_ncid);

/* Given a location id, return the number of groups it contains, and
 * an array of their locids. */
int nc_inq_grps(int ncid, int* numgrps, int* ncids);

/* Given locid, find name of group. (Root group is named "/".) */
int nc_inq_grpname(int ncid, char* name);

/* Given ncid, find full name and len of full name. (Root group is
 * named "/", with length 1.) */
int nc_inq_grpname_full(int ncid, size_t* lenp, char* full_name);

/* Given ncid, find len of full name. */
int nc_inq_grpname_len(int ncid, size_t* lenp);

/* Given an ncid, find the ncid of its parent group. */
int nc_inq_grp_parent(int ncid, int* parent_ncid);

/* Given a name and parent ncid, find group ncid. */
int nc_inq_grp_ncid(int ncid, const(char)* grp_name, int* grp_ncid);

/* Given a full name and ncid, find group ncid. */
int nc_inq_grp_full_ncid(int ncid, const(char)* full_name, int* grp_ncid);

/* Get a list of ids for all the variables in a group. */
int nc_inq_varids(int ncid, int* nvars, int* varids);

/* Find all dimids for a location. This finds all dimensions in a
 * group, or any of its parents. */
int nc_inq_dimids(int ncid, int* ndims, int* dimids, int include_parents);

/* Find all user-defined types for a location. This finds all
 * user-defined types in a group. */
int nc_inq_typeids(int ncid, int* ntypes, int* typeids);

/* Are two types equal? */
int nc_inq_type_equal(int ncid1, nc_type typeid1, int ncid2, 
        nc_type typeid2, int* equal);

/* Create a group. its ncid is returned in the new_ncid pointer. */
int nc_def_grp(int parent_ncid, const(char)* name, int* new_ncid);

/* Rename a group */
int nc_rename_grp(int grpid, const(char)* name);

/* Here are functions for dealing with compound types. */

/* Create a compound type. */
int nc_def_compound(int ncid, size_t size, const(char)* name, nc_type* typeidp);

/* Insert a named field into a compound type. */
int nc_insert_compound(int ncid, nc_type xtype, const(char)* name, 
        size_t offset, nc_type field_typeid);

/* Insert a named array into a compound type. */
int nc_insert_array_compound(int ncid, nc_type xtype, const(char)* name, 
        size_t offset, nc_type field_typeid,
        int ndims, const(int)* dim_sizes);

/* Get the name and size of a type. */
int nc_inq_type(int ncid, nc_type xtype, char* name, size_t* size);

/* Get the id of a type from the name. */
int nc_inq_typeid(int ncid, const(char)* name, nc_type* typeidp);

/* Get the name, size, and number of fields in a compound type. */
int nc_inq_compound(int ncid, nc_type xtype, char* name, size_t* sizep, 
        size_t* nfieldsp);

/* Get the name of a compound type. */
int nc_inq_compound_name(int ncid, nc_type xtype, char* name);

/* Get the size of a compound type. */
int nc_inq_compound_size(int ncid, nc_type xtype, size_t* sizep);

/* Get the number of fields in this compound type. */
int nc_inq_compound_nfields(int ncid, nc_type xtype, size_t* nfieldsp);

/* Given the xtype and the fieldid, get all info about it. */
int nc_inq_compound_field(int ncid, nc_type xtype, int fieldid, char* name, 
        size_t* offsetp, nc_type* field_typeidp, int* ndimsp, 
        int* dim_sizesp);

/* Given the typeid and the fieldid, get the name. */
int nc_inq_compound_fieldname(int ncid, nc_type xtype, int fieldid, 
        char* name);

/* Given the xtype and the name, get the fieldid. */
int nc_inq_compound_fieldindex(int ncid, nc_type xtype, const(char)* name, 
        int* fieldidp);

/* Given the xtype and fieldid, get the offset. */
int nc_inq_compound_fieldoffset(int ncid, nc_type xtype, int fieldid, 
        size_t* offsetp);

/* Given the xtype and the fieldid, get the type of that field. */
int nc_inq_compound_fieldtype(int ncid, nc_type xtype, int fieldid, 
        nc_type* field_typeidp);

/* Given the xtype and the fieldid, get the number of dimensions for
 * that field (scalars are 0). */
int nc_inq_compound_fieldndims(int ncid, nc_type xtype, int fieldid, 
        int* ndimsp);

/* Given the xtype and the fieldid, get the sizes of dimensions for
 * that field. User must have allocated storage for the dim_sizes. */
int nc_inq_compound_fielddim_sizes(int ncid, nc_type xtype, int fieldid, 
        int* dim_sizes);

/** This is the type of arrays of vlens. */
struct nc_vlen_t
{
    size_t len; /**< Length of VL data (in base type units) */
    void* p;    /**< Pointer to VL data */
}

/** Calculate an offset for creating a compound type. This calls a
 * mysterious C macro which was found carved into one of the blocks of
 * the Newgrange passage tomb in County Meath, Ireland. This code has
 * been carbon dated to 3200 B.C.E. */
/// D specific just use S.M.offsetof instead

/* Create a variable length type. */
int nc_def_vlen(int ncid, const(char)* name, nc_type base_typeid, nc_type* xtypep);

/* Find out about a vlen. */
int nc_inq_vlen(int ncid, nc_type xtype, char* name, size_t* datum_sizep, 
        nc_type* base_nc_typep);

/* When you read VLEN type the library will actually allocate the
 * storage space for the data. This storage space must be freed, so
 * pass the pointer back to this function, when you're done with the
 * data, and it will free the vlen memory. */
int nc_free_vlen(nc_vlen_t* vl);

int nc_free_vlens(size_t len, nc_vlen_t* vlens);

/* Put or get one element in a vlen array. */
int nc_put_vlen_element(int ncid, int typeid1, void* vlen_element, 
        size_t len, const(void)* data);

int nc_get_vlen_element(int ncid, int typeid1, const(void)* vlen_element, 
        size_t* len, void* data);

/* When you read the string type the library will allocate the storage
 * space for the data. This storage space must be freed, so pass the
 * pointer back to this function, when you're done with the data, and
 * it will free the string memory. */
int nc_free_string(size_t len, char** data);

/* Find out about a user defined type. */
int nc_inq_user_type(int ncid, nc_type xtype, char* name, size_t* size, 
        nc_type* base_nc_typep, size_t* nfieldsp, int* classp);

/* Write an attribute of any type. */
int nc_put_att(int ncid, int varid, const(char)* name, nc_type xtype, 
        size_t len, const(void)* op);

/* Read an attribute of any type. */
int nc_get_att(int ncid, int varid, const(char)* name, void* ip);

/* Enum type. */

/* Create an enum type. Provide a base type and a name. At the moment
 * only ints are accepted as base types. */
int nc_def_enum(int ncid, nc_type base_typeid, const(char)* name, 
        nc_type* typeidp);

/* Insert a named value into an enum type. The value must fit within
 * the size of the enum type, the name size must be <= NC_MAX_NAME. */
int nc_insert_enum(int ncid, nc_type xtype, const(char)* name, 
        const(void)* value);

/* Get information about an enum type: its name, base type and the
 * number of members defined. */
int nc_inq_enum(int ncid, nc_type xtype, char* name, nc_type* base_nc_typep, 
        size_t* base_sizep, size_t* num_membersp);

/* Get information about an enum member: a name and value. Name size
 * will be <= NC_MAX_NAME. */
int nc_inq_enum_member(int ncid, nc_type xtype, int idx, char* name, 
        void* value);


/* Get enum name from enum value. Name size will be <= NC_MAX_NAME. */
int nc_inq_enum_ident(int ncid, nc_type xtype, c_long value, char* identifier);

/* Opaque type. */

/* Create an opaque type. Provide a size and a name. */
int nc_def_opaque(int ncid, size_t size, const(char)* name, nc_type* xtypep);

/* Get information about an opaque type. */
int nc_inq_opaque(int ncid, nc_type xtype, char* name, size_t* sizep);

/* Write entire var of any type. */
int nc_put_var(int ncid, int varid, const(void)* op);

/* Read entire var of any type. */
int nc_get_var(int ncid, int varid, void* ip);

/* Write one value. */
int nc_put_var1(int ncid, int varid, const(size_t)* indexp,
        const(void)* op);

/* Read one value. */
int nc_get_var1(int ncid, int varid, const(size_t)* indexp, void* ip);

/* Write an array of values. */
int nc_put_vara(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(void)* op);

/* Read an array of values. */
int nc_get_vara(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, void* ip);

/* Write slices of an array of values. */
int nc_put_vars(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(void)* op);

/* Read slices of an array of values. */
int nc_get_vars(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        void* ip);

/* Write mapped slices of an array of values. */
int nc_put_varm(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(void)* op);

/* Read mapped slices of an array of values. */
int nc_get_varm(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, void* ip);

/* Extra netcdf-4 stuff. */

/* Set compression settings for a variable. Lower is faster, higher is
 * better. Must be called after nc_def_var and before nc_enddef. */
int nc_def_var_deflate(int ncid, int varid, int shuffle, int deflate, 
        int deflate_level);

/* Find out compression settings of a var. */
int nc_inq_var_deflate(int ncid, int varid, int* shufflep, 
        int* deflatep, int* deflate_levelp);

/* Find out szip settings of a var. */
int nc_inq_var_szip(int ncid, int varid, int* options_maskp, int* pixels_per_blockp);

/* Set fletcher32 checksum for a var. This must be done after nc_def_var
   and before nc_enddef. */
int nc_def_var_fletcher32(int ncid, int varid, int fletcher32);

/* Inquire about fletcher32 checksum for a var. */
int nc_inq_var_fletcher32(int ncid, int varid, int* fletcher32p);

/* Define chunking for a variable. This must be done after nc_def_var
   and before nc_enddef. */
int nc_def_var_chunking(int ncid, int varid, int storage, const(size_t)* chunksizesp);

/* Inq chunking stuff for a var. */
int nc_inq_var_chunking(int ncid, int varid, int* storagep, size_t* chunksizesp);

/* Define fill value behavior for a variable. This must be done after
   nc_def_var and before nc_enddef. */
int nc_def_var_fill(int ncid, int varid, int no_fill, const(void)* fill_value);

/* Inq fill value setting for a var. */
int nc_inq_var_fill(int ncid, int varid, int* no_fill, void* fill_valuep);

/* Define the endianness of a variable. */
int nc_def_var_endian(int ncid, int varid, int endian);

/* Learn about the endianness of a variable. */
int nc_inq_var_endian(int ncid, int varid, int* endianp);

/* Set the fill mode (classic or 64-bit offset files only). */
int nc_set_fill(int ncid, int fillmode, int* old_modep);

/* Set the default nc_create format to NC_FORMAT_CLASSIC,
 * NC_FORMAT_64BIT, NC_FORMAT_NETCDF4, NC_FORMAT_NETCDF4_CLASSIC. */
int nc_set_default_format(int format, int* old_formatp);

/* Set the cache size, nelems, and preemption policy. */
int nc_set_chunk_cache(size_t size, size_t nelems, float preemption);

/* Get the cache size, nelems, and preemption policy. */
int nc_get_chunk_cache(size_t* sizep, size_t* nelemsp, float* preemptionp);

/* Set the per-variable cache size, nelems, and preemption policy. */
int nc_set_var_chunk_cache(int ncid, int varid, size_t size, size_t nelems, 
        float preemption);

/* Set the per-variable cache size, nelems, and preemption policy. */
int nc_get_var_chunk_cache(int ncid, int varid, size_t* sizep, size_t* nelemsp, 
        float* preemptionp);

int nc_redef(int ncid);

/* Is this ever used? */
int nc__enddef(int ncid, size_t h_minfree, size_t v_align,
        size_t v_minfree, size_t r_align);

int nc_enddef(int ncid);

int nc_sync(int ncid);

int nc_abort(int ncid);

int nc_close(int ncid);

int nc_inq(int ncid, int* ndimsp, int* nvarsp, int* nattsp, int* unlimdimidp);

int nc_inq_ndims(int ncid, int* ndimsp);

int nc_inq_nvars(int ncid, int* nvarsp);

int nc_inq_natts(int ncid, int* nattsp);

int nc_inq_unlimdim(int ncid, int* unlimdimidp);

/* The next function is for NetCDF-4 only */
int nc_inq_unlimdims(int ncid, int* nunlimdimsp, int* unlimdimidsp);

/* Added in 3.6.1 to return format of netCDF file. */
int nc_inq_format(int ncid, int* formatp);

/* Added in 4.3.1 to return additional format info */
int nc_inq_format_extended(int ncid, int* formatp, int* modep);

/* Begin _dim */

int nc_def_dim(int ncid, const(char)* name, size_t len, int* idp);

int nc_inq_dimid(int ncid, const(char)* name, int* idp);

int nc_inq_dim(int ncid, int dimid, char* name, size_t* lenp);

int nc_inq_dimname(int ncid, int dimid, char* name);

int nc_inq_dimlen(int ncid, int dimid, size_t* lenp);

int nc_rename_dim(int ncid, int dimid, const(char)* name);

/* End _dim */
/* Begin _att */

int nc_inq_att(int ncid, int varid, const(char)* name,
        nc_type* xtypep, size_t* lenp);

int nc_inq_attid(int ncid, int varid, const(char)* name, int* idp);

int nc_inq_atttype(int ncid, int varid, const(char)* name, nc_type* xtypep);

int nc_inq_attlen(int ncid, int varid, const(char)* name, size_t* lenp);

int nc_inq_attname(int ncid, int varid, int attnum, char* name);

int nc_copy_att(int ncid_in, int varid_in, const(char)* name, int ncid_out, int varid_out);

int nc_rename_att(int ncid, int varid, const(char)* name, const(char)* newname);

int nc_del_att(int ncid, int varid, const(char)* name);

/* End _att */
/* Begin {put,get}_att */

int nc_put_att_text(int ncid, int varid, const(char)* name,
        size_t len, const(char)* op);

int nc_get_att_text(int ncid, int varid, const(char)* name, char* ip);

int nc_put_att_ubyte(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(ubyte)* op);

int nc_get_att_ubyte(int ncid, int varid, const(char)* name, ubyte* ip);

int nc_put_att_schar(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(byte)* op);

int nc_get_att_schar(int ncid, int varid, const(char)* name, byte* ip);

int nc_put_att_short(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(short)* op);

int nc_get_att_short(int ncid, int varid, const(char)* name, short* ip);

int nc_put_att_int(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(int)* op);

int nc_get_att_int(int ncid, int varid, const(char)* name, int* ip);

int nc_put_att_long(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(c_long)* op);

int nc_get_att_long(int ncid, int varid, const(char)* name, c_long* ip);

int nc_put_att_float(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(float)* op);

int nc_get_att_float(int ncid, int varid, const(char)* name, float* ip);

int nc_put_att_double(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(double)* op);

int nc_get_att_double(int ncid, int varid, const(char)* name, double* ip);

int nc_put_att_ushort(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(ushort)* op);

int nc_get_att_ushort(int ncid, int varid, const(char)* name, ushort* ip);

int nc_put_att_uint(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(uint)* op);

int nc_get_att_uint(int ncid, int varid, const(char)* name, uint* ip);

int nc_put_att_longlong(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(long)* op);

int nc_get_att_longlong(int ncid, int varid, const(char)* name, long* ip);

int nc_put_att_ulonglong(int ncid, int varid, const(char)* name, nc_type xtype,
        size_t len, const(ulong)* op);

int nc_get_att_ulonglong(int ncid, int varid, const(char)* name, 
        ulong* ip);

int nc_put_att_string(int ncid, int varid, const(char)* name, 
        size_t len, const(char)** op);

int nc_get_att_string(int ncid, int varid, const(char)* name, char** ip);

/* End {put,get}_att */
/* Begin _var */

int nc_def_var(int ncid, const(char)* name, nc_type xtype, int ndims, 
        const(int)* dimidsp, int* varidp);

int nc_inq_var(int ncid, int varid, char* name, nc_type* xtypep, 
        int* ndimsp, int* dimidsp, int* nattsp);

int nc_inq_varid(int ncid, const(char)* name, int* varidp);

int nc_inq_varname(int ncid, int varid, char* name);

int nc_inq_vartype(int ncid, int varid, nc_type* xtypep);

int nc_inq_varndims(int ncid, int varid, int* ndimsp);

int nc_inq_vardimid(int ncid, int varid, int* dimidsp);

int nc_inq_varnatts(int ncid, int varid, int* nattsp);

int nc_rename_var(int ncid, int varid, const(char)* name);

int nc_copy_var(int ncid_in, int varid, int ncid_out);

/* End _var */
/* Begin {put,get}_var1 */

int nc_put_var1_text(int ncid, int varid, const(size_t)* indexp, const(char)* op);

int nc_get_var1_text(int ncid, int varid, const(size_t)* indexp, char* ip);

int nc_put_var1_ubyte(int ncid, int varid, const(size_t)* indexp,
        const(ubyte)* op);

int nc_get_var1_ubyte(int ncid, int varid, const(size_t)* indexp,
        ubyte* ip);

int nc_put_var1_schar(int ncid, int varid, const(size_t)* indexp,
        const(byte)* op);

int nc_get_var1_schar(int ncid, int varid, const(size_t)* indexp,
        byte* ip);

int nc_put_var1_short(int ncid, int varid, const(size_t)* indexp,
        const(short)* op);

int nc_get_var1_short(int ncid, int varid, const(size_t)* indexp,
        short* ip);

int nc_put_var1_int(int ncid, int varid, const(size_t)* indexp, const(int)* op);

int nc_get_var1_int(int ncid, int varid, const(size_t)* indexp, int* ip);

int nc_put_var1_long(int ncid, int varid, const(size_t)* indexp, const(c_long)* op);

int nc_get_var1_long(int ncid, int varid, const(size_t)* indexp, c_long* ip);

int nc_put_var1_float(int ncid, int varid, const(size_t)* indexp, const(float)* op);

int nc_get_var1_float(int ncid, int varid, const(size_t)* indexp, float* ip);

int nc_put_var1_double(int ncid, int varid, const(size_t)* indexp, const(double)* op);

int nc_get_var1_double(int ncid, int varid, const(size_t)* indexp, double* ip);

int nc_put_var1_ushort(int ncid, int varid, const(size_t)* indexp, 
        const(ushort)* op);

int nc_get_var1_ushort(int ncid, int varid, const(size_t)* indexp, 
        ushort* ip);

int nc_put_var1_uint(int ncid, int varid, const(size_t)* indexp, 
        const(uint)* op);

int nc_get_var1_uint(int ncid, int varid, const(size_t)* indexp, 
        uint* ip);

int nc_put_var1_longlong(int ncid, int varid, const(size_t)* indexp, 
        const(long)* op);

int nc_get_var1_longlong(int ncid, int varid, const(size_t)* indexp, 
        long* ip);

int nc_put_var1_ulonglong(int ncid, int varid, const(size_t)* indexp, 
        const(ulong)* op);

int nc_get_var1_ulonglong(int ncid, int varid, const(size_t)* indexp, 
        const(ulong)* ip);

int nc_put_var1_string(int ncid, int varid, const(size_t)* indexp, 
        const(char)** op);

int nc_get_var1_string(int ncid, int varid, const(size_t)* indexp, 
        char** ip);

/* End {put,get}_var1 */
/* Begin {put,get}_vara */

int nc_put_vara_text(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(char)* op);

int nc_get_vara_text(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, char* ip);

int nc_put_vara_ubyte(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ubyte)* op);

int nc_get_vara_ubyte(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, ubyte* ip);

int nc_put_vara_schar(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(byte)* op);

int nc_get_vara_schar(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, byte* ip);

int nc_put_vara_short(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(short)* op);

int nc_get_vara_short(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, short* ip);

int nc_put_vara_int(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(int)* op);

int nc_get_vara_int(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, int* ip);

int nc_put_vara_long(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(c_long)* op);

int nc_get_vara_long(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, c_long* ip);

int nc_put_vara_float(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(float)* op);

int nc_get_vara_float(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, float* ip);

int nc_put_vara_double(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(double)* op);

int nc_get_vara_double(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, double* ip);

int nc_put_vara_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ushort)* op);

int nc_get_vara_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, ushort* ip);

int nc_put_vara_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(uint)* op);

int nc_get_vara_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, uint* ip);

int nc_put_vara_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(long)* op);

int nc_get_vara_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, long* ip);

int nc_put_vara_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ulong)* op);

int nc_get_vara_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, ulong* ip);

int nc_put_vara_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(char)** op);

int nc_get_vara_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, char** ip);

/* End {put,get}_vara */
/* Begin {put,get}_vars */

int nc_put_vars_text(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(char)* op);

int nc_get_vars_text(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        char* ip);

int nc_put_vars_ubyte(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ubyte)* op);

int nc_get_vars_ubyte(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        ubyte* ip);

int nc_put_vars_schar(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(byte)* op);

int nc_get_vars_schar(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        byte* ip);

int nc_put_vars_short(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(short)* op);

int nc_get_vars_short(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        short* ip);

int nc_put_vars_int(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(int)* op);

int nc_get_vars_int(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        int* ip);

int nc_put_vars_long(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(c_long)* op);

int nc_get_vars_long(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        c_long* ip);

int nc_put_vars_float(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(float)* op);

int nc_get_vars_float(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        float* ip);

int nc_put_vars_double(int ncid, int varid,
        const(size_t)* startp, const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(double)* op);

int nc_get_vars_double(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        double* ip);

int nc_put_vars_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ushort)* op);

int nc_get_vars_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        ushort* ip);

int nc_put_vars_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(uint)* op);

int nc_get_vars_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        uint* ip);

int nc_put_vars_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(long)* op);

int nc_get_vars_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        long* ip);

int nc_put_vars_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ulong)* op);

int nc_get_vars_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        ulong* ip);

int nc_put_vars_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(char)** op);

int nc_get_vars_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        char** ip);

/* End {put,get}_vars */
/* Begin {put,get}_varm */

int nc_put_varm_text(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(char)* op);

int nc_get_varm_text(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, char* ip);

int nc_put_varm_ubyte(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(ubyte)* op);

int nc_get_varm_ubyte(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, ubyte* ip);

int nc_put_varm_schar(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(byte)* op);

int nc_get_varm_schar(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, byte* ip);

int nc_put_varm_short(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(short)* op);

int nc_get_varm_short(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, short* ip);

int nc_put_varm_int(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(int)* op);

int nc_get_varm_int(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, int* ip);

int nc_put_varm_long(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(c_long)* op);

int nc_get_varm_long(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, c_long* ip);

int nc_put_varm_float(int ncid, int varid,const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(float)* op);

int nc_get_varm_float(int ncid, int varid,const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, float* ip);

int nc_put_varm_double(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, const(double)* op);

int nc_get_varm_double(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep,
        const(ptrdiff_t)* imapp, double* ip);

int nc_put_varm_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, const(ushort)* op);

int nc_get_varm_ushort(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, ushort* ip);

int nc_put_varm_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, const(uint)* op);

int nc_get_varm_uint(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, uint* ip);

int nc_put_varm_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, const long* op);

int nc_get_varm_longlong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, long* ip);

int nc_put_varm_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, const(ulong)* op);

int nc_get_varm_ulonglong(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, ulong* ip);

int nc_put_varm_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, const(char)** op);

int nc_get_varm_string(int ncid, int varid, const(size_t)* startp, 
        const(size_t)* countp, const(ptrdiff_t)* stridep, 
        const(ptrdiff_t)* imapp, char** ip);

/* End {put,get}_varm */
/* Begin {put,get}_var */

int nc_put_var_text(int ncid, int varid, const(char)* op);

int nc_get_var_text(int ncid, int varid, char* ip);

int nc_put_var_ubyte(int ncid, int varid, const(ubyte)* op);

int nc_get_var_ubyte(int ncid, int varid, ubyte* ip);

int nc_put_var_schar(int ncid, int varid, const(byte)* op);

int nc_get_var_schar(int ncid, int varid, byte* ip);

int nc_put_var_short(int ncid, int varid, const(short)* op);

int nc_get_var_short(int ncid, int varid, short* ip);

int nc_put_var_int(int ncid, int varid, const(int)* op);

int nc_get_var_int(int ncid, int varid, int* ip);

int nc_put_var_long(int ncid, int varid, const(c_long)* op);

int nc_get_var_long(int ncid, int varid, c_long* ip);

int nc_put_var_float(int ncid, int varid, const(float)* op);

int nc_get_var_float(int ncid, int varid, float* ip);

int nc_put_var_double(int ncid, int varid, const(double)* op);

int nc_get_var_double(int ncid, int varid, double* ip);

int nc_put_var_ushort(int ncid, int varid, const(ushort)* op);

int nc_get_var_ushort(int ncid, int varid, ushort* ip);

int nc_put_var_uint(int ncid, int varid, const(uint)* op);

int nc_get_var_uint(int ncid, int varid, uint* ip);

int nc_put_var_longlong(int ncid, int varid, const(long)* op);

int nc_get_var_longlong(int ncid, int varid, long* ip);

int nc_put_var_ulonglong(int ncid, int varid, const(ulong)* op);

int nc_get_var_ulonglong(int ncid, int varid, ulong* ip);

int nc_put_var_string(int ncid, int varid, const(char)** op);

int nc_get_var_string(int ncid, int varid, char** ip);

/* Use this to turn off logging by calling
   nc_log_level(NC_TURN_OFF_LOGGING) */
enum NC_TURN_OFF_LOGGING = -1;
    
version(LOGGING)
{
    /* Set the log level. 0 shows only errors, 1 only major messages,
     * etc., to 5, which shows way too much information. */
    int nc_set_log_level(int new_level);    
}
else
{
    //no-op
    int nc_set_log_level(int new_level) { return 0; }
}    

/* Show the netCDF library's in-memory metadata for a file. */
int nc_show_metadata(int ncid);

/* End {put,get}_var */

/* #ifdef _CRAYMPP */
/*
 * Public interfaces to better support
 * CRAY multi-processor systems like T3E.
 * A tip of the hat to NERSC.
 */
/*
 * It turns out we need to declare and define
 * these public interfaces on all platforms
 * or things get ugly working out the
 * FORTRAN interface. On !_CRAYMPP platforms,
 * these functions work as advertised, but you
 * can only use "processor element" 0.
 */

int nc__create_mp(const(char)* path, int cmode, size_t initialsz, int basepe,
        size_t* chunksizehintp, int* ncidp);

int nc__open_mp(const(char)* path, int mode, int basepe,
        size_t* chunksizehintp, int* ncidp);

int nc_delete(const(char)* path);

int nc_delete_mp(const(char)* path, int basepe);

int nc_set_base_pe(int ncid, int pe);

int nc_inq_base_pe(int ncid, int* pe);

/* #endif _CRAYMPP */
