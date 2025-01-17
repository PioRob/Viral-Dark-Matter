function [w,ierr] = bessely(nu,z,scale)
%BESSELY Bessel function of the second kind.
%   Y = BESSELY(NU,Z) is the Bessel function of the second kind, Y_nu(Z).
%   The order NU need not be an integer, but must be real.
%   The argument Z can be complex.  The result is real where Z is positive.
%
%   If NU and Z are arrays of the same size, the result is also that size.
%   If either input is a scalar, it is expanded to the other input's size.
%   If one input is a row vector and the other is a column vector, the
%   result is a two-dimensional table of function values.
%
%   Y = BESSELY(NU,Z,0) is the same as BESSELY(NU,Z).
%
%   Y = BESSELY(NU,Z,1) scales Y_nu(z) by exp(-abs(imag(z)))
%
%   [Y,IERR] = BESSELY(NU,Z) also returns an array of error flags.
%       ierr = 1   Illegal arguments.
%       ierr = 2   Overflow.  Return Inf.
%       ierr = 3   Some loss of accuracy in argument reduction.
%       ierr = 4   Complete loss of accuracy, z or nu too large.
%       ierr = 5   No convergence.  Return NaN.
%
%   Examples:
%
%       bessely(3:9,(0:.2:10)') generates the entire table on page 399
%       of Abramowitz and Stegun, Handbook of Mathematical Functions.
%
%   BESSELY uses a MEX interface to a Fortran library by D. E. Amos.
%
%   Class support for inputs NU and Z:
%      float: double, single
%
%   See also BESSELJ, BESSELI, BESSELK, BESSELH.

%   Reference:
%   D. E. Amos, "A subroutine package for Bessel functions of a complex
%   argument and nonnegative order", Sandia National Laboratory Report,
%   SAND85-1018, May, 1985.
%
%   D. E. Amos, "A portable package for Bessel functions of a complex
%   argument and nonnegative order", Trans.  Math. Software, 1986.
%
%   Copyright 1984-2010 The MathWorks, Inc. 
%   $Revision: 5.15.4.3 $  $Date: 2010/05/13 17:42:45 $

if nargin == 2, scale = 0; end
[msg,nu,z,siz] = besschk(nu,z); error(msg);
[w,ierr] = besselmx(double('Y'),nu,z,scale);
% clean up w in case besselmx left an all-zero imaginary part
if ~isempty(w) && all(all(imag(w) == 0)), w = real(w); end
w = reshape(w,siz);
