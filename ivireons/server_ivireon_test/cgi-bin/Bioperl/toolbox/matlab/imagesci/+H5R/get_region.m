function space_id = get_region(loc_id, ref_type, ref)
%H5R.get_region  Return copy of dataspace of specified region.
%   space_id = H5R.get_region(dataset, ref_type, ref) returns a dataspace 
%   with the specified region selected.  loc_id is used to identify the
%   file containing the referenced region and can be any identifier for any
%   object in the file.
%
%   Example:
%       space = 'H5S_ALL';
%       plist = 'H5P_DEFAULT';
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY',plist);
%       dset_id = H5D.open(fid,'/g3/region_reference',plist);
%       ref_data = H5D.read(dset_id,'H5T_STD_REF_DSETREG',space,space,plist);
%       space_id = H5R.get_region(fid,'H5R_DATASET_REGION',ref_data(:,1));
%       H5S.close(space_id);
%       H5D.close(dset_id);
%       H5F.close(fid);
%
%   See also H5R.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/05/13 17:40:18 $

[id] = H5ML.unwrap_ids(loc_id);
space_id = H5ML.hdf5lib2('H5Rget_region', id, ref_type, ref);            
space_id = H5ML.id(space_id,'H5Sclose');

