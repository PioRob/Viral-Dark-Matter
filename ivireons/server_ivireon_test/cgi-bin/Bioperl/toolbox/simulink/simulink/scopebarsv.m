function varargout = scopebarsv(scopeFig, varargin)
%SCOPEBAR Scope toolbar manager.
%   SCOPEBAR manages all aspects of the Scope toolbar.

%   Copyright 1990-2007 The MathWorks, Inc.
%   $Revision $

if ~ishandle(scopeFig),
  return;
end

Action = varargin{1};

switch Action,
    
case 'Create',
    %
    % Create the toolbar.
    %
    varargout = {i_Createtoolbar(scopeFig, varargin{2})};
    
case 'Resize',
    %
    % Resize the toolbar.
    %
    i_Resizetoolbar(scopeFig, varargin{2});
    
case 'ZoomModeSwitch',
    %
    % Switch modes (zoom, zoomx, etc).
    %
    scopeUserData = get(scopeFig, 'UserData');
    if ~isempty(scopeUserData),
      i_ZoomModeSwitch(scopeFig, scopeUserData, varargin{2});
    end
    
case 'CtrlUI',
    %
    % Public access to: i_SettoolbarCtrlEnable(scopeUserData, state)
    %
    scopeUserData = get(scopeFig, 'UserData');
    if ~isempty(scopeUserData),
      i_SettoolbarCtrlEnable(scopeUserData, varargin{2});
    end
    
case 'EnableIcon',
    %
    % Set toolbar button enabled-ness (state follows)
    %
    hb       = varargin{2};
    newValue = varargin{3};
        
    set(hb, 'Enable', newValue);

case 'FloatButton',

    scopeUserData = get(scopeFig, 'UserData');
    hFloat = scopeUserData.toolbar.children.actionIcons.Floating;
    
    if ishandle(hFloat)
      currState = get(hFloat, 'State');
      newEnable = varargin{2};
      newState  = varargin{3};
      
      bd           = scopeUserData.block_diagram;
      simStatus    = get_param(bd, 'SimulationStatus');
      uploadStatus = get_param(bd, 'ExtModeUploadStatus');
      
      %
      % Only transition to enable if not running.
      % Use the appropriate simstatus when in external mode.
      %
      if strcmp(simStatus, 'external'),
        if ~strcmp(uploadStatus, 'inactive'),
          simStatus = 'running';
        else,
          simStatus = 'stopped';
        end
      end    
      
      if strcmp(newState, 'off'),
        scopebar(scopeFig, 'SelectButton', 'off');
      end
      
      if strcmp(newEnable, 'on') & ~strcmp(simStatus, 'running'),
        scopebar(scopeFig, 'StateButton', hFloat, newEnable, newState);
        %
        % Lock button tracks floating button state CHANGES
        % for both its enabledness and state.
        %
        if ~strcmp(currState, newState),
          scopebar(scopeFig, 'LockButton', newState, newState);
        end
      end
    end
 
case 'LockButton',
  
    newEnable = varargin{2};
    newState  = varargin{3};
    scopeUserData = get(scopeFig, 'UserData');
    hLock = scopeUserData.toolbar.children.actionIcons.Lock;

    if ishandle(hLock)
      scopebar(scopeFig, 'StateButton', hLock, newEnable, newState);
      
      if strcmp(newState, 'off'),
        set(hLock, 'tooltip', lclMessage('ScopebarLockAxesSelection'));
      else,
        set(hLock, 'tooltip', lclMessage('ScopebarUnlockAxesSelection'));
      end
    end

case 'SelectButton',
  
    %
    % Only reference the select button if it exists
    % 
    newEnable = varargin{2};
    scopeUserData = get(scopeFig, 'UserData');
    hSelect = scopeUserData.toolbar.children.actionIcons.Select;

    if ishandle(hSelect),
      scopebar(scopeFig, 'EnableIcon', hSelect, newEnable);
    end
    
