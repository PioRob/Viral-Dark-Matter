function encoding = get_char_encoding(plist_id)
%H5P.get_char_encoding  Return character encoding.
%   encoding = H5P.get_char_encoding(propertyList) retrieves the 
%   character encoding used to encode strings or object names that are 
%   created with the property list propertyList.  The values returned
%   correspond to either H5T_CSET_ASCII or H5T_CSET_UTF8
%
%   See also H5P, H5P.set_char_encoding, H5ML.get_constant_value

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:21:48 $

[id] = H5ML.unwrap_ids(plist_id);
encoding = H5ML.hdf5lib2('H5Pget_char_encoding', id );
