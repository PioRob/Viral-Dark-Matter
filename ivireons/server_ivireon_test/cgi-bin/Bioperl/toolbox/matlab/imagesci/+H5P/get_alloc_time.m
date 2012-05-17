function alloc_time = get_alloc_time(plist_id)
%H5P.get_alloc_time  Return timing of storage space allocation.
%   alloc_time = H5P.get_alloc_time(plist_id) retrieves the timing for 
%   storage space allocation from the dataset creation property list 
%   specified by plist_id. alloc_time can have any of the following values:
%   H5D_ALLOC_TIME_DEFAULT, H5D_ALLOC_TIME_EARLY, H5D_ALLOC_TIME_INCR, or 
%   H5D_ALLOC_TIME_LATE.       
%
%   Example:
%       plist_id = 'H5P_DEFAULT';
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY',plist_id);
%       dset_id = H5D.open(fid,'/g3/integer',plist_id);
%       dcpl = H5D.get_create_plist(dset_id);
%       alloc_time = H5P.get_alloc_time(dcpl);
%       switch(alloc_time)
%           case H5ML.get_constant_value('H5D_ALLOC_TIME_DEFAULT')
%               fprintf('allocation time is default\n');
%           case H5ML.get_constant_value('H5D_ALLOC_TIME_EARLY')
%               fprintf('allocation time is dataset creation time\n');
%           case H5ML.get_constant_value('H5D_ALLOC_TIME_INCR')
%               fprintf('allocation time is incremental\n');
%           case H5ML.get_constant_value('H5D_ALLOC_TIME_LATE')
%               fprintf('allocation time is when data is first written\n');
%       end
%
%   See also H5P.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:21:43 $

id = H5ML.unwrap_ids(plist_id);
alloc_time = H5ML.hdf5lib2('H5Pget_alloc_time', id);            