case 'StateButton',
    %
    % Lock and float button state and tooltip management.
    % Can be redundant in some cases.
    %
    hb        = varargin{2};
    newEnable = varargin{3};
    newState  = varargin{4};

    % If button is not enabled, pop it up (state = 0)
    % to avoid distraction.
    if strcmp(get(hb, 'Enable'), 'off'),
      set(hb, 'Enable', 'on');
    end
    
    if ~strcmp(get(hb, 'State'), newState),
      set(hb, 'State', newState);
    end

    % Special handling for lock button:
    %   tooltip tracks button state.
    scopebar(scopeFig, 'EnableIcon', hb, newEnable);
 
otherwise,
    %
    % Unhandled action - bad programmer.
    %
   DAStudio.error('Simulink:blocks:InvalidAction', Action);
end



% Function =====================================================================
% Create the toolbar.

function scopeUserData = i_Createtoolbar(scopeFig, scopeUserData),

scopePos  = get(scopeFig, 'Position');
set(0, 'CurrentFigure', scopeFig);

block_diagram = scopeUserData.block_diagram;
simStatus     = get_param(block_diagram, 'SimulationStatus');
floating      = get_param(scopeUserData.block,'Floating');
modelBased    = i_IsModelBased(scopeUserData.block);
wireless      = get_param(scopeUserData.block,'Wireless');

%
% Create the toolbar and its controls
%

htoolbar = uitoolbar('parent',scopeFig);
icons = load('scpbarbmp.mat');

% --- Print
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Print'', gcbf)';
children.actionIcons.Print = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarPrint'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.scpprn);

% --- Properties (actually, parameters!)
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''PropDlg'', gcbf)';
children.actionIcons.PropDlg = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarParameters'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.props);

% --- Zoom
cbstr = 'scopebarsv(gcbf, ''ZoomModeSwitch'', ''on'')';
children.modeIcons.ZoomNormal = uitoggletool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarZoom'), ...
    'clickedcallback',cbstr, ...
    'separator','on', ...
    'Interruptible',  'off', ...
    'cdata', icons.zoom);

% --- Zoom X
cbstr = 'scopebarsv(gcbf, ''ZoomModeSwitch'', ''xonly'')';
children.modeIcons.ZoomX = uitoggletool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarZoomXAxis'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.zoomx);

% --- Zoom Y
cbstr = 'scopebarsv(gcbf, ''ZoomModeSwitch'', ''yonly'')';
children.modeIcons.ZoomY = uitoggletool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarZoomYAxis'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.zoomy);

% --- Autoscale (a.k.a. find signal)
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Find'', gcbf)';
children.actionIcons.Find = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarAutoscale'), ...
    'clickedcallback',cbstr, ...
    'separator','on', ...
    'Interruptible',  'off', ...
    'cdata', icons.find);

% --- Save settings (a.k.a. sync)
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Sync'', gcbf)';
children.actionIcons.Sync = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarSaveAxesSettings'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.syncblk);

% --- Restore settings
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Restore'', gcbf)';
children.actionIcons.Restore = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarRestoreAxesSettings'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.scprestore);

% --- Floating scope
if ~modelBased
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Float'', gcbf)';
children.actionIcons.Floating = uitoggletool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarFloatingScope'), ...
    'clickedcallback',cbstr, ...
    'separator','on', ...
    'Interruptible',  'off', ...
    'cdata', icons.scpfloat);
else
  children.actionIcons.Floating = (-1);
end

% --- Lock axes
if ~modelBased
cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''LockAxes'', gcbf)';
children.actionIcons.Lock = uitoggletool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarUnlockAxesSelection'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.scplock);
else
  children.actionIcons.Lock = (-1);
end

% --- Signal selection (java-based)
if usejava('MWT'),
  cbstr = 'simscopesv(''ScopeBar'', ''ActionIcon'', ''Select'', gcbf)';
  children.actionIcons.Select = uipushtool('parent',htoolbar, ...
    'tooltip',lclMessage('ScopebarSignalSelection'), ...
    'clickedcallback',cbstr, ...
    'Interruptible',  'off', ...
    'cdata', icons.scpsigsel);
  set(children.actionIcons.Select, 'Enable', wireless );
