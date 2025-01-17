function [result, error_str] = targetddg_preapply_callback(dlgH)

% Copyright 2003 The MathWorks, Inc.

  [result,error_str] = coder_opts_ddg_preapply_cb(dlgH);

  if ~isempty(error_str)
      return;
  end
  
  result = 1;
  error_str = '';
  err = [];
  
  if ~ishandle(dlgH)
    return;
  end
  
  h = dlgH.getDialogSource;
  if ~isa(h, 'Stateflow.Target')
    return;
  end
  
  % Remove the tag (if any) identifying this as an intermediate object
  if ~isempty(findstr(h.Tag, '_DDG_INTERMEDIATE_'))
      h.tag = '';
  end