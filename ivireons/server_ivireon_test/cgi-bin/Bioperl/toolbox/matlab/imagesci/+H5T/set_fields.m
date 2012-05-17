function set_fields(type_id, spos, epos, esize, mpos, msize)
%H5T.set_fields  Set sizes and locations of floating point bit fields.
%   H5T.set_fields(type_id, spos, epos, esize, mpos, msize) sets the
%   locations and sizes of the various floating-point bit fields. spos is
%   the sign position. epos is the exponent in bits. esize is the size of
%   exponent in bits. mpos is the mantissa bit position. msize is the size
%   of the mantissa in bits.
%
%   Example:
%       type_id = H5T.copy('H5T_NATIVE_DOUBLE');
%       H5T.set_fields(type_id,30,24,6,0,2);
%
%   See also H5T, H5T.get_fields.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:46 $

[id] = H5ML.unwrap_ids(type_id);
H5ML.hdf5lib2('H5Tset_fields',id, spos, epos, esize, mpos, msize); 
