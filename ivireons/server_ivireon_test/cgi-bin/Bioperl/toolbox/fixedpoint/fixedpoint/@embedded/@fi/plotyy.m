function varargout =plotyy(varargin)
%PLOTYY Create graph with y-axes on right and left sides
%   Refer to the MATLAB PLOTYY reference page for more information.
%
%   See also PLOTYY

%   Thomas A. Bryan, 2 November 2004
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2006/11/19 21:19:18 $

c = todoublecell(varargin{:});
[varargout{1:nargout}] = feval(mfilename,c{:});
