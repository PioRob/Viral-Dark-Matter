function err_string = get_major(major_number)
%H5E.get_major  Return description of major error number.
%   err_string = H5E.get_major(major_number) returns a character string 
%   describing an error specified by the major error number, major_number.
%
%   The HDF5 group has deprecated the use of this function.
%
%   See also H5E, H5E.get_minor.
 

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/04/15 15:20:15 $
    
err_string = H5ML.hdf5lib2('H5Eget_major', major_number);            
