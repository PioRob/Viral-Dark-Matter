function numBuffers = getStageCacheSize(cdfId)
%cdflib.getStageCacheSize Return number of cache buffers for staging
%   numBuffers = cdflib.getStageCacheSize(cdfId) returns the number of
%   cache buffers used for the staging scratch file of a CDF identified by
%   cdfId. Please refer to the CDF User's Guide for a discussion of
%   caching.
%
%   This function corresponds to the CDF library C API routine 
%   CDFgetStageCacheSize.
%
%   Example:
%       cdfid = cdflib.open('example.cdf');
%       numBuffers = cdflib.getStageCacheSize(cdfid);
%       cdflib.close(cdfid);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.setStageCacheSize.

% Copyright 2009-2010 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:06 $

numBuffers = cdflibmex('getStageCacheSize',cdfId);
