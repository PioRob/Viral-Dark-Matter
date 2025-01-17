function str = warning_link(message,filename)
%NN_WARNING_LINK Warning message with link to warning doc file.
%
%  STR = NN_WARNING_LINK(message,warning_filename)

% Copyright 2010 The MathWorks, Inc.

str = nnlink.str2link(message,['matlab:doc nnwarning.' filename]);
