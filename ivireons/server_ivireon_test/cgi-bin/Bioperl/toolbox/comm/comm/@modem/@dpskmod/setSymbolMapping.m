function mapping = setSymbolMapping(h, mapping)
%SETSYMBOLMAPPING Set SymbolMapping property for object H.

%   @modem/@dpskmod

%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2007/06/08 15:52:56 $

% Call base function
baseSetSymbolMapping(h, mapping);

% Reset
reset(h);

%-------------------------------------------------------------------------------
% [EOF]