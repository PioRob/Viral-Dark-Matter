%SUB    Subtract two fi objects using fimath object
%   C = F.SUB(A,B) adds objects A and B using fimath object F. 
%
%   This is helpful in cases when you want to override the fimath properties 
%   associated with A and B, or if the fimath properties associated with A and B 
%   are different.
%
%   A and B must have the same dimensions unless one is a scalar. If 
%   either A or B is scalar, then C has the dimensions of the nonscalar
%   object.
%
%   If either A or B is a fi object, and the other is a MATLAB built-in 
%   numeric type, then the built-in object is cast to the word length of 
%   the fi object, preserving best-precision fraction length.
%
%   Example: add two fi objects overriding their fimath:
%     a = fi(pi);
%     b = fi(exp(1));
%     F = fimath('SumMode','SpecifyPrecision','SumWordLength', ...
%		   		   32,'SumFractionLength',16);
%     c = F.sub(a,b)
%     % returns difference of 'a' and 'b', with real world value 0.4233
%
%   Algorithm:
%     C = F.sub(A,B) is equivalent to:
%     A.fimath = F;
%     B.fimath = F;
%     C = A - B;
%     except that the fimath properties of a and b are not modified when  
%     you use the functional form.
%
%   See also EMBEDDED.FIMATH/ADD, EMBEDDED.NUMERICTYPE/DIVIDE, FI, 
%            FIMATH, EMBEDDED.FIMATH/MPY, NUMERICTYPE,
%            EMBEDDED.FI/SUM

%   Copyright 1999-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2009/05/14 16:53:59 $
