function delete(loc_id,name,lapl_id)
%H5L.delete  Remove link.
%   H5L.delete(loc_id,name,lapl_id) removes the link specified by name from
%   the location loc_id.  lapl_id is a link access property list
%   identifier.
%
%   Example:  Remove the only link to the '/g3' group in example.h5. 
%       srcFile = fullfile(matlabroot,'toolbox','matlab','demos','example.h5');
%       copyfile(srcFile,'myfile.h5');
%       fileattrib('myfile.h5','+w');
%       fid = H5F.open('myfile.h5','H5F_ACC_RDWR','H5P_DEFAULT');
%       H5L.delete(fid,'g3','H5P_DEFAULT');
%       H5F.close(fid);
%       
%   See also H5L, H5L.move.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $ $Date: 2010/04/15 15:21:06 $


[id, lid] = H5ML.unwrap_ids(loc_id, lapl_id);
H5ML.hdf5lib2('H5Ldelete', id, name, lid);            

