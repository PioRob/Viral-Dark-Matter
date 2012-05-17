function createContent(dlg)
% Widgets within dialog are created in this method
%
% All widgets should be parented to hParent, or to a
% child of hParent.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $     $Date: 2010/04/21 21:21:24 $

hParent = dlg.ContentPanel;
set(hParent,'tag','bitallocation_dialog_panel');
bg = get(hParent,'BackgroundColor');
ppos = get(hParent,'pos');
pdx = ppos(3); % initial width of parent panel, in pixels

inBorder = 2;
outBorder = 2;
xL = inBorder; % # pix separation from border to widget
xb = outBorder; % # pix on each side of panel taken by border line
pdx2 = floor(pdx/2); % midpoint
dxL = pdx2-10-xb-xL;  % Left side is 10 pix shorter
xR = xL+dxL+1; % 1-pix gap to start of xR
dxR = pdx-xR-xb-xL;

y0 = 342;

x0=2;
dy=20;
dyt = 16;
y0=y0-dy-8;

% Signedness option
tip = DAStudio.message('FixedPoint:fiEmbedded:SignedToolTip');
dlg.hBASignedPrompt = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor',bg, ...
    'units','pix', ...
    'tooltip',tip, ...
    'horiz','right', ...
    'enable','inactive', ...  % allow mouse drag on panel
    'pos',[x0 y0 dxL dyt], ... % estimates
    'string','Signedness:', ...
    'fontsize',8,...
    'style','text',...
    'tag','signedness_prompt');
dlg.hBASigned = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'value',dlg.BASigned, ...
    'callback',@(h,e)setSignedMode(dlg), ...
    'string','Auto|Signed|Unsigned', ...
    'fontsize',8,...
    'style','popup',...
    'tag','signedness_popup');

y0 = y0-dy-8;
tip = DAStudio.message('FixedPoint:fiEmbedded:WordLengthToolTip');
dlg.hBAWLPrompt = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor',bg, ...
    'units','pix', ...
    'tooltip',tip, ...
    'horiz','right', ...
    'enable','inactive', ...  % allow mouse drag on panel
    'pos',[x0 y0 dxL dyt], ... % estimates
    'string','Word length:', ...
    'fontsize',8,...
    'style','text',...
    'tag','wordlength_prompt');

dlg.hBAWLMethod = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'value',dlg.BAWLMethod, ...
    'callback',@(h,e)setBAWLMethod(dlg), ...
    'string','Auto|Specify', ...
    'fontsize',8,...
    'style','popup',...
    'tag','wordlength_popup');

tip = DAStudio.message('FixedPoint:fiEmbedded:WordLengthBitsToolTip');
y0 = y0-dy-8;

dlg.hBAWLValuePrompt = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor',bg, ...
    'tooltip',tip, ...
    'horiz','right', ...
    'enable','inactive', ...  % allow mouse drag on panel
    'units','pix', ...
    'pos',[x0 y0 dxL dyt], ...
    'string','Value:', ...
    'fontsize',8,...
    'style','text',...
    'tag','value_prompt');
dlg.hBAWLBits = uicontrol( ...
    'parent', hParent, ...
    'backgroundcolor','w', ...
    'tooltip',tip, ...
    'horiz','left', ...
    'units','pix', ...
    'pos',[xR y0 dxR dy], ...
    'callback',@(h,e)setBAWLBits(dlg), ...
    'string',sprintf('%d',dlg.BAWLBits), ...
    'fontsize',8,...
    'style','edit',...
    'tag','wordlength_bits_edit');    

y0 = y0-dy-8;
tip = DAStudio.message('FixedPoint:fiEmbedded:GraphicalToolTip');
dlg.hBAGraphicalMode = uicontrol(...
    'Parent', hParent, ...
    'backgroundcolor',bg, ...
    'horiz','left', ...
    'tooltip',tip, ...
    'units','pix', ...
    'pos',[x0 y0 pdx-6 dy], ...
    'String','Graphical control', ...
    'Value',0, ...
    'callback',@(h,e)setBAGraphicalMode(dlg),...
    'fontsize',8,...
    'style','checkbox',...
    'tag','graphicalcontrol_checkbox');

y0 = y0-96-8;
createILFLSubdialog(dlg);
pos = get(dlg.hBAILFLPanel,'pos');
pos(2) = y0;
set(dlg.hBAILFLPanel,'pos',pos);

% Create Integer Length sub dialog
createILSubdialog(dlg);
pos = get(dlg.hBAILPanel,'pos');
pos(2) = y0;
set(dlg.hBAILPanel,'pos',pos);

% Create Fraction Length sub dialog
y0 = y0-98-8;
createFLSubdialog(dlg);
pos = get(dlg.hBAFLPanel,'pos');
pos(2) = y0;
set(dlg.hBAFLPanel,'pos',pos);

% Set height of panel
pdy = 342;
set(hParent,'pos',[1 1 pdx pdy]);