function plist_id = get_create_plist(dataset_id)
%H5D.get_create_plist  Return copy of dataset creation property list.
%   plist_id = H5D.get_create_plist(dataset_id) returns the identifier to a
%   copy of the dataset creation property list for the dataset specified by
%   dataset_id. 
%
%   Example: 
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       dset_id = H5D.open(fid,'/g1/g1.1/dset1.1.1');
%       dcpl = H5D.get_create_plist(dset_id);
%       H5P.close(dcpl);
%       H5D.close(dset_id);
%       H5F.close(fid);
%
%   See also H5D, H5D.get_access_plist, H5P.close.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:19:54 $

id = H5ML.unwrap_ids(dataset_id);
plist_id = H5ML.hdf5lib2('H5Dget_create_plist', id);            
plist_id = H5ML.id(plist_id,'H5Pclose');
