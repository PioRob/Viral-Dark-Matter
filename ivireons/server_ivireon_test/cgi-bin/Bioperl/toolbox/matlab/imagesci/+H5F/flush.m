function flush(object_id, scope)
%H5F.flush  Flush buffers to disk.
%   H5F.flush(object_id, scope) causes all buffers associated with a file 
%   to be immediately flushed to disk without removing the data from the 
%   cache.  object_id can be any object associated with the file, 
%   including the file itself, a dataset, a group, an attribute, or a named 
%   data type. scope specifies whether the scope of the flushing action is 
%   global or local.   scope may be one of the following strings:
%
%       'H5F_SCOPE_GLOBAL'
%       'H5F_SCOPE_LOCAL'
%
%   See also H5F.

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.5 $ $Date: 2010/04/15 15:20:20 $

id = H5ML.unwrap_ids(object_id);

if isa(scope,'char')
	switch scope
		case { 'H5F_SCOPE_GLOBAL', 'H5F_SCOPE_LOCAL' }
			scope = H5ML.get_constant_value(scope);
		otherwise
			error('MATLAB:H5Fflush:unrecognizedScopeString', ...
			      '''%s'' is not a recognized scope flushing action.', scope );
	end
end

H5ML.hdf5lib2('H5Fflush', id, scope);            
