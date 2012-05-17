function fill_time = get_fill_time(plist_id)
%H5P.get_fill_time  Return time when fill values are written to dataset.
%   fill_time = H5P.get_fill_time(plist_id) returns the time when fill
%   values are written to the dataset specified by the dataset creation
%   property list plist_id. fill_time is one of the following values:
%   H5D_FILL_TIME_IFSET, H5D_FILL_TIME_ALLOC, or H5D_FILL_TIME_NEVER.
%
%   Example:
%       plist_id = 'H5P_DEFAULT';
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY',plist_id);
%       dset_id = H5D.open(fid,'/g3/integer',plist_id);
%       dcpl = H5D.get_create_plist(dset_id);
%       fill_time = H5P.get_fill_time(dcpl);
%       switch(fill_time)
%           case H5ML.get_constant_value('H5D_FILL_TIME_IFSET')
%               fprintf('upon allocation if and only if fill value set by user\n');
%           case H5ML.get_constant_value('H5D_FILL_TIME_ALLOC')
%               fprintf('written when storage space is allocated\n');
%           case H5ML.get_constant_value('H5D_FILL_TIME_NEVER')
%               fprintf('fill values are never written\n');
%       end
%
%   See also H5P, H5P.get_fill_time, H5P.set_fill_value.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:22:06 $

id = H5ML.unwrap_ids(plist_id);
fill_time = H5ML.hdf5lib2('H5Pget_fill_time', id);            
