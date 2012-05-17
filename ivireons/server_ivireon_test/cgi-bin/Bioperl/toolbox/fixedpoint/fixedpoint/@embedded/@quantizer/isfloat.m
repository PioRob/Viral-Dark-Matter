function f = isfloat(q)
%ISFLOAT True for floating-point quantizers
%   ISFLOAT(Q) returns 1 if Q is a floating-point quantizer, and 0 otherwise.
%
%   Examples:
%     q = quantizer('double');
%     isfloat(q)
%
%     q = quantizer('ufixed');
%     isfloat(q)
%
%   See also QUANTIZER, EMBEDDED.QUANTIZER/ISFIXED

%   Thomas A. Bryan
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2006/12/20 07:13:48 $

switch q.mode
 case {'float','double','single'}
  f = logical(1);
 otherwise
  f = logical(0);
end

