%ISVALID   Test handle validity.
%   TF = ISVALID(H) performs an element-wise check for validity on the 
%   handle elements of H.  The result is a logical array of the same 
%   dimensions as H, where each element is the element-wise validity 
%   result.
%
%   A handle is invalid if it has been deleted or if it is an element
%   of a handle array and has not yet been initialized.
%
%   See also HANDLE, HANDLE/DELETE
 
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.8.2 $  $Date: 2009/04/15 23:20:59 $
%   Built-in function.
