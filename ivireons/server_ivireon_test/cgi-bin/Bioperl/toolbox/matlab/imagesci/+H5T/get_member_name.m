function name = get_member_name(type_id, membno)
%H5T.get_member_name  Return name of compound or enumeration type member.
%   name = H5T.get_member_name(type_id, membno) returns the name of a field
%   of a compound datatype or an element of an enumeration datatype.
%   type_id is a datatype identifier. membno is a zero-based index of the
%   field or element whose name is to be retrieved.
%
%   Example:  determine the name of the first field of a compound
%   dataset.
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       dset_id = H5D.open(fid,'/g3/compound');
%       dtype_id = H5D.get_type(dset_id);
%       member_name = H5T.get_member_name(dtype_id,0);
%
%   See also H5T, H5T.get_member_index.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:22 $

[id] = H5ML.unwrap_ids(type_id);
name = H5ML.hdf5lib2('H5Tget_member_name',id, membno); 
