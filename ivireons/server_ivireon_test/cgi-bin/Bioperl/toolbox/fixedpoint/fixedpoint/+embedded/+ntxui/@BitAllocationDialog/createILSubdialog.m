function createILSubdialog(dlg)
% Create Integer Length content for Numeric Type dialog
%
% We don't actually register a dialog here; this is just a helper
% function that contributes UI controls to a parent dialog.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $     $Date: 2010/05/20 02:17:48 $

hParent = dlg.ContentPanel;
bg = get(hParent,'BackgroundColor');
ppos = get(hParent,'pos');
pdx = ppos(3); % initial width of parent panel, in pixels

% MSB dialog
dy = 108;
hBAILPanel = uipanel('parent',hParent, ...
    'units','pix', ...
    'pos', [2 1 pdx-4 dy], ...
    'bordertype','none',...
    'tag','il_subpanel',...
    'background',bg); %#ok<*PROP> %   

dlg.hBAILPanel = hBAILPanel;

inBorder = 2;
outBorder = 2;
xL = inBorder; % inMargin - # pix separation from border to widget
xb = outBorder; % lineWidth # pix on each side of panel taken by border line
x0 = inBorder+1;
y0 = inBorder+76;
dx = pdx-2*inBorder-4;
dy = 20;
dyt = 16; % text prompt heights

dlg.hBAILPrompt =  uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor',bg, ...
    'units','pix', ...
    'horiz','left', ...
    'tooltip','', ...
    'pos',[x0 y0 dx dyt], ...
    'String','Integer length (IL) constraint:',...
    'fontsize',8,...
    'tag','il_constraint',...
    'Style','text');

y0 = y0-dy-4;    
% Create MSB widgets
tip = DAStudio.message('FixedPoint:fiEmbedded:ILConstraintMethodToolTip');
dlg.hBAILMethod = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor','w', ...
    'units','pix', ...
    'tooltip',tip, ...
    'pos',[x0 y0 dx dy], ...
    'callback',@(h,e)setBAILMethod(dlg), ...
    'style','popup', ...
    'fontsize',8,...
    'value',dlg.BAILMethod, ...
    'tag','il_constraint_popup',...
    'string',['Max occurrences outside range' ...
    '|Largest magnitude|Integer bits']); % 'Interactive Overflow

pdx2 = floor(pdx/2); % midpoint
dxL = pdx2-xb-xL-13;  % Left side is 13 pix shorter
xR = xL+dxL+4; % 1-pix gap to start of xR
dxR = pdx-xR-xb-2;

y0=y0-dy-8;
% ... that meets specified criterion.
tip = DAStudio.message('FixedPoint:fiEmbedded:OverflowPercentMethodToolTip');
dlg.hBAILPercent = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor','w', ...
    'units','pix', ...
    'tooltip',tip, ...
    'horiz','right', ...
    'pos',[x0 y0 dxL dy], ...
    'string',sprintf('%d',dlg.BAILPercent), ...
    'callback',@(h,e)setBAILPercent(dlg,h), ...
    'fontsize',8,...
    'tag','il_overflow_percent_edit',...
    'style','edit');

tip = DAStudio.message('FixedPoint:fiEmbedded:OverflowCountMethodToolTip'); 
dlg.hBAILCount = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor','w', ...
    'units','pix', ...
    'tooltip',tip, ...
    'horiz','right', ...
    'pos',[x0 y0 dxL dy], ...
    'string',sprintf('%d',dlg.BAILCount), ...
    'callback',@(h,e)setBAILCount(dlg,h), ...
    'fontsize',8,...
    'tag','il_overflow_count_edit',...
    'style','edit');

tip = DAStudio.message('FixedPoint:fiEmbedded:UnitsMethodToolTip');
dlg.hBAILUnits = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor','w', ...
    'units','pix', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'pos',[xR y0 dxR dy], ...
    'string','Percent|Count', ...
    'callback',@(h,e)setBAILUnits(dlg,h), ...
    'value',dlg.BAILUnits, ...
    'fontsize',8,...
    'tag','il_overflow_units_popup',...
    'style','popup');

tip = DAStudio.message('FixedPoint:fiEmbedded:LargestMagToolTip');
dlg.hBAILValuePrompt = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor',bg, ...
    'tooltip',tip, ...
    'horiz','right', ...
    'enable','inactive', ...  % allow mouse drag on panel
    'units','pix', ...
    'pos',[x0 y0 dxL dyt], ...
    'string','Value:', ...
    'fontsize',8,...
    'tag','il_value_prompt',...
    'style','text');

dlg.hBAILSpecifyMagnitude = uicontrol( ...
    'parent',hBAILPanel, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'string',sprintf('%g',dlg.BAILSpecifyMagnitude), ...
    'callback',@(h,e)setBAILMagEdit(dlg,h), ...
    'fontsize',8,...
    'tag','il_msb_magnitude_edit',...
    'style','edit');

% Specify Bits goes on same row as Specify Magnitude
tip = DAStudio.message('FixedPoint:fiEmbedded:ILBitsToolTip');
dlg.hBAILSpecifyBits = uicontrol( ...
    'parent',hBAILPanel, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'string',sprintf('%g',dlg.BAILSpecifyBits), ...
    'callback',@(h,e)setBAILSpecifyBits(dlg,h), ...
    'fontsize',8,...
    'tag','il_bits_edit',...
    'style','edit');

y0=y0-dy-8;
% Alt: use safety factor, not guard bits
%      'Increase MSB weight beyond minimum required'
tip = DAStudio.message('FixedPoint:fiEmbedded:ExtraILBitsToolTip');
dlg.hBAILGuardBitsPrompt = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor',bg, ...
    'tooltip',tip, ...
    'enable','inactive', ...
    'horiz','right', ...
    'units','pix', ...
    'pos',[x0 y0 dxL dyt], ...
    'string','Extra IL bits:', ... % Guard bits'
    'fontsize',8,...
    'tag','il_guard_bits_prompt',...
    'style','text');

dlg.hBAILGuardBits = uicontrol( ...
    'parent', hBAILPanel, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'string',sprintf('%d',dlg.BAILGuardBits), ...
    'callback',@(h,e)setBAILGuardBits(dlg,h), ...
    'fontsize',8,...
    'tag','il_guard_bits_edit',...
    'style','edit');
