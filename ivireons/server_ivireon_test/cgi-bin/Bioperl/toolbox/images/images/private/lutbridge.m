function lut = lutbridge
%LUTBRIDGE Compute "bridge" look-up table.

%   Copyright 1993-2003 The MathWorks, Inc.  
%   $Revision: 1.10.4.2 $  $Date: 2004/08/10 01:45:37 $

lut = [ ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     1     1     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     0     1     0     0 ...
     0     1     0     0     1     1     0     0     1     1     0     0 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     0     0     1     1     1     1     1     1 ...
     0     0     0     0     1     1     0     0     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     0     0 ...
     1     1     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     0     1     1     1 ...
     1     1     1     1     0     0     0     0     1     1     0     0 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     0     1     0     0     0     1     0     0 ...
     0     0     0     0     0     0     0     0     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     0     1     1     1     1     1     1     1     0     0     0     0 ...
     1     1     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     0     1     0     0 ...
     0     1     0     0     0     0     0     0     0     0     0     0 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     0     1     1     1     0     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     0     1     0     0     0     1     0     0     1     1     0     0 ...
     1     1     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     0     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     0     0     1     1     0     0     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     0     1     1     1     1     1     1     1     0     0     0     0 ...
     1     1     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1     0     1     0     0 ...
     0     1     0     0     0     0     0     0     0     0     0     0 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     1     1     1     1     0     1     1     1     1     1     1     1 ...
     0     0     0     0     1     1     0     0     1     1     1     1 ...
     1     1     1     1     1     1     1     1     1     1     1     1 ...
     0     1     0     0     0     1     0     0     0     0     0     0 ...
     0     0     0     0     1     1     1     1     1     1     1     1 ...
     1     1     1     1     1     1     1     1];

lut = lut(:);
