function close(group_id)
%H5G.close  Close group.
%   H5G.close(group_id) releases resources used by the group specified by
%   group_id. group_id was returned by either H5G.create or H5G.open. 
%
%   See also H5G, H5G.create, H5G.open.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/05/13 17:39:39 $

if isa(group_id, 'H5ML.id')
    id = group_id.identifier;
    group_id.identifier = -1;
else
    id = group_id;
end
H5ML.hdf5lib2('H5Gclose', id);            
