function s = struct(h)
%STRUCT  Converts to structure

%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:16:45 $
s = struct(...
   'Color',h.Color,...
   'FontAngle',h.FontAngle,...
   'FontSize',h.FontSize,...
   'FontWeight',h.FontWeight,...
   'Interpreter',h.Interpreter);