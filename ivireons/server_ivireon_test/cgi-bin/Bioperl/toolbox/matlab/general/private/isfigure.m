function isF = isfigure( h )
%ISFIGURE True for Figure handles.
%   ISFIGURE(H) returns an array that contains 1's where the elements
%   of H are valid Figure handles and 0's where they are not.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.7.4.6 $  $Date: 2008/12/15 08:52:37 $

% NOTE: This is a copy of toolbox/matlab/graphics/private/isfigure.m.
% If one of these becomes a user-visible function (outside the private 
% directories) then the other needs to be removed. 
% Till then, ideally, any change needs to be made in both the files.

if nargin < 1
        error( nargchk(1,1,nargin,'struct') )
end

isF = ishghandle(h, 'figure');

end
