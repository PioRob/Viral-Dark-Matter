function file_id = get_file_id(obj_id)
%H5I.get_file_id  Return file identifier for specified object.
%   file_id = H5I.get_file_id(obj_id) returns the identifier of the file 
%   associated with the object referenced by obj_id.
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       gid = H5G.open(fid,'/g4','H5P_DEFAULT');
%       fid2 = H5I.get_file_id(gid);
%       name = H5F.get_name(fid2);
%       fprintf('The filename is %s.\n', name);
%       H5G.close(gid);
%       H5F.close(fid);
%       H5F.close(fid2);
%
%   See also H5I.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/05/13 17:39:54 $

[id] = H5ML.unwrap_ids(obj_id);
file_id = H5ML.hdf5lib2('H5Iget_file_id', id);            
file_id = H5ML.id(file_id,'H5Fclose');
