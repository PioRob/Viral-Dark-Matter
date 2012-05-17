function obj_type = get_type(obj_id)
%H5I.get_type  Return type of specified object.
%   obj_type = H5I.get_type(obj_id) returns the type of the object
%   specified by obj_id.  obj_type corresponds to one of the following
%   enumerated values:
%  
%       H5I_FILE 
%       H5I_GROUP
%       H5I_DATATYPE
%       H5I_DATASPACE
%       H5I_DATASET
%       H5I_ATTR
%       H5I_BADID
%
%   Example:  
%       plist_id = 'H5P_DEFAULT';
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY',plist_id);
%       gid = H5G.open(fid,'/g3',plist_id);
%       dset_id = H5D.open(fid,'/g4/world',plist_id);
%       [~,objs] = H5F.get_obj_ids(fid,'H5F_OBJ_ALL',3);
%       for j = 1:numel(objs)
%           name = H5I.get_name(objs(j));
%           fprintf('object ''%s'':  ==> ', name);
%           type = H5I.get_type(objs(j));
%           switch(type)
%               case H5ML.get_constant_value('H5I_FILE')
%                   fprintf('FILE identifier.\n');
%               case H5ML.get_constant_value('H5I_GROUP')
%                   fprintf('GROUP identifier.\n');
%               case H5ML.get_constant_value('H5I_DATASET')
%                   fprintf('DATASET identifier.\n');
%               otherwise
%                   fprintf('unknown identifier type.\n');
%           end
%       end
%       H5G.close(gid);
%       H5F.close(fid);
%
%   See also H5I, H5ML.get_constant_value.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/05/13 17:39:57 $

[id] = H5ML.unwrap_ids(obj_id);
obj_type = H5ML.hdf5lib2('H5Iget_type', id);            
