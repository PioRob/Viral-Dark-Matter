function file_info = get_info(obj_id)
%H5F.get_info  Return global information on file.
%   file_info = H5F.get_info(obj_id) returns global information for the 
%   file associated with the object identifier obj_id.  For details 
%   about the fields of the file_info structure, please refer to the
%   HDF5 documentation.
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       gid = H5G.open(fid,'g2');
%       info = H5F.get_info(gid);
%       H5G.close(gid);
%       H5F.close(fid);
%
%   See also H5F.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:20:25 $

[id] = H5ML.unwrap_ids(obj_id);
file_info = H5ML.hdf5lib2('H5Fget_info', id);

