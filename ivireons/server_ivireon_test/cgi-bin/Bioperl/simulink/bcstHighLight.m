function bcstHighLight(object, action)
%BCSTHIGHLIGHT Perform highlighting operations.

%   Copyright 2007-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2008/05/20 00:26:33 $

if nargin == 0
    return;
elseif nargin < 2
    action = 'hilite';
end

mylib = char(regexp(object,'^[^/]+','match'));

switch action
    case 'hilite'
        if isempty(find_system('SearchDepth', 0, 'CaseSensitive', 'off', 'Name', mylib))
            load_system(mylib);
        else
            myroot = get_param(bdroot(get_param(object,'Handle')), 'Name');
            bcstHighLight(myroot, 'unhilite');
        end

        hilite_system(object, 'find');

    case 'unhilite'
        if ~isempty(find_system('SearchDepth', 0, 'CaseSensitive', 'off', 'Name', mylib))
            blocks = find_system(object, 'HiliteAncestors', 'find');
            for blockIdx = 1:length(blocks)
                block = blocks{blockIdx};
                set_param(block, 'HiliteAncestors', 'none');
            end
        end

    otherwise
      DAStudio.error('Simulink:bcst:UnrecognizedAction', action)
end
