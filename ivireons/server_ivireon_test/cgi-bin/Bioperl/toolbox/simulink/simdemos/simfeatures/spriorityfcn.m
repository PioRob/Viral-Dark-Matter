function [sys,x0,str,ts,simStateCompliance] = spriorityfcn(t,x,u,flag)
%PRIORITYFCN S-Function and callback file for Simulink priority demo.

%   Copyright 1990-2008 The MathWorks, Inc.

%   $Revision: 1.8.2.1 $

switch flag,
  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  case { 1, 3, 4, 9 }
    sys=[];
    
  %%%%%%%%%%%%%%%%%%%%%
  % MaskInit callback %
  %%%%%%%%%%%%%%%%%%%%%
  case 'PriorityOrder'
    priOrder = get_param(gcbh,'PriorityOrder');
    mdl = bdroot;
    set_param([mdl '/a'],'Priority',priOrder(1))
    set_param([mdl '/b'],'Priority',priOrder(3))
    set_param([mdl '/c'],'Priority',priOrder(5))
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Unexpected flags (error handling)%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Return an error message for unhandled flag values.
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end priorityfcn

%   $Revision: 1.8.2.1 $  $Date: 2008/12/01 07:49:33 $

%
%=============================================================================
% mdlInitializeSizes
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes()

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

% specify that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
%=============================================================================
%

function sys = mdlUpdate(t,x,u) %#ok<INUSD>

parent = get_param(gcbh,'Parent');
pri = eval(get_param(parent,'Priority'));

colors = {'red','green','orange','blue','magenta'};

set_param(parent,'backgroundcolor',colors{pri});
shortpause
set_param(parent,'backgroundcolor','white')
drawnow

sys = [];

function shortpause

pause(0.5)

