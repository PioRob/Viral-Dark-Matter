function nentries = getNumAttrgEntries(cdfId,attrNum)
%cdflib.getNumAttrgEntries Return number entries for global attribute
%   nentries = cdflib.getNumAttrgEntries(cdfId,attrNum) returns the total
%   number of entries written for the global attribute specified by attrNum
%   in the CDF specified by cdfId.
%
%   This function corresponds to the CDF library C API routine 
%   CDFgetNumAttrgEntries.
%
%   Example:
%       cdfid = cdflib.open('example.cdf');
%       attrNum = cdflib.getAttrNum(cdfid,'SampleAttribute');
%       nentries = cdflib.getNumAttrgEntries(cdfid,attrNum);
%       cdflib.close(cdfid);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.getNumAttrEntries.

% Copyright 2009-2010 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:02 $

nentries = cdflibmex('getNumAttrgEntries',cdfId,attrNum);
