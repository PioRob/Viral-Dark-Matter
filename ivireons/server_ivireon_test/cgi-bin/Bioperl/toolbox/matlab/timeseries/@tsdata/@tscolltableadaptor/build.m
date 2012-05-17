function build(h)

% Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $ $Date: 2009/10/29 15:23:08 $

import com.mathworks.toolbox.timeseries.*;

% Build a table of timeseries data backed by table model which uses a
% MATLAB variable.

% Build table and model 
h.TableModel = TimeSeriesObjectTableModel(h);
h.Table = javaObjectEDT('com.mathworks.toolbox.timeseries.TimeSeriesTable',...
    h.TableModel);
h.ScrollPane = javaObjectEDT('com.mathworks.mwswing.MJScrollPane',h.Table);
h.TableModel.setTableParent(h.Table);
h.updatecache(0);

% Create data change listener to update the table
h.Tslistener = [handle.listener(h.Timeseries,'Datachange',{@localUpdate h});...
                handle.listener(h.Timeseries,h.Timeseries.findprop('Name'),...
                   'PropertyPostSet',{@localUpdate h})];
 

function localUpdate(es,ed,h) %#ok<*INUSL>

import java.awt.*;

% Update the cache for the current scroll position
currentRow = h.Table.rowAtPoint(Point(0,h.ScrollPane.getVerticalScrollBar.getValue));
h.updatecache(currentRow);