function obj_count = get_obj_count(file_id, types)
%H5F.get_obj_count  Return number of open objects in HDF5 file.
%   obj_count = H5F.get_obj_count(file_id, types) returns the number of 
%   open object identifiers for the file specified by file_id for the
%   specified type.  types may be given as one of the following strings:
%
%       'H5F_OBJ_FILE'     
%       'H5F_OBJ_DATASET'  
%       'H5F_OBJ_GROUP'    
%       'H5F_OBJ_DATATYPE' 
%       'H5F_OBJ_ATTR'     
%       'H5F_OBJ_ALL'      
%       'H5F_OBJ_LOCAL'    
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       gid = H5G.open(fid,'/g2');
%       obj_count = H5F.get_obj_count(fid,'H5F_OBJ_GROUP');
%       H5G.close(gid);
%       H5F.close(fid);
%
%   See also H5F, H5F.get_obj_ids.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:20:30 $

id = H5ML.unwrap_ids(file_id);
obj_count = H5ML.hdf5lib2('H5Fget_obj_count', id, types);            
