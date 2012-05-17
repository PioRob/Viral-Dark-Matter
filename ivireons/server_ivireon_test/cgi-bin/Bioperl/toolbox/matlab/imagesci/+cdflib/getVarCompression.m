function [ctype,cparams,cpercentage] = getVarCompression(cdfId,varNum)
%cdflib.getVarCompression Return variable compression information
%   [ctype,params,percent] = cdflib.getVarCompression(cdfId,varNum) 
%   returns the compression type, compression parameters, and compression
%   percentage of the variable specified by varNum in the CDF specified by 
%   cdfId.  
%   
%   This function corresponds to the CDF library C API routine 
%   CDFgetzVarCompression.  
%
%   Example:
%       cdfId = cdflib.open('example.cdf');
%       varNum = 0;
%       [ctype,cparms,cpercentage] = cdflib.getVarCompression(cdfId,varNum);
%       cdflib.close(cdfId);
%
%   Please read the file cdfcopyright.txt for more information.
% 
%   See also cdflib, cdflib.setCompression, cdflib.setVarCompression.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:10 $

[ctype,cparams,cpercentage] = cdflibmex('getVarCompression',cdfId,varNum);
