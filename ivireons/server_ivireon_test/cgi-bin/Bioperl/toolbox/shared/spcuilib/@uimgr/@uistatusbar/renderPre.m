function renderPre(h,hPropParent)
%RENDERPRE

%   Author(s): J. Yu
%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2008/08/01 12:25:13 $

% If the uicontainer is created under uiflowcontainer with HG figure
% set the uicontainer as the graphical parent of uistatusbar.
if ishghandle(hPropParent, 'figure')
    hUI = getappdata(hPropParent, 'UIMgr');
    if ~isempty(hUI)
        h.GraphicalParent = hUI.hStatusParent;
    end
end

if isempty(h.GraphicalParent) || ~ishghandle(h.GraphicalParent)
    % See if hPropParent type is useful for the buttongroup:
    %    empty/invalid: create a new or use existing figure,
    %           then see below
    %    figure, others: create new toolbar under figure
    %
    % An error can be generated by the widget function if an invalid
    % parent is used. A uitoolbar is the most common parent here.
    %
    if isempty(hPropParent) || ~ishghandle(hPropParent)
        hPropParent = gcf;
    end
    h.GraphicalParent = hPropParent;
end

% [EOF]
