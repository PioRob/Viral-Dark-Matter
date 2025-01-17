function m = addCharMenu(hplot, CharMenuHandle, CharID, dataClass, viewClass)
%ADDCHARMENU   Adds menus for wave characteristics.
%
%   ADDCHARMENU returns the handle of the new or existing submenu of 
%   CharMenuHandle matching the identifier LABEL.

%  Author(s): James Owen
%  Revised:   Kamesh Subbarao
%   Copyright 1986-2007 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:29:09 $

% CharMenuHandle is the handle of the 'Characteristics' context menu
% dataClass and viewClass are strings defining the view and data classes for 
% the characteristic 

% Create submenu for specified characteristic if it does not already exist

subMenus=get(CharMenuHandle,'Children');
m = subMenus(strcmpi(CharID,get(subMenus,'Label')));
if isempty(m)
    m = uimenu('Parent',CharMenuHandle,'Label',CharID,...
        'Callback',@(x,y) localCallback(x,hplot,CharID,dataClass,viewClass),...
        'UserData',{CharID,dataClass,viewClass});
end

%-------------------- Local Functions --------------------------

function localCallback(eventSrc, hplot, Identifier, dataClass, viewClass)
% Toggles characteristic visibility based on checked state of menu
m = eventSrc;  % menu handle
if strcmp(get(m,'checked'),'on');
  newState='off';
else
  newState='on';
end

% Update menu check
set(m,'checked',newState);

% Add characteristic to waveform's that don't already have it, and set its global visibility
hplot.addchar(Identifier,dataClass,viewClass,'Visible',newState)
