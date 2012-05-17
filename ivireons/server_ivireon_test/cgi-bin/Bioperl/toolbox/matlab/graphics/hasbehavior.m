function has=hasbehavior(h,name,state)
%HASBEHAVIOR sets(enables/disables) or gets behaviors of hg objects
%
% HASBEHAVIOR(H,NAME,STATE) sets the behavior named NAME for the 
% hg object with handle H to STATE (true or false). The NAME
% is case-insensitive. The name 'legend' is used by the LEGEND
% command to enable or disable showing the object in a legend.
% HAS = HASBEHAVIOR(H,NAME) returns the boolean value for the
% behavior NAME of H.  If the behavior has not been previously 
% set for H, then 'on' is returned. 
%
%   Examples:
%       ax=axes;
%       l=plot(rand(3,3));
%       hasbehavior(l(1),'legend',false); % line will not be in legend
%       hasbehavior(l(2),'legend',true); % line will be in legend
%
%       linelegendable = hasbehavior(l(1),'legend'); % gets legend behavior
 
%   Copyright 1984-2005 The MathWorks, Inc.

error(nargchk(2,3,nargin,'struct'));

if ~ishghandle(h)
    error(id('InvalidHandle'),'First argument must be a valid handle.')
end
if ~ischar(name)
    error(id('InvalidName'),'Second argument must be a string name.')
end
behaviorname = [name,'_hgbehavior'];
if nargin == 2
    % if the appdata does not exist then the behavior is true
    if ~isappdata(h,behaviorname)
        has = true;
    elseif isequal(false,getappdata(h,behaviorname))
        has = false;
    else
        has = true;
    end
else
    if ~islogical(state) && ~isnumeric(state)
        error(id('InvalidBehaviorState'),...
              'Behavior state must be logical or numeric.');
    end
    setappdata(h,behaviorname,state)
end

function str = id(str)
str = ['MATLAB:hasbehavior:' str];
