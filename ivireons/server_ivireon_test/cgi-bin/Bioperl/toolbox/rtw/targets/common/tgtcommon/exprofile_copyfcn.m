function exprofile_copyfcn(block)
%EXPROFILE_COPYFCN is a CopyFcn callback to switch on execution profiling
%   EXPROFILE_COPYFCN(BLOCK) is intended to be called when an execution profiling 
%   block is copied to a new model. This function checks if execution profiling
%   is enabled for the model. If it is not enabled, the user is given an option
%   to for execution profiling to be enabled.

%   Copyright 1994-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  

model = bdroot(block);
execCopyFcn = get_param(gcb,'execCopyFcn');
if strcmp(execCopyFcn,'on')
  set_param(block,'execCopyFcn','off')
  blockName = strrep(block,char(10),' ');
  cs = getActiveConfigSet(model);
  params = get_param(cs,'ObjectParameters');
  if ~isfield(params,'ExecutionProfilingEnabled')
    msgbox(...
        ['Operation of the execution profiling block ''' blockName ''' requires that '...
         '(a) the appropriate System Target File is selected, and (b) the option '...
         'to enable execution profiling is checked. You must perform these steps '...
         'manually.'],...
        'Copy Execution Profiling Block'...
        );
  else
    enabled = get_param(cs,'ExecutionProfilingEnabled');
    if strcmp(enabled,'off')
      maskType = get_param(block,'masktype');
      answer = questdlg(...
          ['Operation of the execution profiling block ''' blockName ''' '...
           'requires that '...
           'execution '...
           'profiling is enabled for the model ''' model '''. Do you wish to enable '...
           'execution profiling now?'],...
          ['Copy Execution Profiling Block'],...
          'Yes','No','Yes');
      if strcmp(answer,'Yes')
        set_param(cs,'ExecutionProfilingEnabled','on');
        setPropEnabled(cs,'ExecutionProfilingNumSamples',1);
      end
    end
  end
end
