function boo = isStatic(this)
% Checks if compensator is static

%   Copyright 1986-2005 The MathWorks, Inc. 
%   $Revision: 1.1.8.1 $  $Date: 2006/01/26 01:46:13 $
boo = isstatic(this.ZPKData);