function c = dot(a,b,dim)
%DOT  Vector dot product.
%   C = DOT(A,B) returns the scalar product of the vectors A and B.
%   A and B must be vectors of the same length.  When A and B are both
%   column vectors, DOT(A,B) is the same as A'*B.
%
%   DOT(A,B), for N-D arrays A and B, returns the scalar product
%   along the first non-singleton dimension of A and B. A and B must
%   have the same size.
%
%   DOT(A,B,DIM) returns the scalar product of A and B in the
%   dimension DIM.
%
%   Class support for inputs A,B:
%      float: double, single
%
%   See also CROSS.

%   Copyright 1984-2010 The MathWorks, Inc. 
%   $Revision: 5.13.4.3 $  $Date: 2010/02/25 08:12:15 $

% Special case: A and B are vectors and dim not supplied
if ismatrix(a) && ismatrix(b) && nargin<3
   if min(size(a))==1, a = a(:); end
   if min(size(b))==1, b = b(:); end
end;

% Check dimensions
if any(size(a)~=size(b)),
   error('MATLAB:dot:InputSizeMismatch', 'A and B must be same size.');
end

if nargin==2,
  c = sum(conj(a).*b);
else
  c = sum(conj(a).*b,dim);
end
