function figuredeletedlistener(fig, object)
%FIGUREDELETEDLISTENER
%   FIGUREDELETEDLISTENER(fig, object) will add or remove listeners that will signal when 
%   the specified figure is removed.
%   
%   fig is the figure  
%   
%   object is the interested party
%   

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.7.4.3 $  $Date: 2008/12/15 08:52:46 $

if ~ishghandle(fig)
	return;
end
if isappdata(fig, 'Fig_Delete_Listener') 
	return;
end
%hgp = findpackage('hg');
%rootC = findclass(hgp, 'root');

FigDelListeners.figureRemoved = addlistener(fig, 'ObjectBeingDestroyed', @(o,e) figureRemoved(o,e, fig, object));

setappdata(fig, 'Fig_Delete_Listener', FigDelListeners);

%-------------------------------------------------------------------------------------

% Listen for figures being removed.
 
function figureRemoved(hSrc, event, fig, javaObj)
	if isappdata(fig,'Fig_Delete_Listener')
		javaObj.FigureRemoved(fig);
	end
