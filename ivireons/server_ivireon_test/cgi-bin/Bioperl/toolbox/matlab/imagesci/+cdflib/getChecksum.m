function mode = getChecksum(cdfId)
%cdflib.getChecksum Return checksum mode
%   mode = cdflib.getChecksum(cdfId) returns the checksum mode of the CDF
%   file identified by cdfId.  The checksum mode will be either 
%   'MD5_CHECKSUM' or 'NO_CHECKSUM'.
%
%   This function corresponds to the CDF library C API routine 
%   CDFgetChecksum.  
%
%   Example:
%       cdfid = cdflib.open('example.cdf');
%       mode = cdflib.getChecksum(cdfid);
%       cdflib.close(cdfid);
%       fprintf('The checksum mode is %s.\n', mode);
%
%   Please read the file cdfcopyright.txt for more information.
% 
%   See also cdflib, cdflib.setChecksum.

% Copyright 2009-2010 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:40:50 $

mode = cdflibmex('getChecksum',cdfId);
