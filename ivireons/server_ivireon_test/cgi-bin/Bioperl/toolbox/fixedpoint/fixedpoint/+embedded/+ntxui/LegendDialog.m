classdef LegendDialog < dialogmgr.DialogContent
    % Implement legend dialog for NTX

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $     $Date: 2010/05/20 02:17:43 $
    
    properties (Access=private)
        % Handles to widgets within the main dialog panel
        htNormalText
        htNormalBar
        htOverflowText
        htOverflowBar
        htUnderflowText
        htUnderflowBar
    end
    
    methods
        function dlg = LegendDialog(ntx)
            dlg.Name = 'Legend';
            dlg.UserData = ntx; % record NTX application handle
        end
    end
    
    methods (Access=protected)
        function createContent(dlg)
            % Widgets within dialog are created in this method
            %
            % All widgets should be parented to hParent, or to a
            % child of hParent.
            
            hParent = dlg.ContentPanel;
            set(hParent,'tag','legend_dialog_panel');
            bg = get(hParent,'BackgroundColor');
            ppos = get(hParent,'pos');
            pdx = ppos(3); % initial width of parent panel, in pixels
            
            ntx = dlg.UserData;
            
            yB = 8; % # pix between border and widgets
            xB = 8; % # pix between border and widgets
            xG = 6; % # pix between bars and text
            pdx2 = floor(pdx/2); % midpoint
            xL = xB;
            dxL = pdx2-xB-xG/2;
            xR = xB+dxL+xG; % 1-pix gap to start of xR
            dxR = pdx-xR-xB;
            
            dy=14;
            y0=1-dy-4;
            
            y0=y0+dy+4;
            %tip = sprintf([ ...
            %    'Histogram bar color representing data values\n' ...
            %    'too small for suggested numeric type.']);
            dlg.htUnderflowBar = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor',ntx.ColorUnderflowBar, ...
                'foregroundcolor','k', ...
                'units','pix', ...
                'fontsize',8, ...
                'pos', [xL y0+yB dxL dy], ...
                'enable','inactive', ...
                'tag','legend_underflow_frame',...
                'style','frame');
            dlg.htUnderflowText = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor', bg, ...
                'units','pix', ...
                'horiz','left', ...
                'fontsize',8, ...
                'pos', [xR y0+yB dxR dy], ...
                'enable','inactive', ...
                'style','text', ...
                'tag','legend_underflow_text',...
                'string','Below precision');
            
            y0=y0+dy+4;
            %tip = sprintf([ ...
            %    'Histogram bar color representing data values\n' ...
            %    'representable by suggested numeric type.']);
            dlg.htNormalBar = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor',ntx.ColorNormalBar, ...
                'foregroundcolor','k', ...
                'units','pix', ...
                'fontsize',8, ...
                'pos', [xL y0+yB dxL dy], ...
                'enable','inactive', ...
                'tag','legend_inrange_frame',...
                'style','frame');
            dlg.htNormalText = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor', bg, ...
                'units','pix', ...
                'horiz','left', ...
                'fontsize',8, ...
                'pos', [xR y0+yB dxR dy], ...
                'enable','inactive', ...
                'tag','legend_inrange_text',...
                'style','text', ...
                'string','In range');
            
            y0=y0+dy+4;
            %tip = sprintf([ ...
            %    'Histogram bar color representing data values\n' ...
            %    'exceeding range of suggested numeric type.']);
            dlg.htOverflowBar = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor',ntx.ColorOverflowBar, ...
                'foregroundcolor','k', ...
                'units','pix', ...
                'fontsize',8, ...
                'pos', [xL y0+yB dxL dy], ...
                'enable','inactive', ...
                'tag','legend_overflow_frame',...
                'style','frame');
            dlg.htOverflowText = uicontrol( ...
                'parent', hParent, ...
                'backgroundcolor', bg, ...
                'units','pix', ...
                'horiz','left', ...
                'fontsize',8, ...
                'pos', [xR y0+yB dxR dy], ...
                'enable','inactive', ...
                'style','text', ...
                'tag','legend_overflow_text',...
                'string','Outside range');
            
            % Final height
            pdy = y0+dy+4+yB; % final height, add ~1 char for label
            set(hParent,'pos',[1 1 pdx pdy]);
        end
    end
end