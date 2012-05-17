function varargout = todoubles(varargin)
%TODOUBLES FI to Double
%   [D1,D2,...] = TODOUBLES(F1,F2,...) converts fixed-point objects
%   F1, F2, ... to doubles D1, D2, ... respectively.  Any input that
%   is not a FI object is passed through to the output.
%
%   Helper function for converting fixed-point objects to double.

%   Thomas A. Bryan, 6 February 2003
%   Copyright 1999-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2006/12/20 07:13:00 $

varargout = cell(size(varargin));
for k=1:nargin
  if isa(varargin{k},'embedded.fi')
    varargout{k} = double(varargin{k});
  else
    varargout{k} = varargin{k};
  end
end
