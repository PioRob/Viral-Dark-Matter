function T = lesp(n,classname)
%LESP Tridiagonal matrix with real, sensitive eigenvalues.
%   GALLERY('LESP',N) is an N-by-N matrix whose eigenvalues are real
%   and smoothly-distributed in the interval approximately
%   [-2*N-3.5, -4.5]. The sensitivities of the eigenvalues increase
%   exponentially as the eigenvalues grow more negative. The matrix
%   is similar to the symmetric tridiagonal matrix with the same
%   diagonal entries and with off-diagonal entries 1, via a similarity
%   transformation with D = diag(1!,2!,...,N!).

%   References:
%   [1] H. W. J. Lenferink and M. N. Spijker, On the use of stability
%       regions in the numerical analysis of initial value problems,
%       Math. Comp., 57 (1991), pp. 221-237.
%   [2] L. N. Trefethen, Pseudospectra of matrices,
%       Numerical Analysis 1991, Proceedings of the 14th Dundee
%       Conference, D.F. Griffiths and G.A. Watson, eds,
%       Pitman Research Notes in Mathematics, volume 260,
%       Longman Scientific and Technical, Essex, UK, 1992,
%       pp. 234-266.
%
%   Nicholas J. Higham
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $  $Date: 2005/11/18 14:15:11 $

x = cast(2:n,classname);
% Use just first clause of "if" once sparse single supported.
if strcmp(classname,'double')
   T = full(tridiag( ones(size(x))./x, -(2*[x n+1]+1), x, [], classname));
elseif strcmp(classname,'single')
   T = diag(ones(size(x),classname)./x, -1) + diag(-(2*[x n+1]+1)) + diag(x, 1);
end
