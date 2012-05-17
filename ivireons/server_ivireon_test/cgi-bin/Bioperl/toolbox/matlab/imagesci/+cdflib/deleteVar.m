function deleteVar(cdfId,varNum)
%cdflib.deleteVar Delete CDF variable
%   cdflib.deleteVar(cdfId,varNum) deletes the CDF variable specified by 
%   varNum from the file specified by cdfId.
%   
%   This function corresponds to the CDF library C API routine 
%   CDFdeletezVar.  
%
%   Example:
%       cdfId = cdflib.create('myfile.cdf');
%       varNum = cdflib.createVar(cdfId,'Time','cdf_int1',1,[],true,[]);
%       info1 = cdflib.inquire(cdfId);
%       cdflib.deleteVar(cdfId,varNum);
%       info2 = cdflib.inquire(cdfId);
%       cdflib.close(cdfId);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also cdflib, cdflib.createVar.

%   Copyright 2009-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2010/05/13 17:40:38 $

cdflibmex('deleteVar',cdfId,varNum);
