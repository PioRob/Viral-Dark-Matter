%SYMRCM Symmetric reverse Cuthill-McKee permutation.
%   p = SYMRCM(S) returns a permutation vector p such that S(p,p)
%   tends to have its diagonal elements closer to the diagonal than S.
%   This is a good preordering for LU or Cholesky factorization of
%   matrices that come from "long, skinny" problems.  It works for
%   both symmetric and nonsymmetric S.  When S is nonsymmetric, SYMRCM
%   works on the structure of S + S'.
%
%   See also AMD, COLAMD, COLPERM.

%   Copyright 1984-2008 The MathWorks, Inc. 
%   $Revision: 5.8.4.2 $  $Date: 2008/09/13 06:57:20 $
%   Built-in function.
