function setPanelVisibility(this, bShow, selectedNode)
%SETPANELVISIBILITY This panel is being hidden or displayed.
%
%   Function arguments
%   ------------------
%   THIS: The hdfPanel object instance.
%   BSHOW: Display Panel?
%   SELECTEDNODE: The node for which this panel is being displayed.

%   Copyright 2005-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2009/01/16 11:06:57 $

    % Will we show or hide the panel?
    if bShow
        % Set the workspace variable name
        set(this.fileTree,'wsvarname', selectedNode.nodeinfostruct.Name);

        % Update the type-specific information
        this.updateNodeInfo(selectedNode);

        if strcmpi(get(this.mainpanel, 'visible'), 'off')
            set(this.mainpanel, 'Visible','on');
        end

        % Set the import command
        this.buildImportCommand(false);

        set(this.subsetPanel, 'Visible', 'on');
        title = sprintf('%s: %s', xlate('Import'), xlate(this.title));
        set(this.mainpanel, 'Title', title);

        % Enable the resetSelectionParameters button if we find any
        % UICONTROLS on the panel.
        resetButton = findobj(this.mainPanel, 'tag', 'resetSelectionParameters');
        if ~isempty(resetButton)
            allControls = findobj(this.subsetPanel,...
                'type', 'uicontrol', '-and', 'visible', 'on',...
                '-or',...
                'type', 'uitable');
            subsetting = findobj(this.subsetPanel,...
                'tag', 'subsettingMethod',...
                '-or',...
                'string', 'Subsetting method:');
            if length(allControls) > length(subsetting) || ...
                    any(allControls~=subsetting) 
                set(resetButton, 'enable', 'on');
            else
                set(resetButton, 'enable', 'off');
            end
        end

    else
        set(this.mainpanel, 'Visible','off');
        set(this.subsetPanel, 'Visible', 'off');
    end
end

