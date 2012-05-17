function reset(varargin)
%RESET  Reset quantizer states to creation values
%   RESET(Q) resets the states of quantizer object Q to its creation values. 
%   The states of a quantizer object are:
%     max         - Maximum value before quantizing.
%     min         - Minimum value before quantizing.
%     noverflows  - Number of overflows.
%     nunderflows - Number of underflows.
%     noperations - Number of quantization operations.
%
%   RESET(Q1, Q2, ...) resets the states of the quantizer objects Q1,
%   Q2, .... 
%
%   Example:
%     q = quantizer('fixed','ceil','saturate',[4 3])
%     y = quantize(q, -1.2:.1:1.2 );
%     q
%     reset(q)
%     q
%     
%   See also QUANTIZER, EMBEDDED.QUANTIZER/QUANTIZE

%   Thomas A. Bryan
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2006/12/20 07:14:16 $

for k=1:nargin
  q = varargin{k};
  if isa(q,'embedded.quantizer')
      initializestates(q);
  end
end
