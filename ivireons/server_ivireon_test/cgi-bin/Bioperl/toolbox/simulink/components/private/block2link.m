function block2link(block, refstring,varargin)
% BLOCK2LINK Replace a block with a link to a block

% $Revision: 1.3.2.3 $ $Date: 2008/05/12 21:38:10 $
% Copyright 1990-2004 The MathWorks, Inc.

if strcmp(get_param(block, 'linkstatus'),'none'),

  slashes = find(refstring=='/');
  library = refstring(1:slashes(1)-1);

  if isempty(find_system('type','block_diagram','name',library)),
    feval(library,[],[],[],'load');
  end

  safe_set_param(block, 'ReferenceBlock', refstring);

  origLock = get_param(library,'Lock');
  set_param(library, 'Lock', 'off');
  %get_param(block, 'LinkStatus'); % force update
  try
      get_param(block,'LinkStatus');
  catch
  end
  set_param(library, 'Lock', origLock);

end

% end block2link

function safe_set_param(block, varargin)
% safe_set_param is protected by try/catch
%
% safe_set_param
% Same as set_param, however, the call to set_param is protected by try/catch
% so that errors can be treated as a warning.
%

% $Revision: 1.3.2.3 $ $Date: 2008/05/12 21:38:10 $
% Copyright 1990-2001 The MathWorks, Inc.

      
 try
     set_param(block, varargin{:});
 catch myException  
     warning(myException.identifier, '%s', myException.message);
 end
                                                                 
%end safe_set_para


%[EOF] block2link.m