else,
  children.actionIcons.Select = (-1);
end

scopeUserData.toolbar.children = children;

%
% Initialize zoom buttons
%
i_ZoomModeSwitch(scopeFig, scopeUserData, ...
                 get_param(scopeUserData.block,'ZoomMode'));

%
% Set initial enabledness and state of floating/lockdown buttons
%
if ~modelBased
  % floating
  set(children.actionIcons.Floating, 'State', floating);
  if strcmp(simStatus, 'running'),
    set(children.actionIcons.Floating, 'Enable', 'off');
  else,
    set(children.actionIcons.Floating, 'Enable', 'on');
  end

  % lockdown
  set(children.actionIcons.Lock, 'State',  wireless);
  set(children.actionIcons.Lock, 'Enable', wireless);
end

%
% Set enabledness of controls.
%
if strcmp(simStatus, 'running'),
    i_SettoolbarCtrlEnable(scopeUserData, simStatus);
end


%******************************************************************************
% Function - Switch zoom modes.                                             ***
%******************************************************************************
function i_ZoomModeSwitch(scopeFig, scopeUserData, Mode),

block         = scopeUserData.block;
scopeAxes     = scopeUserData.scopeAxes;
modeIcons     = scopeUserData.toolbar.children.modeIcons;
touchedIcon   = gcbo;
cellmodeIcons = struct2cell(modeIcons);
floating      = onoff(get_param(block,'Floating'));

%
% Unpress all zoom buttons.
%
set([cellmodeIcons{:}], 'State', 'off');

if floating,
  %
  % no zoom buttons pressed in floating mode
  %
  return;
end
%
% Set the zoom buttons to the correct button.
%
if ishandle(gcbo) & find([cellmodeIcons{:}]==gcbo),
  set(gcbo, 'State', 'on');
  %
  % Change zoom mode.
  %
  scopezoom(Mode, scopeFig);
else,
  %
  % Sync up the buttons
  %
  zoomIcons = scopeUserData.toolbar.children.modeIcons;
  if ~floating,
    switch Mode,
     case 'on'
      set(zoomIcons.ZoomNormal,'State','on');
     case 'xonly'
      set(zoomIcons.ZoomX,'State','on');
     case 'yonly'
      set(zoomIcons.ZoomY,'State','on');
    end
  end
end

set_param(block, 'ZoomMode', Mode);

%endfunction i_ZoomModeSwitch

% Function =====================================================================
% Return boolean indicating that block is SignalViewingScope

function out = i_IsModelBased(block),
  bType = get_param(block,'BlockType');
  out   = strcmp(bType,'SignalViewerScope');
%endfunction i_IsModelBased


%******************************************************************************
% Function - Set enabledness of ctrls on toolbar.                           ***
%                                                                           ***
% This function applies to simulation stop and stop only! (bad name)        ***
%******************************************************************************
function i_SettoolbarCtrlEnable(scopeUserData, state),

toolbarchildren = scopeUserData.toolbar.children;
modeIcons = toolbarchildren.modeIcons;
actionIcons = toolbarchildren.actionIcons;

block      = scopeUserData.block;
floating   = onoff(get_param(block, 'floating'));
modelBased = i_IsModelBased(block);
wireless   = onoff(get_param(block, 'wireless'));

iconsOn   = [];
iconsOff  = [];

switch(state),
    
