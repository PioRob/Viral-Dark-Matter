function h = fighandle(HG)
%FIGHANDLE/FIGHANDLE Make fighandle object
%   This file is an internal helper function for plot annotation.

%   Copyright 1984-2005 The MathWorks, Inc. 
%   $Revision: 1.10.4.2 $  $Date: 2005/09/12 18:58:27 $

if nargin==0
   h.Class = 'fighandle';
   h.figStoreHGHandle = [];
   h = class(h,'fighandle');
   return
end

h.Class = 'fighandle';
h.figStoreHGHandle = HG;
h = class(h,'fighandle');

