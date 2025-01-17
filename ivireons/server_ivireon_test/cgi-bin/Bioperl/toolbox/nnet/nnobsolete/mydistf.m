function d = mydistf(pos)
%MYDISTF Example custom distance function.
%
% Obsoleted in R2010b NNET 7.0.  Last used in R2010a NNET 6.0.4.
%
%  Use this function as a template to write your own function.
%  
%  This function is obselete.
%  Use TEMPLATE_DISTANCE to design your function.

nnerr.obs_fcn('mydistf','Use TEMPLATE_DISTANCE to design your function.')

%  Use this function as a template to write your own function.
%  
%     Syntax
%
%    d = mydistf(pos)
%      pos - NxS matrix of S neuron position vectors.
%      d   - SxS matrix of neuron distances.
%
%  Example
%
%    pos = gridtop(3,2);
%    d = mydistf(pos)

% Copyright 1997-2010 The MathWorks, Inc.
% $Revision: 1.1.6.2 $

s = size(pos,2);
for i=1:s
  for j=1:s
  
% ** Replace the following line of code with your own
% ** measure of distance.
  
    d(i,j) = norm(pos(:,i)-pos(:,j),1.5);
    
  end
end
