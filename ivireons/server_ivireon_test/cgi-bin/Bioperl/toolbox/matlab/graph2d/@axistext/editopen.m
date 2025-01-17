function aObj = editopen(aObj)
%AXISTEXT/EDITOPEN Edit axistext object
%   This file is an internal helper function for plot annotation.

%   Copyright 1984-2008 The MathWorks, Inc. 
%   $Revision: 1.11.4.2 $  $Date: 2008/08/14 01:37:45 $


aObj = set(aObj,'Editing','on');
HG = get(aObj,'MyHGHandle');

% save current changes
ud = getscribeobjectdata(HG);
ud.ObjectStore = aObj;
setscribeobjectdata(HG,ud);

fig = get(get(HG,'Parent'),'Parent');
plotedit(fig,'setsystemeditmenus');
waitfor(HG,'Editing','off');

if ishghandle(HG) 
   if ishghandle(fig)
      plotedit(fig,'setploteditmenus');
   end
   % aObj may have changed, since there was a click to 
   % deactivate editing
   A = getobj(HG);
   aObj = A.Object;
else
   aObj = [];
   % domymenu.m or @scribehandle/doclick will catch this...
end