function Y = ceil(A)
%CEIL   Round towards positive infinity
%   Y = CEIL(A) rounds fi object A to the nearest integer in the direction 
%   of positive infinity, and returns the result in fi object Y.
%
%   Y and A have the same fimath object and DataType property.
%
%   When the DataType property of A is 'Single', 'Double' or 'Boolean', the
%   numerictype of Y is the same as that of A. 
%
%   When the fraction length of A is zero or negative, A is already an 
%   integer, and the numerictype of Y is the same as that of A.
%
%   When the fraction length of A is positive, the fraction length of Y is
%   0, its signedness is the same as that of A, and its word length is
%   the difference between the word length and fraction length of A, plus
%   one bit. If A is signed, then the minimum word length of Y is 2. If A is
%   unsigned, then the minimum word length of Y is 1.
%
%   For complex fi objects, the imaginary and real parts are rounded 
%   independently.
%
%   CEIL does not support fi objects with nontrivial slope and bias scaling.
%   Slope and bias scaling is trivial when the slope is an integer power of
%   2 and the bias is zero.
%
%   See also EMBEDDED.FI/CONVERGENT, EMBEDDED.FI/FIX, EMBEDDED.FI/FLOOR,
%            EMBEDDED.FI/NEAREST, EMBEDDED.FI/ROUND

%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2007/10/15 22:49:23 $

Y = fi_matlab_style_round_helper(A, mfilename, 1);
