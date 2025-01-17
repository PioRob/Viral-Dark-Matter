function pInitialiseLocation(job, proxy, maxWorkers)
; %#ok Undocumented
%pInitialiseLocation 
%
%  PINITIALISELOCATIOB(JOB)

% Copyright 2005-2009 The MathWorks, Inc.

% $Revision: 1.1.10.8 $    $Date: 2009/12/22 18:51:50 $

% Fill in the relevant parts of the Job object
serializer = job.Serializer;

fieldsToInit = { ...
    'productkeys' ...
    'username' ...
    'name' ...
    'tag' ...
    'state' ...
    'createtime' ...
    'submittime' ...
    'starttime' ...
    'finishtime' ...
    'filedependencies' ...
    'filedata' ...
    'pathdependencies' ...
    'jobdata' ...
    'jobschedulerdata' ...
    'execmode' ...
    'version' ...
    'minworkers' ...
    'maxworkers' ...
    };


valuesToInit = { ...
    uint8([]) ...
    distcomp.pGetDefaultUsername() ...
    char(proxy.getName) ...
    '' ...
    'pending' ...
    char(java.util.Date) ...
    '' ...
    '' ...
    '' ...
    {} ...
    int8([]) ...
    {} ...
    [] ...
    [] ...
    0 ... execmode
    char(com.mathworks.toolbox.distcomp.util.Version.VERSION_STRING) ... 
    1 ... minworkers
    maxWorkers ... maxworkers
    };

% Request that the serializer create a the fields for a 'job' entity 
serializer.createFields(job, fieldsToInit, valuesToInit);
