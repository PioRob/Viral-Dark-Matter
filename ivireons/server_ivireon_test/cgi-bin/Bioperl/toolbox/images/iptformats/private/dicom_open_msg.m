function file = dicom_open_msg(file, mode)
%DICOM_OPEN_MSG  Open the next DICOM message in the pool for processing.
%   FILE = DICOM_OPEN_MSG(FILE, 'r') opens the next DICOM message in the
%   pool for reading.
%
%   FILE = DICOM_OPEN_MSG(FILE, 'w') opens the next DICOM message in the
%   pool for writing.
%
%   Note: The pool of messages is generated by DICOM_GET_MSG.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/04/15 15:18:46 $

% Open the message.
switch (lower(mode))
case 'r'
    
    file.FID = fopen(file.Filename, 'r', 'ieee-le');
    
    if (file.FID < 0)
        
        error('Images:dicom_open_msg:fileOpen', ...
              'Could not open "%s" for reading', ...
              file.Filename{file.Current_Message});
        
    end

case 'w'

    file.FID = fopen(file.Filename, 'w', 'ieee-le');

    if (file.FID < 0)
        
        error('Images:dicom_open_msg:fileOpen', ...
              'Could not open "%s" for writing', ...
              file.Filename);
        
    end
    
otherwise
    
    error('Images:dicom_open_msg:openMode', 'Mode must be either ''r'' or ''w''.')
    
end

% Set local files to default transfer syntax (for fragments).
% DICOM_SET_MMETA_ENCODING will change this if appropriate.
file.Current_Endian = 'ieee-le';
file.Pixel_Endian = 'ieee-le';
file.Current_VR = 'Implicit';