%CHOLUPDATE Rank 1 update to Cholesky factorization.
%   If R = CHOL(A) is the original Cholesky factorization of A, then
%   R1 = CHOLUPDATE(R,X) returns the upper triangular Cholesky factor of A + X*X',
%   where X is a column vector of appropriate length.  CHOLUPDATE uses only the
%   diagonal and upper triangle of R.  The lower triangle of R is ignored.
%
%   R1 = CHOLUPDATE(R,X,'+') is the same as R1 = CHOLUPDATE(R,X).
%
%   R1 = CHOLUPDATE(R,X,'-') returns the Cholesky factor of A - X*X'.  An error
%   message reports when R is not a valid Cholesky factor or when the downdated
%   matrix is not positive definite and so does not have a Cholesky factorization.
%
%   [R1,p] = CHOLUPDATE(R,X,'-') will not return an error message.  If p is 0
%   then R1 is the Cholesky factor of A - X*X'.  If p is greater than 0, then
%   R1 is the Cholesky factor of the original A.  If p is 1 then CHOLUPDATE failed
%   because the downdated matrix is not positive definite.  If p is 2, CHOLUPDATE
%   failed because the upper triangle of R was not a valid Cholesky factor.
%
%   CHOLUPDATE works only for full matrices.
%
%   See also CHOL.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2005/06/21 19:35:49 $
%   Built-in function.

