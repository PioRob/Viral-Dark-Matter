function initprivatedata(h);

%   Copyright 1996-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/12/10 19:19:54 $

% First initialize base class private data fields.
h.basesigproc_initprivatedata;

pd = h.PrivateData;

pd.TargetFGOversampleFactor = 10;

h.PrivateData = pd;