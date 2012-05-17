function output = is_simple(space_id)
%H5S.is_simple  Determine if dataspace is simple.
%   output = H5S.is_simple(space_id) returns a positive value if the
%   dataspace specified by space_id is a simple dataspace, zero if it is
%   not, and a negative value to indicate failure.
%
%   Example:
%       dims = [100 200];
%       h5_dims = fliplr(dims);
%       space_id = H5S.create_simple(2,h5_dims,h5_dims);
%       val = H5S.is_simple(space_id);
%
%   Example:
%       space_id = H5S.create('H5S_NULL');
%       val = H5S.is_simple(space_id);
%
%   See also H5S, H5S.create, H5S.create_simple.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:23:49 $

[id] = H5ML.unwrap_ids(space_id);
output = H5ML.hdf5lib2('H5Sis_simple', id);            
