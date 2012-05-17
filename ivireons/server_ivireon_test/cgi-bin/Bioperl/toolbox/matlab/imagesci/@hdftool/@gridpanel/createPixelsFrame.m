function [hPixelsFrame api] = createPixelsFrame(this, hParent)
%CREATEPIXELSFRAME Construct a frame for the "TILE" subsetting method.
%
%   Function arguments
%   ------------------
%   THIS: the gridPanel object instance.
%   HPARENT: the panel which will be our HG parent.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2009/02/06 14:22:45 $

    % Create the components.
    hPixelsFrame = uipanel('Parent', hParent);
    prefs = this.fileTree.fileFrame.prefs;

    topPanel = uiflowcontainer('v0', 'Parent',hPixelsFrame,...
            'BackgroundColor', get(0,'defaultUiControlBackgroundColor'), ...
            'FlowDirection','TopDown');

    [cornerboxPanel, cornerboxApi, cornerboxMinsize] = ...
        this.createBoxCornerGroup(topPanel, '0', prefs);

    % Create the API.
    api.getBoxCornerValues = @getBoxCorners;
    api.reset              = @reset;

    %=======================================================
    function out = getBoxCorners()
        out = [cornerboxApi.getBoxCorner1Values()';...
            cornerboxApi.getBoxCorner2Values()'];

    end

    %=======================================================
    function reset(istruct)
        cornerboxApi.reset();
    end
end
