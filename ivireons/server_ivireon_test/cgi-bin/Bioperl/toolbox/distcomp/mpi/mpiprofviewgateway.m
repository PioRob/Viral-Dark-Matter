function mpiprofviewgateway(inStr)
%PROFVIEWGATEWAY  Profiler HTML gateway function.
%   PROFVIEWGATEWAY is initiated by a JavaScript inside a <FORM> tag in the
%   various directory reports. It manages the preferences associated with
%   the Profiler.
%
%   See also PROFVIEW.

% Copyright 1984-2006 The MathWorks, Inc.

if nargin==0
    inStr = '?parentDisplayMode=table';
end

if inStr(1)=='?'
    inStr(1) = '&';
end

strc = [];
match1 = regexp(inStr,'&([^&]*)','tokens');
for n = 1:length(match1)
    match2 = regexp(match1{n}{1},'([^=]*)=([^=]*)','tokens');
    for m = 1:length(match2)
        prop = urldecode(match2{m}{1});
        val  = urldecode(match2{m}{2});
        strc.(prop) = val;
    end
end

profileIndex = str2double(strc.profileIndex);

% This file needs to know specific information about the
% prefs for each of the forms. This is because only boxes that are
% checked are reported, but we need to report the unchecked boxes too.
if profileIndex==0
    
else
    fld = fieldnames(strc);
    for n = 1:length(fld)
        setpref('mpiprofiler',fld{n},strc.(fld{n}));
    end
    if (~isfield(strc,'hiliteOption') && ...
        ~isfield(strc,'busyLineSortKey'))
        interpretCheckbox(strc,'parentDisplayMode')
        interpretCheckbox(strc,'busylineDisplayMode')
        interpretCheckbox(strc,'childrenDisplayMode')
        interpretCheckbox(strc,'mlintDisplayMode')
        interpretCheckbox(strc,'listingDisplayMode')
        interpretCheckbox(strc,'coverageDisplayMode')
    end
end

htmlOut = mpiprofview(profileIndex);
com.mathworks.mde.profiler.Profiler.setHtmlTextParallel(htmlOut);

function interpretCheckbox(strc,modeStr)
% Interpret the setting of the checkbox as needed

setpref('mpiprofiler',modeStr,0)
if isfield(strc,modeStr)
    if strcmpi(strc.(modeStr),'on')
        setpref('mpiprofiler',modeStr,1)
    end
else
    % The field doesn't exist. Turn the preference off.
    setpref('mpiprofiler',modeStr,0)        
end
