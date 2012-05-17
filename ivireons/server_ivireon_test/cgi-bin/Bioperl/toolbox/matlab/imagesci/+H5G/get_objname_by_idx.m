function obj_name = get_objname_by_idx(loc_id, idx)
%H5G.get_objname_by_idx  Return name of object specified by index.
%
%   H5G.get_objname_by_idx is not recommended.  Use H5L.get_name_by_idx 
%   instead.
%
%   obj_name = H5G.get_objname_by_idx(loc_id, idx) returns the name of the
%   object specified by the index idx, in the group or file specified by
%   loc_id. 
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5G, H5L.get_name_by_idx.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $ $Date: 2010/05/13 17:39:44 $

id = H5ML.unwrap_ids(loc_id);
obj_name = H5ML.hdf5lib2('H5Gget_objname_by_idx', id, idx);            
