function set_external(plist_id, name, offset, nbytes)
%H5P.set_external  Add additional file to external file list.
%   H5P.set_external(plist_id, name, offset, size) adds the external file
%   specified by name to the list of external files in the dataset creation
%   property list, plist_id. Offset specifies the location, in bytes, where
%   the data starts relative to the beginning of the file. nbytes is the
%   number of bytes reserved in the file for the data.  nbytes may also be
%   given as 'H5F_UNLIMITED', in which case the external file may be of
%   unlimited size.
%
%   Example:  create a dataset with an unlimited size external file
%       plist_id = 'H5P_DEFAULT';
%       fid = H5F.create('myfile.h5','H5F_ACC_TRUNC',plist_id,plist_id);
%       type_id = H5T.copy('H5T_NATIVE_DOUBLE');
%       dims = [100 50];
%       h5_dims = fliplr(dims);
%       h5_maxdims = h5_dims;
%       space_id = H5S.create_simple(2,h5_dims,h5_maxdims);
%       dcpl = H5P.create('H5P_DATASET_CREATE');
%       H5P.set_external(dcpl,'myexternalfile.dat',0,'H5F_UNLIMITED');
%       dset_id = H5D.create(fid,'DS',type_id,space_id,plist_id,dcpl,plist_id);
%       data = rand(dims);
%       H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',plist_id,data);
%       H5D.close(dset_id);
%       H5F.close(fid);
%
%   See also H5P, H5P.get_external, H5ML.get_constant_value.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:22:50 $

id = H5ML.unwrap_ids(plist_id);
H5ML.hdf5lib2('H5Pset_external', id, name, offset, nbytes);            
