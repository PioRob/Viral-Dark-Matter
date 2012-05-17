function x = realmin(q)
%REALMIN Smallest positive normal quantized number
%   REALMIN(Q) is the smallest positive quantized number where Q is a
%   QUANTIZER object.  Anything smaller underflows or is an IEEE "denormal".
%
%   Example:
%     q = quantizer('float',[6 3]);
%     realmin(q)
%   returns 0.25.
%
%   See also QUANTIZER, EMBEDDED.QUANTIZER/EPS, EMBEDDED.QUANTIZER/REALMAX

%   Thomas A. Bryan
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2006/12/20 07:14:15 $

x = q.realmin;
