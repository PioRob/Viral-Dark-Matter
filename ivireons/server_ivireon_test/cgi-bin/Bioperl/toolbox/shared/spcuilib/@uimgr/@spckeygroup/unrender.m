function unrender(this)
%UNRENDER <short description>
%   OUT = UNRENDER(ARGS) <long description>

%   Author(s): J. Yu
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2007/05/23 19:07:29 $

if ~isempty(this.hKeyGroup)
    this.hKeyGroup.disconnect;
end

% [EOF]