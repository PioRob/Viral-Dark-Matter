function output = get_member_index(type_id, name)
%H5T.get_member_index  Return index of compound or enumeration type member.
%   idx = H5T.get_member_index(type_id, name) returns the index of a field
%   of a compound datatype or an element of an enumeration datatype.
%   type_id is a datatype identifier and name is a text string that
%   identifies the target field or element.
%
%   Example:
%      fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%      dset_id = H5D.open(fid,'/g3/compound');
%      type_id = H5D.get_type(dset_id);
%      idx = H5T.get_member_index(type_id,'b'); 
%
%   See also H5T, H5T.get_member_name.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:21 $

[id] = H5ML.unwrap_ids(type_id);
output = H5ML.hdf5lib2('H5Tget_member_index',id, name); 
