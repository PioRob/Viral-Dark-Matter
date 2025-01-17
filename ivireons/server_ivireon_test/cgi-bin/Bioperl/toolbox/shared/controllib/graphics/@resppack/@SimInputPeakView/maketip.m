function str = maketip(this,tip,info)
%MAKETIP  Build data tips for SimInputPeakView Characteristics.

%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:19:13 $
AxGrid = info.View.AxesGrid;
InputIndex = info.ArrayIndex;
iName = info.Carrier.ChannelName{InputIndex};
if isempty(iName)
   iName = sprintf('Input: In(%d)',InputIndex);
else
   iName = sprintf('Input: %s',iName);
end
str = {iName ; ...
      sprintf('Peak amplitude: %0.3g',info.Data.PeakResponse(1)) ;...
      sprintf('At time (%s): %0.3g', AxGrid.XUnits, info.Data.Time(1))};
