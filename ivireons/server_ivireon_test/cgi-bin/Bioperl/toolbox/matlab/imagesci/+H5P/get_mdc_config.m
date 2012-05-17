function config_struct = get_mdc_config(plist_id)
%H5P.get_mdc_config  Get metadata cache configuration.
%   config_struct = H5P.get_mdc_config(plist_id) returns the current 
%   metadata cache configuration from the indicated file access property 
%   list.
%
%   Example:
%       fid = H5F.open('example.h5','H5F_ACC_RDONLY','H5P_DEFAULT');
%       fapl = H5F.get_access_plist(fid);
%       config = H5P.get_mdc_config(fapl);
%       H5P.close(fapl);
%       H5F.close(fid);
%
%   See also H5P, H5P.set_mdc_config.
%

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:22:17 $

id = H5ML.unwrap_ids(plist_id);
config_struct = H5ML.hdf5lib2('H5Pget_mdc_config', id);            
