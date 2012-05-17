function setVarBlockingFactor(cdfId,varNum,blockingFactor)
%cdflib.setVarBlockingFactor Specify variable blocking factor
%   cdflib.setVarBlockingFactor(cdfId,varNum,blockingFactor) specifies the 
%   blocking factor for the variable specified by varNum in the CDF 
%   identified by cdfId.
%
%   Fractional blocking factors will be rounded down.
%   
%   This function corresponds to the CDF library C API routine 
%   CDFsetzVarBlockingFactor.  
%
%   Example:
%       cdfid = cdflib.create('myfile.cdf');
%       varnum = cdflib.createVar(cdfid,'Time','cdf_int1',1,[],true,[]);
%       cdflib.setVarBlockingFactor(cdfid,varnum,10);
%       cdflib.close(cdfid);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.getVarBlockingFactor.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:41:46 $

cdflibmex('setVarBlockingFactor',cdfId,varNum,blockingFactor);
