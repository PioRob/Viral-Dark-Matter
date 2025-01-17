function [Property,imatch] = pnmatch(Name,PropList,nchars)
%PNMATCH  Matches property name against property list.
%
%   PROPERTY = PNMATCH(NAME,PLIST) matches the string NAME
%   against the list of property names contained in PLIST.
%   If there is a unique match, PROPERTY contains the full
%   name of the matching property.  Otherwise an error message
%   is issued. PNMATCH uses case-insensitive string comparisons.
%
%   PROPERTY = PNMATCH(NAME,PLIST,N) limits the string
%   comparisons to the first N characters.
%
%   See also GET, SET.

%   Copyright 1986-2008 The MathWorks, Inc.
%   $Revision: 1.6.4.3 $ $Date: 2008/10/02 18:51:52 $

if ~ischar(Name) || size(Name,1)>1,
    ctrlMsgUtils.error('Ident:general:invalidPropertyNames')
end

% Set number of characters used for name comparison
if nargin==2,
    nchars = length(Name);
else
    nchars = min(nchars,length(Name));
end

% Find all matches
imatch = find(strncmpi(Name,PropList,nchars));

% Get matching property name
switch length(imatch)
    case 1
        % Single hit
        Property = PropList{imatch};
        
    case 0
        % No hit
        ctrlMsgUtils.error('Ident:utility:invalidProperty',Name)
        
    otherwise
        % Multiple hits. Take shortest match provided it is contained
        % in all other matches (Xlim and XlimMode as matches is OK, but
        % InputName and InputGroup is ambiguous)
        [minlength,imin] = min(cellfun('length',PropList(imatch)));
        Property = PropList{imatch(imin)};
        if ~all(strncmpi(Property,PropList(imatch),minlength))
            ctrlMsgUtils.error('Ident:utility:ambiguousProp',Name)
        end
        imatch = imatch(imin);
end
