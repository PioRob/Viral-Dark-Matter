function info = imfinfo(filename, format)
%IMFINFO Information about graphics file.
%   INFO = IMFINFO(FILENAME,FMT) returns a structure whose
%   fields contain information about an image in a graphics
%   file.  FILENAME is a string that specifies the name of the
%   graphics file, and FMT is a string that specifies the format
%   of the file.  The file must be in the current directory or in
%   a directory on the MATLAB path.  If IMFINFO cannot find a
%   file named FILENAME, it looks for a file named FILENAME.FMT.
%   
%   The possible values for FMT are contained in the file format
%   registry, which is accessed via the IMFORMATS command.
%
%   If FILENAME is a TIFF, HDF, ICO, GIF, or CUR file containing more
%   than one image, INFO is a structure array with one element for
%   each image in the file.  For example, INFO(3) would contain
%   information about the third image in the file.  
%
%   INFO = IMFINFO(FILENAME) attempts to infer the format of the
%   file from its content.
%
%   INFO = IMFINFO(URL,...) reads the image from an Internet URL.
%   The URL must include the protocol type (e.g., "http://").
%
%   The set of fields in INFO depends on the individual file and
%   its format.  However, the first nine fields are always the
%   same.  These common fields are:
%
%   Filename       A string containing the name of the file
%
%   FileModDate    A string containing the modification date of
%                  the file
%
%   FileSize       An integer indicating the size of the file in
%                  bytes
%
%   Format         A string containing the file format, as
%                  specified by FMT; for formats with more than one
%                  possible extension (e.g., JPEG and TIFF files),
%                  the first variant in the registry is returned
%
%   FormatVersion  A string or number specifying the file format
%                  version 
%
%   Width          An integer indicating the width of the image
%                  in pixels
%
%   Height         An integer indicating the height of the image
%                  in pixels
%
%   BitDepth       An integer indicating the number of bits per
%                  pixel 
%
%   ColorType      A string indicating the type of image; this could
%                  include, but is not limited to, 'truecolor' for a 
%                  truecolor (RGB) image, 'grayscale', for a grayscale 
%                  intensity image, or 'indexed' for an indexed image.
%
%   If FILENAME contains Exif tags (JPEG and TIFF only), then the INFO 
%   struct may also contain 'DigitalCamera' or 'GPSInfo' (global 
%   positioning system information) fields.
%
%   The value of the GIF format's 'DelayTime' field is given in hundredths
%   of seconds.
%
%   Example:
%     
%      info = imfinfo('ngc6543a.jpg');
%
%   See also IMREAD, IMWRITE, IMFORMATS.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.14 $  $Date: 2009/11/09 16:27:13 $

error(nargchk(1, 2, nargin, 'struct'));

info = [];

if (~isNonEmptyString(filename))
    error('MATLAB:imfinfo:badFilename', ...
          'Filename must be a non-empty string.')
end

% Download remote file.
[isUrl, filename] = getFileFromURL(filename);

if (nargin < 2)
  
    % With 1 input argument, we must be able to open the file
    % exactly as given.  Try it.
    
    fid = fopen(filename, 'r');
    
    if (fid == -1)
      
        error('MATLAB:imfinfo:fileOpen', ...
              'Unable to open file "%s" for reading.', filename);
               
    end
      
    filename = fopen(fid);  % Get the full pathname if not in pwd.
    fclose(fid);
  
    % Determine filetype from file.
    [format, fmt_s] = imftype(filename);
    
    if (isempty(format))
      
        % Couldn't determine filetype.
        error('MATLAB:imfinfo:whatFormat', ...
              'Unable to determine file format.');
        
    end
    
else
  
    % The format was passed in.
    % Look for the format in the registry.
    fmt_s = imformats(format);
    
    if (isempty(fmt_s))
      
        % Format was not in registry.
        error('MATLAB:imfinfo:unknownFormat', ...
              'Could not find format "%s" in format registry.', format);
        
    end

    % Find the exact name of the file.
    fid = fopen(filename, 'r');

    if (fid == -1)

        % Since the user explicitly specified the format, see if we can find
        % the file using an extension.
    
        found = 0;
        
        for p = 1:length(fmt_s.ext)
          
            fid = fopen([filename '.' fmt_s.ext{p}], 'r');
            
            if (fid ~= -1)
              
                % File was found.  Update filename.
                found = 1;
                
                filename = fopen(fid);
                fclose(fid);
                
                break;
                
            end
            
        end
        
        % Check that some filename+format combination was found.
        if (~found)
            
            error('MATLAB:imfinfo:fileOpenWithExtension', ...
                  'Unable to open file "%s" for reading.', filename);
            
        end
        
    else
      
        % The file exists as passed in.  Get full pathname from file.
        filename = fopen(fid);
        fclose(fid);
        
    end
    
end

% Call info function from IMFORMATS on filename
if (~isempty(fmt_s.info))
  
    info = feval(fmt_s.info, filename);
    
else
  
     error('MATLAB:imfinfo:noInfoFunction', ...
           ['Format %s has no INFO function registered.  See', ...
            ' "help imformats".'], format);
        
end


% Delete temporary file from Internet download.
if (isUrl)
    deleteDownload(filename);
end
