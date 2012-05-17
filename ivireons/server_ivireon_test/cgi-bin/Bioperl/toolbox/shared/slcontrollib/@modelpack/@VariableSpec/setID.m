function this = setID(this, ID)
% SETID Sets the identifier object associated with THIS.
%
% ID is an object subclassed from VARIABLEID (vector of objects if THIS is an
% object array).

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 2000-2006 The MathWorks, Inc.
% $Revision: 1.1.8.3 $ $Date: 2006/09/30 00:25:56 $

warning('modelpack:AbstractMethod', ...
        'Method needs to be implemented by subclasses.');