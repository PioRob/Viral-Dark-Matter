function cleanup(this) 
% CLEANUP
%
 
% Author(s): John W. Glass 15-Dec-2006
% Copyright 2006 The MathWorks, Inc.
% $Revision: 1.1.10.1 $ $Date: 2007/02/06 20:00:11 $

% Delete UDD nodes
delete(this.Root);
delete(this.Listeners);

% Delete JAVA components.
this.ExplorerPanel = [];