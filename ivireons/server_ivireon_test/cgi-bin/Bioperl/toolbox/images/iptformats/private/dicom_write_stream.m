function [file, msg] = dicom_write_stream(file, data_streams)
%DICOM_WRITE_STREAM   Write an encoded stream to a file.
%   [FILE, MSG] = DICOM_WRITE_STREAM(FILE, STREAMS) writes the UINT8 data
%   streams stored in the cell array STREAMS to the message specified in
%   FILE.  An updated FILE structure is returned along with any
%   diagnostic information in the MSG character array.
%
%   See also DICOM_OPEN_MSG, DICOM_GET_MSG.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/04/15 15:18:48 $


msg = '';

if (file.FID < 0)
    
    msg = sprintf('Invalid FID for file "%s".', ...
                  file.Filename);
    return
    
end

% Write the DICOM preamble.
count1 = fwrite(file.FID, repmat(uint8(0), [128 1]), 'uint8');
count2 = fwrite(file.FID, uint8([68 73 67 77]), 'uint8');  % DICM

if ((count1 + count2) ~= 132)
    
    msg = sprintf('File "%s" truncated while writing preamble.', ...
                  file.Filename);
    return
    
end

% Write the data to the file.
for p = 1:length(data_streams)
    count = fwrite(file.FID, data_streams{p}, 'uint8');

    if (count ~= numel(data_streams{p}))
        
        msg = sprintf('File "%s" truncated while writing message data.', ...
                      file.Filename);
        return
        
    end

end
