function [retout] = uiundo(hFigure,action,s)
% This function is undocumented and will change in a future release

% Copyright 2002-2007 The MathWorks, Inc.

%UIUNDO(FIG,OPTION,C) 
%         FIG is a figure handle
%         ACTION is 'function' | 'add' | 'execUndo' | 'execRedo'
%         C is an optional structure containing command information

figtool_manager = localGetFigureToolManager(hFigure);
cmd_manager = figtool_manager.CommandManager;
if nargin < 3
    s = [];
end

if strcmp(action,'function')

   % Create command object
   cmd = uiundo.FunctionCommand;
   cmd.Name = s.Name;
   cmd.Function = s.Function;
   cmd.Varargin = s.Varargin;
   cmd.InverseFunction = s.InverseFunction;
   cmd.InverseVarargin = s.InverseVarargin;
   add(cmd_manager,cmd);

elseif strcmp(action,'add')
   add(cmd_manager,s);
   
elseif strcmp(action,'execUndo')
    hCommand = cmd_manager.peekundo;
    if ~isempty(hCommand) && ...
            (isempty(s) || any(strcmp(hCommand.Name,s)))
        cmd_manager.undo;
    end
    
elseif strcmp(action,'execRedo')
    hCommand = cmd_manager.peekredo;
    if ~isempty(hCommand) && ...
            (isempty(s) || any(strcmp(hCommand.Name,s)))
        cmd_manager.redo;
    end
elseif strcmp(action,'clear')
    cmd_manager.empty;
end

%------------------------------------------%
function [figtool_manager] = localGetFigureToolManager(fig)

KEY = 'uitools_FigureToolManager';

figtool_manager = getappdata(fig,KEY);

% Create a new figure tool manager if one does not already exist
if isempty(figtool_manager) | ~ishandle(figtool_manager)
  figtool_manager = uitools.FigureToolManager(fig);
  setappdata(fig,KEY,figtool_manager);
end

