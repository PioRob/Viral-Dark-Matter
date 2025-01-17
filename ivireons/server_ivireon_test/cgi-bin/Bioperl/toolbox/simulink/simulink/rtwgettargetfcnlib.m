function fctInfo = rtwgettargetfcnlib(model, rtwFcn, rtwType)
% This function is called from block TLC code to resolve functions in the
% target function library
%

%   Copyright 1990-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $

    libH = get_param(model,'TargetFcnLibHandle');
    if isempty(libH)
        implH = [];
    else
        implH = libH.getFcnImplement(rtwFcn, rtwType);
    end
    
    if isempty(implH)
        fctInfo = [];
    else
        fctInfo = struct('FcnName',     implH.ImplementName, ...
                         'FcnType',     implH.OutDataType, ...
                         'HdrFile',     implH.HeaderFile, ...
                         'NumInputs',   implH.NumInputs);
    end
                         
                         