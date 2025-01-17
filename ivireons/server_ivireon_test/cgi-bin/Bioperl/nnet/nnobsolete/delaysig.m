function y=delaysig(x,d1,d2)
%DELAYSIG Create delayed signal matrix from signal matrix.
%
% Obsoleted in R2010b NNET 7.0.  Last used in R2010a NNET 6.0.4.
%
%  This function is obselete.
%  Use cell arrays to represent sequences.

nnerr.obs_fcn('delaysig','Use cell arrays to represent sequencies.')

%
%  DELAYSIG(X,D)
%    X - SxT  matrix with S-element column vectors for T timesteps.
%    D - Maximum delay.
%  Returns signal X delayed by 0, 1, ..., and D2 timesteps.
%  
%  DELAYSIG(X,D1,D2)
%    X - SxT  matrix with S-element column vectors for T timesteps.
%    D1 - Minimum delay.
%    D2 - Maximum delay.
%  Returns signal X delayed by D1, D1+1, ..., and D2 timesteps.
%  
%  The signal X can be a row vector of values, or a matrix
%  of (column) vectors.
%  
%  EXAMPLE: X = [1 2 3 4 5; 10 9 8 7 6];
%           Y = delaysig(X,1,3)

% Mark Beale, 12-15-93
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.11.4.1 $  $Date: 2010/03/22 04:06:36 $

[xr,xc] = size(x);

if nargin == 2
  d2 = d1;
  d1 = 0;
end

y = zeros(xr*(d2-d1+1),xc);

for i=0:(d2-d1)
  y((1:xr)+xr*i,(i+d1+1):xc) = x(:,1:(xc-i-d1));
end
