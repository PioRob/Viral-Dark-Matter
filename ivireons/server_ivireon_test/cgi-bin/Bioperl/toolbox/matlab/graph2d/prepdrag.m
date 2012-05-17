function prepdrag(varargin)
%PREPDRAG  Plot Editor helper function
%
%   See also PLOTEDIT

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.17.4.2 $  $Date: 2005/12/15 20:53:35 $

persistent initialPoint;

switch nargin
case 0 % reset
   clear initialPoint;
   fig = gcbf;
   currentObj = getappdata(fig,'ScribeCurrentObject');
   selType = get(fig,'SelectionType');
   doselect(currentObj, selType, getobj(fig), 'up');
   set(gcbf,'Pointer','arrow',...
           'WindowButtonMotionFcn','',...
           'WindowButtonUpFcn','');
case 2 % initialize
   initialPoint = varargin{2};
case 1 % start dragging
   fig = gcbf;
   set(fig,...
           'WindowButtonMotionFcn','',...
           'WindowButtonUpFcn','');
   ud = getscribeobjectdata(fig);
   figObj = ud.ObjectStore;
   dragBin = figObj.DragObjects;
   dragItems = dragBin.Items;
   axesHandles = [];
   for aObjH = dragItems
      if ~get(aObjH, 'Draggable')
         set(aObjH,'IsSelected',0);
      else  % look for axisobj objects
         if strcmp(get(aObjH,'Type'),'axes')
            axesHandles(end+1)=get(aObjH,'MyHGHandle');
         end
      end
   end

   if ~isempty(axesHandles)
      axesLabels = get(axesHandles,...
              {'XLabel' 'YLabel' 'ZLabel' 'Title'});
      axesLabels = [axesLabels{:}];
   end

   % store old figure units
   setappdata(fig,'ScribeSaveFigUnits',get(fig,'Units'));
   % work in absolute units
   set(fig,'Units','pixels');
   % get new current point in pixels
   initialPoint = get(fig,'CurrentPoint');
   
   dragItems = dragBin.Items;
   for aObjH = dragItems
      if ~isempty(axesHandles) && any(get(aObjH,'MyHGHandle')==axesLabels)
         set(aObjH,'IsSelected',0);
      else
         dodrag(aObjH,initialPoint);
      end
   end
   
   set(fig,...
         'WindowButtonMotionFcn','middrag(gcbo)',...
         'WindowButtonUpFcn','enddrag(gcbo)');
   clear initialPoint dragItems;
end

