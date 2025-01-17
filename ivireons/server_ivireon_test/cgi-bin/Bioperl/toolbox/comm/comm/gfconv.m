function c = gfconv(a, b, p)
%GFCONV Multiply polynomials over a Galois field.
%   C = GFCONV(A, B) multiplies two GF(2) polynomials A and B.
%   The polynomial degree of the resulting GF(2) polynomial C equals
%   the degree of A plus the degree of B.
%
%   A, B and C are row vectors that specify the polynomial coefficients in
%   order of ascending powers.
%
%   C = GFCONV(A, B, P) multiplies the two GF(P) polynomials, A and B, where
%   P is a scalar prime number.
%
%   C = GFCONV(A, B, FIELD) multiplies two GF(P^M) polynomials, where FIELD
%   is a matrix that contains the M-tuple of all elements in GF(P^M). P is
%   a prime number and M is a positive integer. To generate the M-tuple of
%   all elements in GF(P^M), use FIELD = GFTUPLE([-1:P^M-2]', M, P).
%
%   In this syntax, each coefficient is specified in exponential format,
%   that is, [-Inf, 0, 1, 2, ...] represent the field elements
%   [0, 1, alpha, alpha^2, ...] in GF(P^M).
%
%   Note: This function performs computations in GF(P^M) where P is prime. To
%   work in GF(2^M), you can also use the CONV function with Galois arrays.
%
%   Example 1:
%       % In GF(5): (1+ 2x+ 3x^2+ 4x^3)*(1+ x) = (1+ 3x+ 2x^3+ 4x^4)
%       c = gfconv([1 2 3 4], [1 1], 5)
%
%   Example 2: 
%       % In GF(2^4):
%       field = gftuple([-1:2^4-2]', 4, 2);
%       c = gfconv([1 2 3 4 5],[1 1],field)
%
%   See also GFDECONV, GFADD, GFSUB, GFTUPLE, GFMUL.

%   Copyright 1996-2008 The MathWorks, Inc.
%   $Revision: 1.13.4.4 $ $Date: 2008/08/01 12:17:35 $