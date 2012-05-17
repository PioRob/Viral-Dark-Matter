function attr_id = open_idx(loc_id, idx)
%H5A.open_idx  Open attribute specified by index.
%
%   H5A.open_idx is not recommended.  Use H5A.open_by_idx instead.
%
%   attr_id = H5A.open_idx(loc_id, idx) opens the attribute specified by 
%   idx, which is attached to the group, dataset, or named datatype 
%   specified by loc_id.
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5A, H5A.open_by_idx.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $ $Date: 2010/05/13 17:39:23 $

id = H5ML.unwrap_ids(loc_id);
attr_id = H5ML.hdf5lib2('H5Aopen_idx', id, idx);            
attr_id = H5ML.id(attr_id,'H5Aclose');
