function file = dicom_create_file_struct
%CREATE_FILE_STRUCT  Create a file structure with default values.
%   FILE = DICOM_CREATE_FILE create a structure FILE to contain
%   information about the DICOM message pool.  On creation, the fields
%   are filled with values to indicate that no files have been chosen.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/04/15 15:18:43 $

file.Filename = '';
file.Current_Message = 0;
file.FID = -1;
file.Current_Endian = '';
file.Pixel_Endian = '';
file.Current_VR = '';
file.Warn.Current = 0;
file.Warn.Max = inf;
