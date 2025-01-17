function openurl(urlFile)
%OPENURL Opens the MATLAB Web Browser on the URL specified in the file..

%   Copyright 1984-2003 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $  $Date: 2004/07/16 18:33:54 $

URL = '';
fid = fopen(urlFile, 'r');
URLLoc = [];
if fid ~= -1
    IS = [10 'URL='];
    contents = fread(fid,'*char')';
    fclose(fid);
    URLLoc = findstr(contents, IS);
end

if ~isempty(URLLoc)
    URL = contents(URLLoc(1) + length(IS):end);
    crLoc = findstr(URL, char(10));
    if ~isempty(crLoc)
        URL = URL(1:crLoc(1));
    end
end

if ~isempty(URL)
    web(URL);
else
    error('MATLAB:openURL:cannotRead', 'Cannot open the specified URL.');
end
    
    
