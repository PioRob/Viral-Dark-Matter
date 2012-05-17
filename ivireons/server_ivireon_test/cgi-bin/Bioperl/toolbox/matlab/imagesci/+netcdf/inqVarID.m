function varid = inqVarID(ncid,varname)
%netcdf.inqVarID Return ID associated with variable name.
%   varid = netcdf.inqVarID(ncid,varname) returns the ID of a netCDF 
%   variable identified by varname.
%
%   This function corresponds to the "nc_inq_varid" function in the netCDF
%   library C API.
%
%   Example:
%       ncid = netcdf.open('example.nc','NOWRITE');
%       varid = netcdf.inqVarID(ncid,'temperature');
%       netcdf.close(ncid);
%
%   Please read the files netcdfcopyright.txt and mexnccopyright.txt for 
%   more information.
%
%   See also netcdf, netcdf.inqVar.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $ $Date: 2010/04/15 15:25:38 $

varid = netcdflib('inqVarID', ncid, varname);            
