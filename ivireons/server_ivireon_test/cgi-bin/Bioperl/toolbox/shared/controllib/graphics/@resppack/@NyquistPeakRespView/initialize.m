function initialize(this,Axes)
%INITIALIZE  Initialization for @NyquistPeakRespView class

%  Author(s): John Glass
%  Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:18:46 $

[s1,s2] = size(Axes(:,:,1)); 

Lines = zeros([s1 s2]);
Points = zeros([s1 s2]);

for ct=1:prod([s1 s2])
   % Plot characteristic lines
   Lines(ct) = line([NaN,NaN],[NaN,NaN],[-10,-10],...
      'Parent',Axes(ct),...
      'Visible','off',...
      'LineStyle','-.',...
      'Selected','off',...
      'HandleVisibility','off',...
      'XLimInclude','off',...
      'YLimInclude','off',...
      'HitTest','off',...
      'Color','k');
   %% Plot characteristic points
   Points(ct) = line(NaN,NaN,[5],...
      'Parent',Axes(ct),...
      'Visible','off',...
      'Marker','o',...
      'MarkerSize',6);
end

this.Lines = handle(Lines);
this.Points = handle(Points);
this.PointTips = cell([s1 s2]);