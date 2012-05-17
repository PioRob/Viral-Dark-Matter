function nlobj = setParameterVector(nlobj, th)
%setParameterVector set the parameters of IDNLFUN objects.
%
%   nlobj = setParameterVector(nlobj, vector)
%   nlobj is an array of IDNLFUN objects.

% Copyright 2005-2006 The MathWorks, Inc.
% $Revision: 1.1.8.2 $ $Date: 2006/12/27 20:59:42 $

% Author(s): Qinghua Zhang

pt = 0;
for ky=1:numel(nlobj)
  thk = sogetParameterVector(nlobj.ObjVector{ky}); 
  nthk = length(thk);
  nlobj.ObjVector{ky} = sosetParameterVector(nlobj.ObjVector{ky}, th(pt+1:pt+nthk));
  pt = pt + nthk;
end

% FILE END