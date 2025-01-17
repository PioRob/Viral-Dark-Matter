function setpixelposition(h,position,recursive)
% SETPIXELPOSITION Set position HG object in pixels.
%   SETPIXELPOSITION(HANDLE, POSITION) sets the position of the object specified by
%   HANDLE in pixel units to the specified POSITION.
%
%   SETPIXELPOSITION(HANDLE, POSITION, RECURSIVE) sets the position as above. If
%   RECURSIVE is true, the position is set relative to the parent
%   figure of HANDLE.
%
%   Example:
%       f = figure;
%       p = uipanel('Position', [.2 .2 .6 .6]);
%       h1 = uicontrol(p, 'Units', 'normalized', 'Position', [.1 .1 .5 .2]);
%       % Get pixel position w.r.t the parent uipanel
%       pos1 = getpixelposition(h1);
%       % Set pixel position on the uicontrol
%       pause(1);
%       setpixelposition(h1, pos1 + [10 10 20 20]);
%       
%   See also GETPIXELPOSITION, UICONTROL, UIPANEL

% Copyright 1984-2006 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2008/08/01 12:23:40 $

% Verify that setpixelposition is given between 2 and 3 arguments
error(nargchk(2, 3, nargin, 'struct')) 

% Verify that "h" is a handle
if ~ishghandle(h)
    error('MATLAB:setpixelposition:InvalidHandle', 'Input argument "h" must be a HANDLE')
end

% Verify that if "position" does exist it is a 1x4 numerical matrix
if ~(length(position)==4 && isnumeric(position) && isvector(position))
        error('MATLAB:setpixelposition:InvalidPosition', 'Input argument "position" must be a 4 element vector')
end


if nargin < 3
  recursive = false;
end

if recursive
    parent = get(h,'Parent');
    if ~ishghandle(parent,'figure')
        parentpos = getpixelposition(parent, true);
        position(1) = position(1) - parentpos(1);
        position(2) = position(2) - parentpos(2);        
    end
end

old_u = get(h,'Units');
set(h,'Units','pixels');
wasError = false;
try
    set(h,'Position',position);
catch ex
    wasError = true;
end
set(h,'Units',old_u);
if wasError
    rethrow(ex);
end

end
