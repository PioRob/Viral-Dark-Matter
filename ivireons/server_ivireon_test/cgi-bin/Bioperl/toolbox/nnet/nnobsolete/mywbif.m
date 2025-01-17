function w = mywbif(s,pr)
%MYWBIF Example custom weight and bias initialization function.
%
% Obsoleted in R2010b NNET 7.0.  Last used in R2010a NNET 6.0.4.
%
%  This function is obselete.
%  Use TEMPLATE_INIT_WB to design your function.

nnerr.obs_fcn('mywbif','Use TEMPLATE_INIT_WB to design your function.')

%  Use this function as a template to write your own function.
%  
%  Syntax
%
%    W = rands(S,PR)
%      S  - number of neurons.
%      PR - Rx2 matrix of R input ranges.
%      W - SxR weight matrix.
%
%    b = rands(S)
%      S  - number of neurons.
%      b - Sx1 bias vector.
%
%  Example
%
%    W = mywbif(4,[0 1; -2 2])
%    b = mywbif(4,[1 1])

% Copyright 1997-2010 The MathWorks, Inc.
% $Revision: 1.1.6.3 $

if nargin < 1, nnerr.throw('Not enough input arguments'), end

if nargin == 1
  w = rand(s,1)*0.2;  % <-- Replace with your own initial bias vector
else
  r = size(pr,1);     % <-- Replace with your own initial weight matrix
  w = rand(s,r)*0.1;
end
