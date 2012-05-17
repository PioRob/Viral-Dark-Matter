function set_order(type_id, order)
%H5T.set_order  Set byte ordering of atomic datatype.
%   H5T.set_order(type_id, type_order) sets the byte ordering of an atomic 
%   datatype.  type_order can be one of the following values:
%   
%       H5T_ORDER_LE 
%       H5T_ORDER_BE 
%       H5T_ORDER_VAX
%
%   Example:  create a big endian 32-bit integer type.
%       type_id = H5T.copy('H5T_NATIVE_INT');
%       order = H5ML.get_constant_value('H5T_ORDER_BE');
%       H5T.set_order(type_id,order);
%
%   See also H5T, H5T.get_order, H5ML.get_constant_value.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:50 $

[id] = H5ML.unwrap_ids(type_id);
H5ML.hdf5lib2('H5Tset_order',id,order); 
