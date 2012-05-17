function close(attr_id)
%H5A.close  Close specified attribute.
%   H5A.close(attr_id) terminates access to the attribute specified by  
%   attr_id, releasing the identifier.
%
%   See also H5A, H5A.open.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:19:33 $

if isa(attr_id, 'H5ML.id')
    id = attr_id.identifier;
    attr_id.identifier = -1;
else
    id = attr_id;
end
H5ML.hdf5lib2('H5Aclose', id);            
