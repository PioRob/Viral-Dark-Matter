function [max_size,min_clean_size,cur_size,num_cur_entries] = get_mdc_size(file_id)
%H5F.get_mdc_size  Return metadata cache size data.
%   [max_sz,min_clean_sz,cursz,num_cur_entries] = H5F.get_mdc_size(fileId)
%   queries the metadata cache of the target file to obtain current
%   metadata cache size information.
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       [maxsz,minsz,cursz,nent] = H5F.get_mdc_size(fid);
%       H5F.close(fid);
%
%   See also H5F, H5F.get_mdc_config.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:20:28 $

id = H5ML.unwrap_ids(file_id);
[max_size,min_clean_size,cur_size,num_cur_entries] = H5ML.hdf5lib2('H5Fget_mdc_size',id);            

