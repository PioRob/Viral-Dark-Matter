function bf = getVarBlockingFactor(cdfId,varNum)
%cdflib.getVarBlockingFactor Return variable blocking factor
%   blockingFactor = cdflib.getVarBlockingFactor(cdfId,varNum) returns the 
%   blocking factor for the variable specified by varNum in the CDF 
%   identified by cdfId.
%
%   This function corresponds to the CDF library C API routine 
%   CDFgetzVarBlockingFactor.  
%
%   Example:
%       cdfId = cdflib.open('example.cdf');
%       varNum = 0;
%       blockingFactor = cdflib.getVarBlockingFactor(cdfId,varNum);
%       cdflib.close(cdfId);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.setVarBlockingFactor.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:08 $

bf = cdflibmex('getVarBlockingFactor',cdfId,varNum);
