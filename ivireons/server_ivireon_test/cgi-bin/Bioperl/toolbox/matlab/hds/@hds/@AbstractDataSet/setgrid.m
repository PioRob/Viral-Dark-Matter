function setgrid(this,varargin)
%SETGRID  Defines underlying grid for gridded data sets.
%
%   SETGRID(D,X1,X2,...XN) specifies an N-dimensional grid for 
%   the data set D.  The grid data for the j-th grid dimension 
%   is specified by Xj, which can be either
%    (1) a string or string vector containing the names of the  
%        variables for this grid dimension.
%    (2) a vector of @variable object sdescribing the variables 
%        for this grid dimension.
%
%   Example:
%      d = hds.dataset('demo',{'x','y','z'})
%      d.setgrid('x','y');          % 2D grid
%      d.x = [1 2 3];
%      d.y = [4 5];
%      d.z = randn(3,2);
% 
%   See also GETGRID.

%   Author(s): P. Gahinet
%   Copyright 1986-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2005/12/22 18:13:38 $
ndims0 = length(this.Grid_);
ndims = length(varargin);
if ndims0>0 && ndims0~=ndims
   error('Number of grid dimensions cannot be redefined.')
end

% Data set variable list
AllVars = getvars(this);
GridDim = zeros(size(AllVars));

if ~isempty(AllVars)
    % Update grid info
    for ct=1:ndims
       % Locate specified variables
       try
          idx = locate(AllVars,varargin{ct});
       catch
          rethrow(lasterror)
       end
       this.Grid_(ct).Variable = AllVars(idx);
       this.Grid_(ct).Length = 0;
       GridDim(idx) = ct;
    end
    % RE: Keeps track of what variables belong to which dim of the grid
    this.Cache_.GridDim = GridDim; 
end