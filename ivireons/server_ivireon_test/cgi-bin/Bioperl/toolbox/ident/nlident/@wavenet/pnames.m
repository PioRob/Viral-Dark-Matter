function [Props,AsgnVals] = pnames(nlobj, flag)
%PNAMES  All WAVENET public properties and their assignable values
%
%   [PROPS,ASGNVALS] = PNAMES(NL) returns the list PROPS of
%   public properties of the object NL, as well as the
%   assignable values ASGNVALS for these properties.  Both
%   PROPS and ASGNVALS are cell vector of strings, and PROPS
%   contains the true case-sensitive property names.
%
%   PNAMES(SYS,'readonly') returns the read-only properties only.

% Copyright 2005-2008 The MathWorks, Inc.
% $Revision: 1.1.8.4 $ $Date: 2008/10/02 18:55:53 $

% Author(s): Qinghua Zhang

no = nargout;
ni = nargin;

readonlyflag = false;
if ni>1 && ischar(flag)
    if strcmpi(flag, 'readonly')
        readonlyflag = true;
    else
        ctrlMsgUtils.error('Ident:general:wrongPnamesFlag')
    end
end

if readonlyflag
    Props = {};
else
    Props = {'NumberOfUnits', ...
        'LinearTerm', ...
        'Parameters', ...
        'Options'};
end

if no>1
    if readonlyflag
        AsgnVals = {};
    else
        AsgnVals = {['Number of units (wavelets and scaling functions) of the ', ...
            'estimator, ''Auto''(default), ''Interactive'' or a positive integer'], ...
            'Status of the linear term of the estimator, ''on''(default) or ''off''', ...
            ['Structure containing ', upper(class(nlobj)), ' estimator parameters'], ...
            'Structure containing initialization options'};
    end
end

% FILE END
