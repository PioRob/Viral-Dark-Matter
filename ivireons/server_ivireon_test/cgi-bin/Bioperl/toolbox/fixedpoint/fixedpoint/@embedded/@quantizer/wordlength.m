function f = wordlength(q)
%WORDLENGTH Word length of a quantizer object
%   WORDLENGTH(Q) returns the word length in bits of quantizer object Q.
%   The word length is the first element of FORMAT(Q).
%
%   Example:
%     q = quantizer('double');
%     wordlength(q)
%   returns 64.
%
%   See also QUANTIZER, EMBEDDED.QUANTIZER/FORMAT, 
%            EMBEDDED.QUANTIZER/FRACTIONLENGTH, 
%            EMBEDDED.QUANTIZER/EXPONENTLENGTH

%   Thomas A. Bryan
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2006/12/20 07:14:29 $

f = q.wordlength;
