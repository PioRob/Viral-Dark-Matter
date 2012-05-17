function output = get_inpad(type_id)
%H5T.get_inpad  Return internal padding type for floating point datatypes.
%   pad_type = H5T.get_inpad(type_id) returns the internal padding type for
%   unused bits in floating-point datatypes. type_id is a datatype 
%   identifier.  pad_type can be H5T_PAD_ZERO, H5T_PAD_ONE, or 
%   H5T_PAD_BACKGROUND.
%
%    Example:
%        fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%        dset_id = H5D.open(fid,'/g3/float');
%        type_id = H5D.get_type(dset_id);
%        pad_type = H5T.get_inpad(type_id);
%        switch(pad_type)
%            case H5ML.get_constant_value('H5T_PAD_ZERO')
%                fprintf('pad zero\n');
%            case H5ML.get_constant_value('H5T_PAD_ONE');
%                fprintf('pad one\n');
%            case H5ML.get_constant_value('H5T_PAD_BACKGROUND')
%                fprintf('pad background\n');
%        end
%
%   See also H5T, H5T.set_inpad.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:24:19 $

[id] = H5ML.unwrap_ids(type_id);
output = H5ML.hdf5lib2('H5Tget_inpad',id); 
