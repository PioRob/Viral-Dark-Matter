function webError( errorMessage, reportName )
% Display an Error message in the web browser
%   This function is unsupported and might change or be removed without
%   notice in a future version. 


% Copyright 2009 The MathWorks, Inc.

if nargin < 2
    reportName = '';
end

error = ['<html><head><title>' sprintf('%s: ERROR', reportName) '</title></head>'];
error = [error '<body><h3><font style="color:red;">' errorMessage '</font></h3></body></html>'];
web(['text://' error], '-noaddressbox');