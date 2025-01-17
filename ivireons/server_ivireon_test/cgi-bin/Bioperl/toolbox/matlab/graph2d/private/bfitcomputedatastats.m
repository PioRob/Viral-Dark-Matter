function [x_str, y_str] = bfitcomputedatastats(datahandle)
% BFITCOMPUTEDATASTATS Compute stats to fill Data Stats GUI table.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $  $Date: 2005/08/17 23:15:28 $

% get data
xdata = get(datahandle,'xdata');
ydata = get(datahandle,'ydata');

% compute stats
xy = [xdata(:) ydata(:)];
% compute along 1st dim explicitly so works for 1 data point
results = [ min(xy,[],1); 
    max(xy,[],1); 
    mean(xy,1);
    median(xy,1);
    mode(xy, 1);
    std(xy,0,1);
    max(xy,[],1) - min(xy,[],1);];

xstats = results(:,1);
ystats = results(:,2);

[x.min,x.max,x.mean,x.median,x.mode,x.std,x.range] = deal(xstats(1),xstats(2),xstats(3),xstats(4),xstats(5),xstats(6),xstats(7));
[y.min,y.max,y.mean,y.median,y.mode,y.std,y.range] = deal(ystats(1),ystats(2),ystats(3),ystats(4),ystats(5),ystats(6),ystats(7));

% place to store stats
setappdata(double(datahandle),'Data_Stats_X',x);
setappdata(double(datahandle),'Data_Stats_Y',y);


format = '%-12.4g';
x_str = cellstr(num2str(xstats,format));
y_str = cellstr(num2str(ystats,format));
