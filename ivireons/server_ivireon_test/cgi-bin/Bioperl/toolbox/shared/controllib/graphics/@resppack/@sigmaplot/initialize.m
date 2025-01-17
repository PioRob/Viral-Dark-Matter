function initialize(this, ax, gridsize)
%  INITIALIZE  Initializes the @sigmaplot objects.

%  Author(s): K. Subbarao
%  Copyright 1986-2009 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:24:08 $

% Axes geometry parameters 
geometry = struct('HeightRatio',[],...
   'HorizontalGap', 16, 'VerticalGap', 16, ...
   'LeftMargin', 12, 'TopMargin', 20);

% Create @axesgrid object
this.AxesGrid = ctrluis.axesgrid([1 1], ax, ...
   'Visible',     'off', ...
   'Geometry',     geometry, ...
   'LimitFcn',    {@updatelims this}, ...
   'Title',       'Singular Values', ...
   'XLabel',      'Frequency',...
   'XScale',      'log',...
   'XUnit',       'rad/sec',...
   'YLabel',      'Singular Values',...
   'YScale',      'linear',...
   'YUnit',       'dB');

% Generic initialization
init_graphics(this)

% Add standard listeners
addlisteners(this)

