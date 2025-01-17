function b = hassignalonly(h)
%HASSIGNALONLY   True if the object is signalonly.

%   Author(s): G. Taillefer
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2007/11/17 21:49:35 $


b = ...
  ~isempty(h.Signal) && ...
  isempty(h.DesignMin) && ...
  isempty(h.DesignMax) && ...
  isempty(h.SimMin) && ...
  isempty(h.SimMax);

% [EOF]
