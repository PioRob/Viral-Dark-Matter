function statbuf = get_objinfo(loc_id, name, follow_link)
%H5G.get_objinfo  Return information about object.
%
%   H5G.get_objinfo is not recommended.  Use H5O.get_info instead.
%
%   statbuf = H5G.get_objinfo(loc_id, name, follow_link) returns 
%   information about the object specified by loc_id and name. If 
%   follow_link is non-zero, this function follows the symbolic link and 
%   returns information about the object being pointed to.
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5G, H5L.get_info, H5O.get_info.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $ $Date: 2010/05/13 17:39:43 $

[id] = H5ML.unwrap_ids(loc_id);
statbuf = H5ML.hdf5lib2('H5Gget_objinfo', id, name, follow_link);
