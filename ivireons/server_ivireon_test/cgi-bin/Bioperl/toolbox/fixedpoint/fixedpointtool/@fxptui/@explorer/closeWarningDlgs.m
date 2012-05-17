function isBeingDestroyed = closeWarningDlgs(h)
% Close all warning/question dialogs associated with the explorer.
% 
% Copyright 2009 The MathWorks, Inc.
% $Revision: 1.1.6.1 $      $Date: 2009/05/23 08:01:52 $

isBeingDestroyed = false;
for i = 1:length(h.cachedWarningTitles)
    if ~isempty(h.cachedWarningTitles{i})
        ch = findall(0,'Type','Figure','Name',h.cachedWarningTitles{i});
        h.cachedWarningTitles{i} = '';
        if ~isempty(ch)
            isBeingDestroyed = true;
            delete(ch); 
        end
    end
end    
h.isBeingDestroyed = isBeingDestroyed;
    
    
