function Y = ifft(x)
%IFFT Inverse Discrete Fourier transform.
%   IFFT(X) is the inverse discrete Fourier transform of the vector X.  
%
%   See also FFT.

%    Copyright 1996-2007 The MathWorks, Inc.
%    $Revision: 1.4.4.1 $  $Date: 2007/09/14 15:58:51 $

% x must be a vector
if ((size(x,1)>1 & size(x,2)>1) | length(size(x)) == 3  )
    error('comm:gf_ifft:InvalidX','X Must be a vector.')
end

% turn x into a column vector if it isn't already
size_X = size(x);
x_col = reshape(x,max(size_X),1);
if(length(x_col)~= 2^x.m-1)
    error('comm:gf_ifft:InvalidXLen','Length of X must equal 2^m-1');
end

alpha = gf(2,x.m,x.prim_poly);
Y = dftmtx(1/alpha)*x_col;

Y = reshape(Y,size_X(1),size_X(2));