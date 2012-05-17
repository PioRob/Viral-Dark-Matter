function attid = inqAttID(ncid,varid,attname)
%netcdf.inqAttID Return ID of netCDF attribute.
%   attnum = netcdf.inqAttID(ncid,varid,attname) retrieves the 
%   number of the attribute associated with the attribute name.
%
%   This function  corresponds to the "nc_inq_att_id" function in the 
%   netCDF library C API.
%
%   Example:
%       ncid = netcdf.open('example.nc','NOWRITE');
%       varid = netcdf.inqVarID(ncid,'temperature');
%       attid = netcdf.inqAttID(ncid,varid,'scale_factor');
%       netcdf.close(ncid);
%
%   Please read the files netcdfcopyright.txt and mexnccopyright.txt for 
%   more information.
%
%   See also netcdf, netcdf.inqAtt.

%   Copyright 2008-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $ $Date: 2010/05/13 17:41:59 $

attid = netcdflib('inqAttID', ncid, varid,attname);            
