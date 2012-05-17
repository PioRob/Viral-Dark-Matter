function maxrec = getVarsMaxWrittenRecNum(cdfid)
%cdflib.getVarsMaxWrittenRecNum Return maximum written record number
%   maxrec = cdflib.getVarsMaxWrittenRecNum(cdfId) returns the maximum
%   record number written for all variables in the CDF specified by cdfId.
%   Record numbers are zero-based.
%
%   This function corresponds to the CDF library C API routine 
%   CDFgetzVarsMaxWrittenRecNum.
%
%   Example:
%       cdfid = cdflib.open('example.cdf');
%       maxrec = cdflib.getVarsMaxWrittenRecNum(cdfid);
%       cdflib.close(cdfid);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.getVarMaxWrittenRecNum.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:22 $

maxrec = cdflibmex('getVarsMaxWrittenRecNum',cdfid);
