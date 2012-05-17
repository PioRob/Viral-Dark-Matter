function [TargetLoopStruct, TargetBandwidthStruct] = utCreateDefaultDataStruct(this)
%utCreateDefaultDataStruct Create default data structure


%   Copyright 1986-2006 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2006/11/17 13:25:24 $

%% Data Struct for Target Loop Shape
TargetLoopStruct = struct( ...
    'TargetLoopShape', 'tf(1,[1,1])', ...
    'TargetOrder', inf, ...
    'UseSpecifiedFreqRange', false, ...
    'SpecifiedFreqRange', '[1,1000]');

%% Data Struct for Target Bandwidth
TargetBandwidthStruct = struct( ...
    'TargetBandwidth', '10', ...
    'TargetOrder', inf);