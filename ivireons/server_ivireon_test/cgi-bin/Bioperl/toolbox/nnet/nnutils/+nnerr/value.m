function message = value(message,varargin)
%NNREPVAL Replaces 'VALUE' with variable name in message string.
%
%  NNREPVAL(MESSAGE,NAME) updates MESSAGE by replacing an occurance
%  of 'VALUE' with the string NAME.
%
%  NNREPVAL(MESSAGE,NAME1,NAME2,...) updates MESSAGE by replacing
%  occurances of 'VALUE1', 'VALUE2', etc., with strings NAME1, NAME2, etc.
%
%  NNREPVAL(MESSAGE,{NAME1,NAME2,...}) is an alternate calling
%  form to NNREPVAL(MESSAGE,NAME,NAME2,...)

% Copyright 2010 The MathWorks, Inc.

if nargin == 1, return; end

% Alternate calling form
names = varargin;
if (length(names)==1) && iscell(names{1})
  names = names{1};  
end
numNames = length(varargin);

% Fill in value names in message
if numNames == 1
  name = names{1};
  message = strrep(message,'VALUE',name);
elseif numNames > 1
  for i=1:numNames
    message = strrep(message,['VALUE' num2str(i)],names{i});
  end
end
