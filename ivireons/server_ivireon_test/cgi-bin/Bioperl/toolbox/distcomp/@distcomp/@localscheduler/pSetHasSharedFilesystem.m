function val = pSetHasSharedFilesystem(obj, val)
; %#ok Undocumented

%  Copyright 2000-2006 The MathWorks, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2006/12/06 01:35:18 $

if obj.Initialized
    error('distcomp:localscheduler:InvalidArgument', 'You cannot set the HasSharedFilesystem property of a localscheduler object');
end