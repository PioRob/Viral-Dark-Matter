function str = maketip(this,tip,info)
%MAKETIP  Build data tips for @siminputviewPaired
%
%   INFO is a structure built dynamically by the data tip interface
%   and passed to MAKETIP to facilitate construction of the tip text.

%   Author(s): P. Gahinet
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:24:32 $
AxGrid = info.View.AxesGrid;

% Finalize Y data
Y = tip.Position(2);
if strcmp(AxGrid.YNormalization,'on')
   ax = getaxes(info.Tip);
   Y = denormalize(info.Data,Y,get(ax,'XLim'));
end
   
% Create tip text
InputIndex = info.ArrayIndex;
iName = info.Carrier.ChannelName{info.Row};
if isempty(iName)
   iName = sprintf('Input: In(%d)',info.Row);
else
   iName = sprintf('Input: %s',iName);
end
str = {iName ; ...
      sprintf('Time (%s): %0.3g', AxGrid.XUnits, tip.Position(1)) ;...
      sprintf('Amplitude: %0.3g', Y)};
