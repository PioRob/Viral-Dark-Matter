function set_cset(type_id, cset)
%H5T.set_cset  Set character dataset for string datatype.
%   H5T.set_cset(type_id, cset) sets the character encoding used to create
%   strings.  The only valid type is H5T_CSET_ASCII.
%
%   Example:
%       type_id = H5T.copy('H5T_C_S1');
%       H5T.set_size(type_id,10);
%       encoding = H5ML.get_constant_value('H5T_CSET_ASCII');
%       H5T.set_cset(type_id,encoding);
%
%   See also H5T, H5T.get_cset.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:44 $

[id] = H5ML.unwrap_ids(type_id);
H5ML.hdf5lib2('H5Tset_cset',id, cset); 
