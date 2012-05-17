function p = getptr(fig)
% This function is undocumented and will change in a future release

%GETPTR  Get figure pointer.
%     P = GETPTR(FIG) returns a cell array of param/value pairs that
%     can be used to restore the pointer of the figure with figure handle
%     FIG.  
%
%   Example:
%        disp('Pointer Before')
%        p = getptr(gcf)
%        setptr(gcf,'hand')
%        disp('Pointer After')
%        p = getptr(gcf)
%        set(gcf,p{:})
%
%     See also SETPTR. 

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.9.4.2 $
%   T. Krauss, 4/96

ptr = get(fig,'pointer');
if strcmp(ptr,'custom')
    cdata = get(fig,'pointershapecdata');
    hotspot = get(fig,'pointershapehotspot');
    p = {'pointershapecdata',cdata,'pointershapehotspot',hotspot,...
       'pointer','custom'};
else
    p = {'pointer',ptr};
end


