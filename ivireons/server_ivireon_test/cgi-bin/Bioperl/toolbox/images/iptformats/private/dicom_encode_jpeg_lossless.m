function [fragments, frames] = dicom_encode_jpeg_lossless(X, bits)
%DICOM_ENCODE_JPEG_LOSSLESS   Encode pixel cells using lossless JPEG.
%   [FRAGMENTS, LIST] = DICOM_ENCODE_JPEG_LOSSLES(X) compresses and
%   encodes the image X using baseline lossles JPEG compression.
%   FRAGMENTS is a cell array containing the encoded frames (as UINT8
%   data) from the compressor.  LIST is a vector of indices to the first
%   fragment of each compressed frame of a multiframe image.
%
%   See also DICOM_ENCODE_RLE, DICOM_ENCODE_JPEG_LOSSY.

%   Copyright 1993-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2008/11/24 14:58:51 $


% Use IMWRITE to create a JPEG image.
tempfile = tempname;

classname = class(X);

switch (classname)
case {'int8', 'int16'}
    tmp = dicom_typecast(X(:), ['u' classname]);
    X = reshape(tmp, size(X));
end

imwrite(X, tempfile, 'jpeg', 'mode', 'lossless', 'bitdepth', bits);

% Read the image from the temporary file.
fid = fopen(tempfile, 'r');
fragments{1} = fread(fid, inf, 'uint8=>uint8');
fclose(fid);

frames = 1;

% Remove the temporary file.
try
    delete(tempfile)
catch
    
    warning('Images:dicom_encode_jpeg_lossless:tempFileDelete',...
	    'Unable to delete temporary file "%s".', tempfile);
end
