function [ts1timevec, ts2timevec, outprops, outtrans] = ...
    timemerge(timeInfo1, timeInfo2, time1, time2)
%TIMEMERGE Returns two time vectors with numeric values used by overloaded
%arithmatic operations and concatenations.
%
%   timeInfo1: @timemetadata object from ts1
%   timeInfo2: @timemetadata object from ts2
%   time1: from ts1.time
%   time2: from ts2.time
%
%   ts1timevec: a relative time vector to be compared with ts2timevec
%   ts2timevec: a relative time vector to be compared with ts1timevec
%   outprops: returns a struct with 'ref','outformat','outunits'
%       ref: from one of the two StartDate properties
%       outformat: from one of the two Format properties
%       outunits: from one of the two Units properties
%   outtrans: returns a struct with 'delta','deltaTS','scale'
%       delta: the difference between two 'StartDate' properties
%       deltaTS: '1' means StartDate from ts1 is later than StartDate from ts2
%                '2' means StartDate from ts2 is later than StartDate from ts1
%       scale: unit conversion factors

%   Copyright 2005-2009 The MathWorks, Inc.

% TO DO: Consider making into a @timeseries static method

% Convert time units to the larger units and get new time vectors
availableUnits = {'seconds','minutes','hours','days','weeks'};
outunits = availableUnits{max(find(strcmp(timeInfo1.Units,availableUnits)), ...
        find(strcmp(timeInfo2.Units,availableUnits)))};
unitconv1 = tsunitconv(outunits,timeInfo1.Units);
unitconv2 = tsunitconv(outunits,timeInfo2.Units);
ts1timevec = unitconv1*time1;
ts2timevec = unitconv2*time2;

% If time vectors are both absolute then convert them to the output units
% and apply the converted difference between the startdates
ref = '';
delta = 0;
deltaTS = [];
if ~isempty(timeInfo1.Startdate) && ~isempty(timeInfo2.Startdate)    
    delta = tsunitconv(outunits,'days')*...
        (datenum(timeInfo1.Startdate)-datenum(timeInfo2.Startdate));
    if delta>0
        ref = timeInfo2.Startdate;
        ts1timevec = ts1timevec+delta;
        deltaTS = 1;
    else
        ref = timeInfo1.Startdate;
        delta = -delta;
        ts2timevec = ts2timevec+delta;
        deltaTS = 2;
    end
else
    if ~(isempty(timeInfo1.StartDate) || ~isempty(timeInfo2.StartDate))
       warning('abstracttimemetadata:timemerge:mismatchTimeVecs',...
           'Only one of the two time vectors uses dates. The StartDate value is ignored.')
    end
end

% Merge time formats
outformat = '';
if strcmp(timeInfo1.Format,timeInfo2.Format)
    outformat = timeInfo1.Format;
end

outprops = struct('ref',ref,'outformat',outformat,'outunits',outunits);
outtrans = struct('delta',delta,'deltaTS', deltaTS,'scale',{{unitconv1,unitconv2}});