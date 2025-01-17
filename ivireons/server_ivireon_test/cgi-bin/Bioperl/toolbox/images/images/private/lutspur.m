function lut = lutspur
%LUTSPUR End-point detection lookup tables for bwmorph(BW,'spur').
%   LUT = LUTSPUR returns a 512-by-1 matrix containing a lookup
%   table.  The lookup table is designed to find end-points in a
%   complemented image; that is, an image where 0 represents a
%   foreground pixel and 1 represents a background pixel.
%
%   See also BWMORPH.

%   Copyright 1993-2003 The MathWorks, Inc.  
%   $Revision: 1.12.4.1 $  $Date: 2003/01/26 06:00:28 $

% Here's the test for each neighborhood:
% isEastEndPoint = (x(2,1)==0) & (x(2,2)==0) & (x(1,2)==1) & ...
%         (x(1,3)==1) & (x(2,3)==1) & (x(3,2)==1) & (x(3,3)==1);
% 
% isSouthEndPoint = (x(1,2)==0) & (x(2,2)==0) & (x(2,1)==1) & ...
%         (x(2,3)==1) & (x(3,1)==1) & (x(3,2)==1) & (x(3,3)==1);
% 
% isWestEndPoint = (x(2,2)==0) & (x(2,3)==0) & (x(1,1)==1) & ...
%         (x(1,2)==1) & (x(2,1)==1) & (x(3,1)==1) & (x(3,2)==1);
% 
% isNorthEndPoint = (x(2,2)==0) & (x(3,2)==0) & (x(1,1)==1) & ...
%         (x(1,2)==1) & (x(1,3)==1) & (x(2,1)==1) & (x(2,3)==1);
% 
% isSoutheastEndPoint = (x(2,2)==0) & (x(1,1)==0) & (sum(x(:))==7);
% 
% isSouthwestEndPoint = (x(2,2)==0) & (x(1,3)==0) & (sum(x(:))==7);
% 
% isNorthwestEndPoint = (x(2,2)==0) & (x(3,3)==0) & (sum(x(:))==7);
% 
% isNortheastEndPoint = (x(2,2)==0) & (x(3,1)==0) & (sum(x(:))==7);
% 
% isEndPoint = isEastEndPoint | isSouthEndPoint | isWestEndPoint | ...
%         isNorthEndPoint | isSoutheastEndPoint | isSouthwestEndPoint | ...
%         isNorthwestEndPoint | isNortheastEndPoint;

lut = [ ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     1 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     1     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     1 ...
     0     0     0     1     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     1 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     1     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     1     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     1     1     0     0     0     0     0     0     0     1 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     1     0     0     0     1     0     0     0     0 ...
     0     0     0     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     1     1     1     1     0     1 ...
     1     1     1     0     0     0     0     0     0     0     0     0 ...
     0     0     0     0     0     0     0     0];

lut = lut(:);


