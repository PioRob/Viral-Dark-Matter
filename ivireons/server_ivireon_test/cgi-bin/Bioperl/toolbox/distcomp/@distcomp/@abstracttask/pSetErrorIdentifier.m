function val = pSetErrorIdentifier(task, val)
; %#ok Undocumented
%pSetErrorIdentifier 
%
%  VAL = pSetErrorIdentifier(TASK, VAL)

%  Copyright 2005-2006 The MathWorks, Inc.

%  $Revision: 1.1.10.3 $    $Date: 2006/06/27 22:35:46 $ 

serializer = task.Serializer;

if ~isempty(serializer)
    try
        serializer.putField(task, 'erroridentifier', val);
    end
end
% Store nothing
val = '';