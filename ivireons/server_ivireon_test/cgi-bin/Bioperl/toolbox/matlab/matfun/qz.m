%QZ     QZ factorization for generalized eigenvalues.
%   [AA, BB, Q, Z] = QZ(A,B) for square matrices A and B, produces
%   upper quasitriangular matrices AA and BB and unitary matrices
%   Q and Z such that
%       Q*A*Z = AA, Q*B*Z = BB.
%
%   [AA, BB, Q, Z, V, W] = QZ(A,B) also produces matrices V and W
%   whose columns are generalized eigenvectors.
% 
%   For complex matrices, AA and BB are triangular.  For real matrices,
%   QZ(A,B,'real') produces a real decomposition with a quasitriangular
%   AA containing 1-by-1 and 2-by-2 diagonal blocks, while
%   QZ(A,B,'complex') produces a possibly complex decomposition
%   with a triangular AA.  For compatibility with earlier versions,
%   'complex' is the default.
%
%   If AA is triangular, the diagonal elements of AA and BB,
%       alpha = diag(AA), beta = diag(BB),
%   are the generalized eigenvalues that satisfy
%       A*V*diag(beta) = B*V*diag(alpha)
%       diag(beta)*W'*A = diag(alpha)*W'*B
%   The eigenvalues produced by
%       lambda = eig(A,B)
%   are the ratios of the alphas and betas.
%       lambda = alpha./beta
%   If AA is not triangular, it is necessary to further reduce the
%   2-by-2 blocks to obtain the eigenvalues of the full system.
%
%   See also ORDQZ, SCHUR, EIG.

%   Copyright 1984-2009 The MathWorks, Inc.
%   $Revision: 5.15.4.7 $  $Date: 2010/03/31 18:24:20 $
%   Built-in function.

