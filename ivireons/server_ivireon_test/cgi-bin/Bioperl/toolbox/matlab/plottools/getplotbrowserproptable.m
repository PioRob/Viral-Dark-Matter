function allPropNames = getplotbrowserproptable

% allPropNames:  This table maps various HG object types to the properties
% that the plotbrowser is interested in.  We'll use this table to set up
% property post-set listeners as the HG objects are created.

%   Copyright 2009-2010 The MathWorks, Inc.
if feature('HGUsingMATLABClasses')

%   Copyright 2007-2010 The MathWorks, Inc.

    allPropNames = ...
        {{'matlab.graphics.axis.Axes', ...
            {'Visible', 'HandleVisibility', 'Title'}}, ...
         {'tsguis.uitspanel', ...
            {'Visible', 'HandleVisibility', 'Name'}}, ...
         {'matlab.ui.container.Panel', ...
            {'Visible', 'HandleVisibility', 'Title'}}, ...
         {'matlab.graphics.chart.primitive.Line', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'matlab.graphics.chart.primitive.Stem', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'matlab.graphics.chart.primitive.Stair', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'matlab.graphics.chart.primitive.Bar', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'matlab.graphics.chart.primitive.Area', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'matlab.graphics.chart.primitive.ErrorBar', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'LineStyle'}}, ...
         {'matlab.graphics.chart.primitive.Scatter', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'matlab.graphics.chart.primitive.Contour', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'LineColor', 'Fill'}}, ...
         {'matlab.graphics.chart.primitive.Quiver', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'LineStyle', 'ShowArrowHead'}}, ...
         {'graphThreeD.surfaceplot', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'hg2.Line', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'hg2.Patch', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'hg2.Surface', ...
            {'Visible', 'HandleVisibility', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'hg2.Image', ...
            {'Visible', 'HandleVisibility'}}, ...      
         {'matlab.graphics.chart.primitive.FunctionLine', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'matlab.graphics.chart.primitive.ConstantLine', ...
            {'Visible', 'HandleVisibility', 'Tag', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}};
else              
    allPropNames = ...
        {{'axes', ...
            {'Visible', 'HandleVisibility', 'Title'}}, ...
         {'tsguis.uitspanel', ...
            {'Visible', 'HandleVisibility', 'Name'}}, ...
         {'uipanel', ...
            {'Visible', 'HandleVisibility', 'Title'}}, ...
         {'graph2d.lineseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'specgraph.stemseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'specgraph.stairseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'specgraph.barseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'specgraph.areaseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'specgraph.errorbarseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'LineStyle'}}, ...
         {'specgraph.scattergroup', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'specgraph.contourgroup', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'LineColor', 'Fill'}}, ...
         {'specgraph.quivergroup', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'LineStyle', 'ShowArrowHead'}}, ...
         {'graph3d.surfaceplot', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'line', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'patch', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'surface', ...
            {'Visible', 'HandleVisibility', ...
             'FaceColor', 'EdgeColor'}}, ...
         {'image', ...
            {'Visible', 'HandleVisibility'}}, ...
         {'graph2d.functionline', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'graph2d.constantline', ...
            {'Visible', 'HandleVisibility', 'Tag', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}, ...
         {'graph2d.constantlineseries', ...
            {'Visible', 'HandleVisibility', 'DisplayName', ...
             'Color', 'LineWidth', 'Linestyle',  ...
             'Marker', 'MarkerEdgeColor', 'MarkerFaceColor'}}};
end