function thisTs = ArrayEditorDeleteRow(thisTs,rows,tsrownum)

% Copyright 2006 The MathWorks, Inc.

thisTs = delsample(thisTs,'Index',tsrownum(tsrownum>=0));