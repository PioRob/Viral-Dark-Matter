function A = prolate(n, w, classname)
%PROLATE Prolate matrix (symmetric, ill-conditioned Toeplitz matrix).
%   A = GALLERY('PROLATE',N,W) is the N-by-N prolate matrix with
%   parameter W. It is a symmetric Toeplitz matrix.
%   If 0 < W < 0.5 then
%     1. A is positive definite
%     2. The eigenvalues of A are distinct, lie in (0, 1), and tend to
%        cluster around 0 and 1.
%   W defaults to 0.25.

%   Reference:
%   J. M. Varah. The Prolate matrix. Linear Algebra and Appl.,
%   187:269-278, 1993.
%
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $  $Date: 2005/11/18 14:15:21 $

if isempty(w), w = 0.25; end

a = zeros(n,1,classname);
a(1) = 2*w;
a(2:n) = sin( 2*pi*w*(1:n-1) ) ./ ( pi*(1:n-1) );

A = toeplitz(a);
