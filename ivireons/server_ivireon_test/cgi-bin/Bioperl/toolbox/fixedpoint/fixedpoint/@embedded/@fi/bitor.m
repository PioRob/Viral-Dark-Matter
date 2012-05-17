%BITOR  Bitwise OR of two fi objects
%   C = BITOR(A, B) returns bitwise OR of fi objects A and B in fi 
%   object C.    
%
%   The numerictype of A and B must be identical. If both inputs have an 
%   attached fimath object, the fimath objects must be identical. If the
%   numerictype is 'signed', then the bit representation of the stored integer 
%   is in two's complement representation.
%   A and B must have the same dimensions unless one is a scalar.
%   BITOR only supports fi objects with fixed-point data types.
%
%   See also EMBEDDED.FI/BITAND, EMBEDDED.FI/BITCMP, EMBEDDED.FI/BITGET, 
%            EMBEDDED.FI/BITSET, EMBEDDED.FI/BITXOR

%   Copyright 1999-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2009/06/16 03:47:51 $
