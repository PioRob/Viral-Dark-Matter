%<= (LE)   Less than or equal relation for handles.
%   Handles are equal if they are handles for the same object.  All 
%   comparisons use a number associated with each handle object.  Nothing
%   can be assumed about the result of a handle comparison except that the
%   repeated comparison of two handles in the same MATLAB session will 
%   yield the same result.  The order of handle values is purely arbitrary 
%   and has no connection to the state of the handle objects being 
%   compared.
%
%   H1 <= H2 performs element-wise comparisons between handle arrays H1 and
%   H2.  H1 and H2 must be of the same dimensions unless one is a scalar.
%   The result is a logical array of the same dimensions, where each
%   element is an element-wise >= result.
%
%   If one of H1 or H2 is scalar, scalar expansion is performed and the 
%   result will match the dimensions of the array that is not scalar.
%
%   TF = LE(H1, H2) stores the result in a logical array of the same 
%   dimensions.
%
%   See also HANDLE, HANDLE/EQ, HANDLE/GE, HANDLE/GT, HANDLE/LT, HANDLE/NE
 
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2008/03/24 18:09:06 $
%   Built-in function.



