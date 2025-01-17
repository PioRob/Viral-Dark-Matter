function setPlotConfigurationData(this,data,row,col)
%setPlotConfigurationData  Method to set the current plot configurations
%for a view.
%
%  Author(s): John Glass
%  Copyright 1986-2005 The MathWorks, Inc.

% Convert to MATLAB index units
row = row + 1;
col = col + 1;

% Total number of possible lti plot views
NUMBER_OF_PLOTS = 6;

% Update the LTIVIEWER for the update in the plot configuration table
switch col
    case 2
        %% Compute the new plot type
        util = com.mathworks.toolbox.slcontrol.util.LTIPlotUtils;
        this.PlotConfigurations{row,2} = char(util.getPlotTypefromComboLabel(data(row,2)));
    
        updateVisibleSystemsColumns(this,row)
        
        %% Update the LTIVIEWER
        if isa(this.LTIViewer,'viewgui.ltiviewer')
            %% Disable the listeners
            this.ViewListener.Enabled = 'off';
            
            %% Get the handle to the explorer frame
            ExplorerFrame = slctrlexplorer;
            
            %% Clear the status area
            ExplorerFrame.clearText;
            
            %% Post the text 
            ExplorerFrame.postText(sprintf(' - Please Wait Updating the LTIViewer'))
            
            %% Create a cell array of available plots
            currentviews = {};
            for ct = 1:NUMBER_OF_PLOTS
                if ~strcmp(this.PlotConfigurations{ct,2},'None')
                    currentviews{end+1} = this.PlotConfigurations{ct,2};
                end
            end
            
            this.LTIViewer.setCurrentViews(currentviews);
            
            %% Post the text 
            ExplorerFrame.postText(sprintf(' - Update completed'))
            
            %% Find the number of visible plot axes before this plot
            nprevplots = sum(~strcmp(this.PlotConfigurations(1:row,2),'None'));
            
            %% Update the title
            if nprevplots > 0 
                vh.Views(nprevplots).AxesGrid.Title = this.PlotConfigurations{row,3};
                
                %% Fire the table update event
                thr = com.mathworks.toolbox.control.spreadsheet.MLthread(...
                    this.Handles.PlotSetupTableModel, 'fireTableCellUpdated',...
                    {int32(row-1); int32(2)},'int,int');
                javax.swing.SwingUtilities.invokeLater(thr);
            end
            
            %% Update the visibility of the plots
            updateVisibility(this)            
            %% Add listener to the AxesGrids of the views for title changes
            createTitleListener(this)
            %% Update the listeners for the visible systems
            createVisibilityListeners(this)
            
            %% Re-Enable the listeners
            this.ViewListener.Enabled = 'on';
        end
    case 3
        %% Update the plot title
        this.PlotConfigurations{row,3} = data(row,3);

        %% Compute the number of visible plots
        plotvisible = ~strcmp(this.PlotConfigurations(row,2),'None');
        if isa(this.LTIViewer,'viewgui.ltiviewer') && (plotvisible)
            %% Find the number of visible plot axes before and including this plot
            nprevplots = sum(~strcmp(this.PlotConfigurations(1:row,2),'None'));

            %% Update the LTIViewer
            this.LTIViewer.Views(nprevplots).AxesGrid.Title = data(row,3);
        end
end
