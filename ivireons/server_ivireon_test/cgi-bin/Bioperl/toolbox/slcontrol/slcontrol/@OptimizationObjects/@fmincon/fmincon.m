function this = fmincon(opcond,options,LinearizationIOs)

%  Author(s): John Glass
%  Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2007/12/14 15:27:03 $

% Construct the object
this = OptimizationObjects.fmincon;
this.LinearizationIOs = LinearizationIOs;
this.linoptions = options;
initialize(this,opcond);