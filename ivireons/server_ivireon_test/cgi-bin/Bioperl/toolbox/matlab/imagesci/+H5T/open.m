function type_id = open(loc_id, name)
%H5T.open  Open named datatype.
%   type_id = H5T.open(loc_id, name) opens a named datatype at the location 
%   specified by loc_id and returns an identifier for the datatype. loc_id 
%   is either a file or group identifier.
%
%   This function corresponds to the H5Topen1 function in the HDF5 
%   library C API.
%
%   See also H5T, H5T.close, H5A.open, H5D.open, H5G.open, H5O.open.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.6 $ $Date: 2010/05/13 17:40:24 $

[id] = H5ML.unwrap_ids(loc_id);
type_id = H5ML.hdf5lib2('H5Topen', id, name);            
type_id = H5ML.id(type_id,'H5Tclose');
