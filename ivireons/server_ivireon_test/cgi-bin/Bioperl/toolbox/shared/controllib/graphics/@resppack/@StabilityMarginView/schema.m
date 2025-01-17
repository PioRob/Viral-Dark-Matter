function schema
%  SCHEMA  Defines properties for @StabilityMarginView parent class

%  Author(s): John Glass
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:19:23 $

% Register class
pkg = findpackage('wrfc');
c = schema.class(findpackage('resppack'), 'StabilityMarginView', pkg.findclass('view'));

% Public attributes
schema.prop(c, 'MagPoints', 'MATLAB array');    
schema.prop(c, 'MagLines', 'MATLAB array');
schema.prop(c, 'MagCrossLines', 'MATLAB array');
schema.prop(c, 'MagTips', 'MATLAB array');
schema.prop(c, 'PhasePoints', 'MATLAB array');    
schema.prop(c, 'PhaseLines', 'MATLAB array');     
schema.prop(c, 'PhaseCrossLines', 'MATLAB array');
schema.prop(c, 'PhaseTips', 'MATLAB array');