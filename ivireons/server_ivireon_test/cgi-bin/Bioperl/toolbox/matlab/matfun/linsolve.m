%LINSOLVE Solve linear system A*X=B.
%   X = LINSOLVE(A,B) solves the linear system A*X=B using
%   LU factorization with partial pivoting when A is square,
%   and QR factorization with column pivoting otherwise. 
%   Warning is given if A is ill conditioned for square matrices 
%   and rank deficient for rectangular matrices.
%
%   [X, R] = LINSOLVE(A,B) suppresses these warnings and returns R
%   the reciprocal of the condition number of A for square matrices,
%   and the rank of A if A is rectangular. 
%   
%   X = LINSOLVE(A,B,OPTS) solves the linear system A*X=B, 
%   with an appropriate solver determined by the properties of 
%   the matrix A as described by the structure OPTS. The fields of OPTS 
%   must contain logicals. All field values are defaulted to false.
%   No test is performed to verify whether A possesses such properties.
%
%   [X, R] = LINSOLVE(A,B,OPTS) suppresses these warnings and returns R,
%   the reciprocal of the condition number of A, or the rank of A (depending
%   on OPTS). See table below for more information.
%
%   Below is the list of all possible field names and 
%   their corresponding matrix properties.
%
%   Field Name : Matrix Property
%   ------------------------------------------------
%   LT         : Lower Triangular 
%   UT         : Upper Triangular
%   UHESS      : Upper Hessenberg
%   SYM        : Real Symmetric or Complex Hermitian
%   POSDEF     : Positive Definite
%   RECT       : General Rectangular
%   TRANSA     : (Conjugate) Transpose of A
%   
%   Here is a table containing all possible combinations of options: 
%
%   LT  UT  UHESS  SYM  POSDEF  RECT  TRANSA   Output R
%   -----------------------------------------  ----------------
%   T   F   F      F    F       T/F   T/F      condition number
%   F   T   F      F    F       T/F   T/F      condition number
%   F   F   T      F    F       F     T/F      condition number
%   F   F   F      T    T/F     F     T/F      condition number
%   F   F   F      F    F       T/F   T/F      rank
%
%   Example: 
%   A = triu(rand(5,3)); x = [1 1 1 0 0]'; b = A'*x;
%   y1 = (A')\b         
%   opts.UT = true; opts.TRANSA = true;
%   y2 = linsolve(A,b,opts)
%  
%   See also MLDIVIDE, SLASH.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 1.1.6.4 $  $Date: 2010/02/01 03:14:26 $
%   Built-in function.

