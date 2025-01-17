function value = rtw_is_hardware_state_unknown(modelName)
% RTW_IS_HARDWARE_STATE_UNKNOWN
%
% This refers to the Hardware Implementation settings.  Prior to
% Real-Time Workshop version 6.0 the hardware characteristics
% was specified via a MATLAB script, which is obsolete.  Now, the
% information is provided via the configuration parameters.
% Since older versions of Simulink did not have these model
% settings, they load into an unknown state.  This function
% returns true if the state is unknown, and false otherwise.
  
% Copyright 1994-2010 The MathWorks, Inc.
% $Revision: 1.1.6.4 $

  cs = getActiveConfigSet(modelName);

  value = strcmp(get_param(cs,'TargetUnknown'),'on');
  
