function type = get_objtype_by_idx(loc_id, idx)
%H5G.get_objtype_by_idx  Return type of object specified by index.
%
%   H5G.get_objtype_by_idx is not recommended.  Use H5O.get_info instead.  
%
%   type = H5G.get_objtype_by_idx(loc_id, idx) returns the type of the 
%   object specified by the index idx, in the file or group specified by 
%   loc_id.
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5G, H5O.get_info.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $ $Date: 2010/05/13 17:39:45 $

id = H5ML.unwrap_ids(loc_id);
type = H5ML.hdf5lib2('H5Gget_objtype_by_idx', id, idx);            
