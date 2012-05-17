function aObj = dodrag(aObj, varargin)
%AXISOBJ/DODRAG Drag axisobj object
%   This file is an internal helper function for plot annotation.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 1.4.4.3 $  $Date: 2009/06/22 14:32:30 $

figH = get(aObj,'Figure');

initialPosition = varargin{1};
myHG = get(aObj,'MyHGHandle');

% [savedState.iPoints, aObj] = selectpoints(aObj, X, Y, pointX, pointY);

dragConstraint = get(aObj,'DragConstraint');

savedState = struct(...
        'me', aObj,...
        'myOldUnits', get(aObj,'Units'),...
        'DragConstraint', dragConstraint,...
        'Fig', figH,...
        'PointX', initialPosition(1),...
        'PointY', initialPosition(2),...
        'SelType', get(figH,'SelectionType'));

set(aObj,'Units',get(figH,'Units'));
axPos = get(aObj,'Position');

savedState.OffsetX = savedState.PointX-axPos(1);
savedState.OffsetY = savedState.PointY-axPos(2);


aObj = set(aObj,'SavedState',savedState);
