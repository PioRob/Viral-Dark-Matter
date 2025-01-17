function disp(chan)
%DISP  Object display.

%   Copyright 1996-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2007/05/14 15:01:31 $

% Properties to display (in order).
props = {...
    'ChannelType', ...
    'InputSamplePeriod', ...
    'DopplerSpectrum', ...
    'MaxDopplerShift', ...
    'PathDelays', ...
    'AvgPathGaindB', ...
    'KFactor', ...
    'DirectPathDopplerShift', ...
    'DirectPathInitPhase', ...
    'NormalizePathGains', ...
    'StoreHistory', ...
    'StorePathGains', ...
    'PathGains', ...
    'ChannelFilterDelay', ...
    'ResetBeforeFiltering', ...
    'NumSamplesProcessed'};

baseclass_disp(chan, props);
