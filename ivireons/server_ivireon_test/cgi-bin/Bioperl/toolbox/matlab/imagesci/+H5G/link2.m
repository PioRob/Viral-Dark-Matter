function link2(src_loc, cur_name, type, dst_loc, new_name)
%H5G.link2  Create link from one object to another.
%
%   H5G.link2 is not recommended.  Use H5L.create_soft or H5L.create_hard 
%   instead.
%
%   H5G.link2(curr_loc_id, current_name, link_type, new_loc_id, new_name) 
%   creates a link of the type specified by link_type from new_name to 
%   current_name.  curr_loc_id is the file of group identifier of the 
%   original object.  new_loc_id is the file or group identifier for the 
%   new link.
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5G, H5L.create_hard, H5L.create_soft.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $ $Date: 2010/05/13 17:39:47 $

[src_id, dst_id] = H5ML.unwrap_ids(src_loc, dst_loc);
H5ML.hdf5lib2('H5Glink2', src_id, cur_name, type, dst_id, new_name);            
