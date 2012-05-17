function [rdcc_nslots rdcc_nbytes rdcc_w0] = get_chunk_cache(dapl_id)
%H5P.get_chunk_cache  Retrieve raw data chunk cache parameters.  
%   [rdcc_nslots rdcc_nbytes rdcc_w0] = H5P.get_chunk_cache(dapl_id)
%   retrieves the number of chunk slots in the raw data chunk cache hash
%   table (rdcc_nslots), the maximum possible number of bytes in the raw
%   data chunk cache (rdcc_nbytes), and the preemption policy value
%   (rdcc_w0) on a dataset access property list. 
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       dset_id = H5D.open(fid,'/g3/vlen3D');
%       dapl = H5D.get_access_plist(dset_id);
%       [rrdcc_nslots,rdcc_nbytes,rdcc_w0] = H5P.get_chunk_cache(dapl);
%       H5P.close(dapl);
%       H5D.close(dset_id);
%       H5F.close(fid);
%
%   See also H5P, H5P.set_chunk_cache.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $ $Date: 2010/04/15 15:21:50 $

id = H5ML.unwrap_ids(dapl_id);
[rdcc_nslots rdcc_nbytes rdcc_w0] = H5ML.hdf5lib2('H5Pget_chunk_cache', id);            