case {'notrunning', 'stopped'},
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulation ending or just not running.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %
    % Configuration for specific scope types.
    %
    if (modelBased)

      %
      % This case handles the Model-based Scope
      %
      
      iconsOn = [ actionIcons.Print, ...
                  modeIcons.ZoomNormal, ...
                  modeIcons.ZoomX, ...
                  modeIcons.ZoomY, ...
                  actionIcons.Find, ...
                  actionIcons.Restore
                ];
      iconsOff = [];
      if ishandle(actionIcons.Select), 
        % only exists if MWT is legal
        iconsOn = [ iconsOn, actionIcons.Select ];
      end
      set(scopeUserData.axesContextMenu.find,'Enable','on');
      
    else      
      if (floating)
        
        %
        % This case handles the Floating Scope
        %
        iconsOn  = [ actionIcons.Print, ...
                     actionIcons.Lock, ...
                     actionIcons.Floating
                   ];        
        iconsOff = [ modeIcons.ZoomNormal, ...
                     modeIcons.ZoomX, ...
                     modeIcons.ZoomY, ...
                     actionIcons.Find, ...
		     actionIcons.Restore
                   ];
        if ishandle(actionIcons.Select), 
          % only exists if MWT is legal
          iconsOn = [ iconsOn, actionIcons.Select ];
        end
        set(scopeUserData.axesContextMenu.find,'Enable','off');
        
      else
        
        %
        % This case handles the Regular Scope
        %
        iconsOn = [ actionIcons.Print, ...
                    modeIcons.ZoomNormal, ...
                    modeIcons.ZoomX, ...
                    modeIcons.ZoomY, ...
                    actionIcons.Find, ...
                    actionIcons.Restore, ...
                    actionIcons.Floating
                  ];
        iconsOff = actionIcons.Lock;
        if ishandle(actionIcons.Select), 
          % only exists if MWT is legal
          iconsOff = [ iconsOff, actionIcons.Select ];
        end
        set(scopeUserData.axesContextMenu.find,'Enable','on');
        % turn off the lock button when not enabled
        % so as not to attract attention to the lock button.
        set(actionIcons.Lock, 'State', 'off');
        
      end
    end

    
    
case 'running',
    %%%%%%%%%%%%%%%%%%%%%%%%
    % Simulation starting.
    %%%%%%%%%%%%%%%%%%%%%%%%

    iconsOn = [ actionIcons.Find, ...
                actionIcons.Restore 
              ];

    iconsOff = [ modeIcons.ZoomNormal, ...
                 modeIcons.ZoomX, ...
                 modeIcons.ZoomY, ...
                 actionIcons.Print, ...
               ];

    set(scopeUserData.axesContextMenu.find,'Enable','on');

    %
    % Configuration for specific scope types.
    %
    if (modelBased)
      
      %
      % This case handles the Model-based Scope
      %
      if ishandle(actionIcons.Select), 
        % only exists if MWT is legal
        iconsOff = [ iconsOff, actionIcons.Select ];
      end      

    else
      if (floating)
        
        %
        % This case handles the Floating Scope
        %
        iconsOn = [ iconsOn, actionIcons.Lock ];
        iconsOff = [ iconsOff, actionIcons.Floating ];
        if ishandle(actionIcons.Select), 
          % only exists if MWT is legal
          iconsOn = [ iconsOn, actionIcons.Select ];
        end
       
      else
        
        %
        % This case handles the Regular Scope
        %
        iconsOff = [ iconsOff, ...
                     actionIcons.Floating, ...
                     actionIcons.Lock 
                   ];
        if ishandle(actionIcons.Select), 
          % only exists if MWT is legal
          iconsOff = [ iconsOff, actionIcons.Select ];
        end      
        % turn off the lock button when not enabled
        % so as not to attract attention to the lock button.
        set(actionIcons.Lock, 'State', 'off');

      end
      
    end
    
otherwise,
    DAStudio.error('Simulink:blocks:InvalidState');
end

if ~isempty(iconsOn),
    set(iconsOn, 'Enable', 'on');
end

if ~isempty(iconsOff),
    set(iconsOff, 'Enable', 'off');
end


function msg = lclMessage(ID, varargin)

msg = DAStudio.message(['Simulink:blocks:' ID], varargin{:});

% [EOF] scopebar.m
