function chart = getSFChartObject(blkObj)
%GETSFCHARTOBJECT Get the stateflow chart object from the Subsystem masking
%a chart.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2010/05/20 02:18:25 $

% getHierarchicalChildren() on a Subsystem containing a chart may have more
% than 1 child. Use the find() method instead to get thte SF chart object that the
% node points to. Restrict the find to Chart types because other stateflow
% objects might have the same name returning more than one object.
chart = find(blkObj,'-depth',1,'Name',blkObj.Name,'-isa',...
    'Stateflow.Chart','-or','-isa','Stateflow.EMChart','-or','-isa',...
    'Stateflow.TruthTableChart','-or','-isa','Stateflow.LinkChart'); %#ok<*GTARG>


% [EOF]
