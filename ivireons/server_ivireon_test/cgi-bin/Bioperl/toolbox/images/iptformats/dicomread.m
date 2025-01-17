function [X, map, alpha, overlays] = dicomread(msgname, varargin)
%DICOMREAD  Read DICOM image.
%   X = DICOMREAD(FILENAME) reads the image data from the compliant DICOM
%   file FILENAME.  For single-frame grayscale images, X is an M-by-N
%   array.  For single-frame true-color images, X is an M-by-N-by-3 array.
%   Multiframe images are always 4-D arrays.
%
%   X = DICOMREAD(INFO) reads the image data from the message referenced in
%   the DICOM metadata structure INFO.  The INFO structure is produced by
%   the DICOMINFO function.
%
%   [X, MAP] = DICOMREAD(...) returns the colormap MAP for the image X.  If
%   X is a grayscale or true-color image, MAP is empty.
%
%   [X, MAP, ALPHA] = DICOMREAD(...) returns an alpha channel matrix for X.
%   The values of ALPHA are 0 if the pixel is opaque; otherwise they are
%   row indices into MAP.  The RGB value in MAP should be substituted for
%   the value in X to use ALPHA. ALPHA has the same height and width as X
%   and is 4-D for a multiframe image.
%
%   [X, MAP, ALPHA, OVERLAYS] = DICOMREAD(...) also returns any overlays
%   from the DICOM file.  Each overlay is a 1-bit black and white image
%   with the same height and width as X.  If multiple overlays are present
%   in the file, OVERLAYS is a 4-D multiframe image.  If no overlays are in
%   the file, OVERLAYS is empty.
%
%   [...] = DICOMREAD(FILENAME, 'Frames', V) reads only the frames in the
%   vector V from the image.  V must be an integer scalar, a vector of
%   integers, or the string 'all'.  The default value is 'all'.
%
%   Examples
%   --------
%   Use DICOMREAD to retrieve the data array, X, and colormap matrix, map,
%   needed to create a montage.
%
%      [X, map] = dicomread('US-PAL-8-10x-echo.dcm');
%      montage(X, map, 'Size', [2 5]);
%
%   Call DICOMREAD with the information retrieved from the DICOM file using
%   DICOMINFO, and display the image using IMSHOW. Adjust the contrast of
%   the image using IMCONTRAST.
%
%      info = dicominfo('CT-MONO2-16-ankle.dcm');
%      Y = dicomread(info);
%      figure, imshow(Y);
%      imcontrast;
%
%   Class support
%   -------------
%   X can be uint8, int8, uint16, or int16.  MAP will be double.  ALPHA
%   has the same size and type as X.  OVERLAYS is a logical array.
%
%   File support
%   ------------
%   This function reads imagery from files with one of these pixel formats:
%   * Little-endian, implicit VR, uncompressed
%   * Little-endian, explicit VR, uncompressed
%   * Big-endian, explicit VR, uncompressed
%   * JPEG (lossy or lossless)
%   * JPEG2000 (lossy or lossless)
%   * Run-length Encoding (RLE)
%   * GE implicit VR, LE with uncompressed BE pixels (1.2.840.113619.5.2)
%
%   See also DICOMINFO, DICOMWRITE, DICOMDICT.

%   This function (along with DICOMINFO) implements the M-READ service.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.4 $  $Date: 2010/04/15 15:18:39 $


% Parse the input arguments.
if (nargin < 1)

    error('Images:dicomread:numInputs', ...
        'DICOMREAD requires at least one argument.');

end

frames = parseParams(varargin{:});
[X, map, alpha, overlays] = newDicomread(msgname, frames);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function frames = parseParams(varargin)
% Use old dicomread if a user specifies obsolete parameters ('dictionary'
% or 'raw').

frames = [];
if (nargin == 0)

    return

end

% These are the syntaxes to watch for.
paramStrings = {'dictionary'
                'raw'
                'frames'};

% Look through the input parameters.
for k = 1:2:length(varargin)

    param = lower(varargin{k});

    if (~ischar(param))
      
        eid = 'Images:dicomread:parameterNameNotString';
        error(eid, 'Parameter name must be a string');
        
    end

    idx = strmatch(param, paramStrings);

    if (isempty(idx))

        eid = 'Images:dicomread:unrecognizedParameterName';
        error(eid, 'Unrecognized parameter name "%s"', param);

    elseif (length(idx) > 1)

        eid = 'Images:dicomread:ambiguousParameterName';
        error(eid, 'Ambiguous parameter name "%s"', param);

    else

        if (isequal(paramStrings{idx}, 'frames'))

            if (ischar(varargin{k + 1}) && ~isequal(lower(varargin{k + 1}), 'all'))
              
              eid = 'Images:dicomread:badFrameParameter';
              error(eid, ...
                    'Frames must be a vector of integers or ''All''.')
              
            else
              
                if (isequal(lower(varargin{k + 1}), 'all'))
                  
                    frames = [];
                    
                else
              
                    iptcheckinput(frames, {'double'}, ...
                                  {'vector', 'integer', 'positive'}, mfilename, 'Frames', k);
    
                    frames = varargin{k + 1};
                    
                end
              
            end
            
        else
            
            error('Images:dicomread:obsoleteSyntax', ...
                  'Parameter ''%s'' is no longer supported.', ...
                  paramStrings{idx(1)});
            
        end
        
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, map, alpha, overlays] = newDicomread(msgname, frames)

% Get the filename.
if (isstruct(msgname))

    filename = msgname.Filename;

elseif (~ischar(msgname))

    error('Images:dicomread:badMessage', ...
        'The first input argument must be a filename or DICOM info struct.');

else

    filename = msgname;

end

% Get details about the file to read.
d = dir(filename);

if (isempty(d))

    fid = fopen(filename);

    if (fid < 0)

        error('Images:dicomread:fileNotFound', ...
            'File "%s" not found.', filename);

    end

    filename = fopen(fid);
    d = dir(filename);
    d.name = filename;
    fclose(fid);

else

    d.name = filename;

end

% Parse the DICOM file into a set of tags containing "raw" UINT8 data.
dictionaryFile = dicomdict('get_current');
machineEndian = getEndianOfMachine;
%dicomparse syntax takes filename, filesize, machine_endian, read_pixels,
%and a dictionary as inputs. attrs is an n-by-1 array of structures
%where n is the number of attributes that appear at top level of DICOM file.
[attrs, settings] = dicomparse(d.name, d.bytes, ...
    machineEndian, true, dictionaryFile, frames);

if (isempty(attrs))

    error('Images:dicomread:parseError', 'Trouble parsing DICOM file.')

end

% Get the tags necessary for decoding the pixel data.
resetRepeatedGroupsMask;
swapAttributeBytes = ~isequal(machineEndian, settings.Endian);
metadata = getAttributesNeededForReading(attrs, swapAttributeBytes);

% Cast some of the attributes to double so that future computations happen
% correctly in MATLAB.  We deliberately don't do this earlier because the
% attributes have to be read in its native type first, and many don't need
% to be converted to double at all.
metadata = convertToDouble(metadata);

% Get file details based on the transfer syntax UID.
txfrDetails = getTxfrSyntaxDetails(metadata.TransferSyntaxUID);

% Decompress/decode the pixel data and get the finished frame(s).
if ~txfrDetails.EncodingSupported

    error('Images:dicomread:unsupportedEncoding', ...
        'Unsupported data encoding.')

elseif txfrDetails.DataCompressed

    X = processEncapsulatedPixels(metadata, frames);

else

    X = processRawPixels(metadata, frames);

end

% Convert colorspace if necessary.
if txfrDetails.RequiresColorspaceConversion

    switch (metadata.PhotometricInterpretation)
        case {'YBR_FULL', 'YBR_FULL_422'}

            % YCbCr full:  Convert and rescale in one step.
            X = ycbcr2rgbDicom(X, 'full', metadata.BitsStored);

        case {'YBR_PARTIAL_422'}

            % YCbCr partial (4:2:2):  Convert and rescale in one step.
            X = ycbcr2rgbDicom(X, 'partial', metadata.BitsStored);

    end

end

% Only get colormap, alpha channel and overlay if they're requested.
map = [];
alpha = [];
overlays = [];

if (nargout >= 2)
    map = getColormap(metadata);
end

if (nargout >= 3)
    alpha = getAlpha(X, metadata);
    if (~isempty(alpha))
        X(:,:,1,:) = [];
    end
end

if (nargout >= 4)
    [overlays, X] = getOverlays(X, metadata);
end

% (We can't apply the "frames" parameter to the overlays, because the overlays
% may not match 1-to-1 with the image frames.)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function byteOrder = getEndianOfMachine

persistent endian

if (~isempty(endian))
    byteOrder = endian;
else
    [c, m, endian] = computer;
    byteOrder = endian;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resetRepeatedGroupsMask
% 'reset' clears out the repeated groups mask.
hasRepeatedGroups([], 'reset');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function metadata = getAttributesNeededForReading(attrs, swapAttrBytes)

persistent dictionary
if (isempty(dictionary))
    dictionary = newMiniDictionary;
end

metadata = initializeMetadata(dictionary);

allGroups = [attrs(:).Group];
allElements = [attrs(:).Element];

for p = 1 : numel(dictionary)
    % data can be a scalar, vector, or cell array.
    data = getAttributeData(attrs, allGroups, allElements, ...
        dictionary(p), swapAttrBytes);
    metadata.(dictionary(p).Name) = data;
end

% Get the number of frames from the metadata.  Frame number is stored as a
% character in the metadata.
metadata.NumberOfFrames = getNumberOfFrames(metadata);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dictionary = newMiniDictionary
%NEWMINIDICTIONARY  Create a mini DICOM dictionary for image reading.

d = {'0002', '0010', 'TransferSyntaxUID',         'char',   ''
    '0028', '0002', 'SamplesPerPixel',           'uint16', 1
    '0028', '0004', 'PhotometricInterpretation', 'char',   ''
    '0028', '0006', 'PlanarConfiguration',       'uint16', []
    '0028', '0008', 'NumberOfFrames',            'char',   ''
    '0028', '0010', 'Rows',                      'uint16', []
    '0028', '0011', 'Columns',                   'uint16', []
    '0028', '0100', 'BitsAllocated',             'uint16', []
    '0028', '0101', 'BitsStored',                'uint16', []
    '0028', '0102', 'HighBit',                   'uint16', []
    '0028', '0103', 'PixelRepresentation',       'uint16', []
    '0028', '1101', 'RedPaletteLUTDescriptor',   'uint16', []
    '0028', '1102', 'GreenPaletteLUTDescriptor', 'uint16', []
    '0028', '1103', 'BluePaletteLUTDescriptor',  'uint16', []
    '0028', '1201', 'RedPaletteLUTData',         'uint16', []
    '0028', '1202', 'GreenPaletteLUTData',       'uint16', []
    '0028', '1203', 'BluePaletteLUTData',        'uint16', []
    '60XX', '0010', 'OverlayRows',               'uint16cell', {}
    '60XX', '0011', 'OverlayColumns',            'uint16cell', {}
    '60XX', '0012', 'OverlayPlanes',             'uint16cell', {}
    '60XX', '0015', 'NumberOfFramesInOverlay',   'uint16cell', {}
    '60XX', '0100', 'OverlayBitsAllocated',      'uint16cell', {}
    '60XX', '0102', 'OverlayBitPosition',        'uint16cell', {}
    '60XX', '3000', 'OverlayData',               'uint16cell', {}
    '7FE0', '0010', 'InstanceData',              'uint8',  []};

% Group number is in hex, Element number is in hex.
fieldnames = {'Group', 'Element', 'Name', 'Datatype', 'Default'};
dictionary = cell2struct(d, fieldnames, 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function metadata = initializeMetadata(dictionary)
%initializeMetadata initializesMetadata with core fields

dictionaryNames = {dictionary.Name};
dictionaryDefaultValues = {dictionary.Default};
metadata = cell2struct(dictionaryDefaultValues, dictionaryNames,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = getAttributeData(attrs, allGroups, allElements, ...
    dictionaryEntry, swapAttrBytes)

if (isequal(dictionaryEntry.Group(3:4), 'XX'))

    % Repeated group attribute. data is a cell array.
    data = processRepeatedGroups(attrs, dictionaryEntry, ...
        allElements, swapAttrBytes);

else

    % Normal attribute.
    grp = sscanf(dictionaryEntry.Group, '%x');
    elt = sscanf(dictionaryEntry.Element, '%x');

    % Look for the dictionary entry in the data set, and process it.
    idx = find((grp == allGroups) & (elt == allElements));

    if (~isempty(idx))

        if (numel(idx) > 1)

            % Attributes should only appear once at a particular level.
            % Warn and use the last one (consistent with DICOMINFO).
            warning('Images:dicomread:repeatedAttribute', ...
                'Attribute (%04X,%04X) appears more than once.  Using the last one.', ...
                grp, elt)

            idx = idx(end);
        end

        data = getData(attrs(idx), dictionaryEntry, swapAttrBytes);

    else

        data = dictionaryEntry.Default;

    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nFrames = getNumberOfFrames(metadata)

if (~isempty(metadata.NumberOfFrames))

    % Process multiple frame data, which is like encapsulated data.
    nFrames = sscanf(metadata.NumberOfFrames, '%d');
    if (isempty(nFrames))

        nFrames = 1;
        warning('Images:dicomread:badNumberOfFrames', ...
            'Could not determine number of frames.');

    end

else

    nFrames = 1;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function metadata = convertToDouble(metadata)
%CONVERTDATATYPES  convert required numeric types to double.

metadata.BitsAllocated = double(metadata.BitsAllocated);
metadata.BitsStored = double(metadata.BitsStored);
metadata.HighBit = double(metadata.HighBit);
metadata.Rows = double(metadata.Rows);
metadata.Columns = double(metadata.Columns);

if (isfield(metadata, 'SamplesPerPixel'))
    metadata.SamplesPerPixel = double(metadata.SamplesPerPixel);
end

if (isfield(metadata, 'NumberOfFrames'))
    metadata.NumberOfFrames = double(metadata.NumberOfFrames);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = processRepeatedGroups(attrs, dictionaryEntry, ...
    allElements, swapAttrBytes)

% Is dictionaryEntry.Group repeated anywhere in the file?
if (~hasRepeatedGroups(attrs, dictionaryEntry.Group))

    data = dictionaryEntry.Default;
    return

end

% Find the locations of the repeated attributes with the element number
% dictionaryEntry.Element.
elt = sscanf(dictionaryEntry.Element, '%x');

% repeatedGroupsMask returns a mask (n-by-1 array) where true denotes a
% repeated group in the attrs array.
repeatedGroupMask = getRepeatedGroupMask(attrs, dictionaryEntry.Group);
repeatedAttributeIdxs = find( repeatedGroupMask & (elt == allElements));
numRepeatedAttributes = numel(repeatedAttributeIdxs);

data = cell(1, numRepeatedAttributes);

for count = 1 : numRepeatedAttributes

    idx = repeatedAttributeIdxs(count);
    % getData returns a cell array.
    data(count) = getData(attrs(idx), dictionaryEntry, swapAttrBytes);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tf = hasRepeatedGroups(attrs, group)

% We store any variable that is not giong to change between multiple
% dicomread calls within a MATLAB session as persistent variables.
persistent cachedTF;

if ((isempty(attrs)) && (isequal(group, 'reset')))

    getRepeatedGroupMask([], 'reset');
    cachedTF = [];
    tf = cachedTF;
    % don't go into next 'if' block.
    return;

end

if isempty(cachedTF)

    mask = getRepeatedGroupMask(attrs, group);
    cachedTF = any(mask);

end

tf = cachedTF;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mask = getRepeatedGroupMask(attr, group)

persistent groupMask;

if ((isempty(attr)) && (isequal(group, 'reset')))

    groupMask = [];
    mask = groupMask;
    return

elseif (isempty(groupMask))

    % Create a mask of all repeated public groups in the same range as the
    % requested group.
    repStart = sscanf([group(1:2) '00'], '%x');

    allGroups = [attr(:).Group];
    groupMask = ((allGroups >= repStart) & (allGroups < (repStart + 256)) & ...
        (rem(allGroups, 2) ~= 1));
    mask = groupMask;

else

    mask = groupMask;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = getData(attr, dictionaryEntry, swapAttrBytes)

% Use our own swap16bit and swap32bit code because we know that the data
% is uint8.  Would have to do more work to use typecast and swapbytes.
switch (dictionaryEntry.Datatype)
    case 'char'

        value = char(attr.Data);
        value(value == 0) = [];
        data = value;

    case 'uint8'

        data = attr.Data;

    case 'uint16'

        if (swapAttrBytes)
            attr.Data = swap16Bit(attr.Data);
        end

        data = dicom_typecast(attr.Data, 'uint16');

    case 'uint16cell'

        if (swapAttrBytes)
            attr.Data = swap16Bit(attr.Data);
        end

        if strcmp(attr.VR, 'IS')
            % This attribute is the number of frames in overlay and is an integer string.
            % sscanf is faster than str2num.
            data  = sscanf(char(attr.Data), '%d');
            data = {uint16(data)};
        else
            data = {dicom_typecast(attr.Data, 'uint16')};
        end

    case 'uint32'

        if (swapAttrBytes)
            attr.Data = swap32Bit(attr.Data);
        end

        data = dicom_typecast(attr.Data, 'uint32');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function details = getTxfrSyntaxDetails(UID)
% UID is a unique identifier corresponding to a DICOM transfer syntax.  The
% transfer syntax UID is a code that tells the byte order of the
% attributes and pixels, whether the attributes have implicit or explicit
% VR, and whether the pixel data is compressed (encapsulated).  Most (but
% not all) transfer syntaxes are defined in Table A-1 of PS 3.6.
%
% getTxfrSyntaxDetails gets only the details needed for reading the file.

internalErrorFcn = ...
    @(metadata,offset,prevWarning) error('Images:dicomread:internalError', ...
    'Internal error - no decompressor for this file.');

if (isempty(UID))
    % Try to support fragmentary images as best as we can.
    details.EncodingSupported = true;
    details.DataCompressed = false;
    details.DecompressFcn = internalErrorFcn;
    details.RequiresColorspaceConversion = true;
else
    % Get specific UID details.
    switch (UID)
        case {'1.2.840.10008.1.2'
              '1.2.840.10008.1.2.1'
              '1.2.840.10008.1.2.2'
              '1.2.840.113619.5.2'}

            details.EncodingSupported = true;
            details.DataCompressed = false;
            details.DecompressFcn = internalErrorFcn;
            details.RequiresColorspaceConversion = true;

        case '1.2.840.10008.1.2.5'

            details.EncodingSupported = true;
            details.DataCompressed = true;
            details.DecompressFcn = @decompressRleFrame;
            details.RequiresColorspaceConversion = true;

        case {'1.2.840.10008.1.2.4.50'
              '1.2.840.10008.1.2.4.57'
              '1.2.840.10008.1.2.4.70'
              '1.2.840.10008.1.2.4.90'
              '1.2.840.10008.1.2.4.91'
             }

            details.EncodingSupported = true;
            details.DataCompressed = true;
            details.DecompressFcn = @decompressJpegFrame;
            details.RequiresColorspaceConversion = false;

        otherwise

            details.EncodingSupported = false;
            details.DataCompressed = false;
            details.DecompressFcn = internalErrorFcn;
            details.RequiresColorspaceConversion = false;

    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = processRawPixels(metadata, frames)

% Stop if there isn't any image data stored in the file.
if (isempty(metadata.InstanceData))

    X = [];
    return

end

% Pixel values need to be swapped on big-endian transfer syntaxes.
swapPixelBytes = needToSwapPixelData(metadata.TransferSyntaxUID);

% Convert the raw pixel bytes to the correct data type.
if (metadata.BitsAllocated == 16)

    % Is the data signed?
    if (metadata.PixelRepresentation == 0)
        metadata.InstanceData = dicom_typecast(metadata.InstanceData, ...
            'uint16', swapPixelBytes);
    else
        metadata.InstanceData = dicom_typecast(metadata.InstanceData, ...
            'int16', swapPixelBytes);
    end

elseif (metadata.BitsAllocated == 32)

    % Is the data signed?
    if (metadata.PixelRepresentation == 0)
        metadata.InstanceData = dicom_typecast(metadata.InstanceData, ...
            'uint32', swapPixelBytes);
    else
        metadata.InstanceData = dicom_typecast(metadata.InstanceData, ...
            'int32', swapPixelBytes);
    end

elseif (metadata.BitsAllocated == 8)

    if (metadata.PixelRepresentation == 1)
        metadata.InstanceData = dicom_typecast(metadata.InstanceData, ...
            'int8');
    end

else

    metadata.InstanceData = bitparse(metadata.InstanceData, ...
        metadata.BitsAllocated);

end

% Reshape the data and reorient.
if (~isempty(frames))
    metadata.NumberOfFrames = numel(frames);
end

numPixels = metadata.Columns * metadata.Rows * metadata.SamplesPerPixel ...
    * metadata.NumberOfFrames;

if (numPixels < numel(metadata.InstanceData))

    warning('Images:dicomread:tooMuchData', ...
        'Extra pixel data ignored.');

elseif (numPixels > numel(metadata.InstanceData))

    error('Images:dicomread:notEnoughData', ...
        'Not enough pixel data.');

end

if (metadata.SamplesPerPixel == 1)

    % Single sample and indexed images.
    X = reshape(metadata.InstanceData(1:numPixels), metadata.Columns, ...
        metadata.Rows, 1, metadata.NumberOfFrames);

    X = permute(X, [2 1 3 4]);

else

    % Multi-sample images.
    if (metadata.PlanarConfiguration == 0)

        % Interleaved by pixel.
        X = reshape(metadata.InstanceData(1:numPixels), ...
            metadata.SamplesPerPixel, ...
            metadata.Columns, metadata.Rows, ...
            metadata.NumberOfFrames);
        X = permute(X, [3 2 1 4]);

    else

        % Interleaved by sample band.
        X = reshape(metadata.InstanceData(1:numPixels), ...
            metadata.Columns, metadata.Rows, metadata.SamplesPerPixel, ...
            metadata.NumberOfFrames);
        X = permute(X, [2 1 3 4]);

    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = processEncapsulatedPixels(metadata, frames)

% Stop if there isn't any image data stored in the file.
if (isempty(metadata.InstanceData))

    X = [];
    return

end

% Set the decoder to use.

details = getTxfrSyntaxDetails(metadata.TransferSyntaxUID);
decodeFcn = details.DecompressFcn;

% Decode the encapsulation layer: offset table, delimiters, etc.
%
% See PS-3.5 Sec. A.4, especially tables A.4-1 and A.4-2.
%
% Each compressed fragment/frame in the encapsulated pixel data is
% contained in a (FFFE,E000) Item sub-attribute.  (This makes the
% encapsulated pixel data similar to, but not the same as, a sequence of
% attributes.  It also explains why the data is "encapsulated" since
% various types of compressed pixels are abstracted into a chain of Item
% sub-attributes, which are handled by the appropriate decoder.)
%
% A Basic Offset Table appears at the beginning of encapsulated pixel
% data.  It provides offsets to the N-th frame in the compressed stream
% relative to the end of the Basic Offset Table.  The Basic Offset Table
% may have zero-length, which means no offset data is available; it does
% not mean that there is just one frame.
[offsetTable, offset] = processOffsetTable(metadata);

if (metadata.NumberOfFrames == 1)

    % The third input argument is false since there couldn't be any
    % previous RLE-related warning messages.
    X = decodeFcn(metadata, offset, false);

else

    % Preallocate the output.
    if (isempty(frames))
        nFrames = metadata.NumberOfFrames;
    else
        nFrames = numel(frames);
    end
    
    outputSize = [metadata.Rows, ...
                  metadata.Columns, ...
                  metadata.SamplesPerPixel, ...
                  nFrames];
    X = zeros(outputSize, getOutputClass(metadata));

    % If the Basic Offset Table is missing, search through the data stream
    % for item delimiters (FFFE,E000).  These mark the start of each frame.
    if (isempty(offsetTable))

        % Search for item delimiters in the compressed data stream, which
        % is always little endian regardless of endianness in the file.
        offsetTable = findpattern(metadata.InstanceData((offset+1):end), ...
                                  [254 255 0 224]);
        offsetTable = offsetTable - 1;  % 1-based --> 0-based

    end

    prevWarning = false;
    
    if (isempty(frames))
        frameList = 1:numel(offsetTable);
    else
      
        frameList = frames;
        
        % Rebase the offset table, accounting for frames that were
        % not read.
        offsetTable = rebaseOffsetTable(offsetTable, frames);
        
    end

    outputFrame = 1;
    for p = frameList

        % Decode each frame.  RLE-compressed images might warn if there
        % isn't enough data, but only one message should be issued per
        % file.  That's why we pass in "prevWarning", update it, and pass
        % it back out.
        frameStart = offset + offsetTable(p);
        [X(:,:,:,outputFrame), prevWarning] = decodeFcn(metadata, frameStart, prevWarning);
        outputFrame = outputFrame + 1;
        
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [offsetTable, offsetDelta] = processOffsetTable(metadata)
% The offset table is a specially formatted table that appears at the
% beginning of compressed data.  In the case of multiple frames, the offset
% table helps you find the Nth frame.

% Skip the item delimiter (4 bytes).
offsetDelta = 4;

% Length of the offset table.
swapOffsetBytes = needToSwapOffsetTable;
len = dicom_typecast(metadata.InstanceData((1:4) + offsetDelta), ...
    'uint32', swapOffsetBytes);
offsetDelta = offsetDelta + 4;

% If present the offset table is len/4 UINT32 values.
offsetTable = metadata.InstanceData((1:len) + offsetDelta);

if (~isempty(offsetTable))
    offsetTable = dicom_typecast(offsetTable, 'uint32', ...
        swapOffsetBytes);
end

offsetTable = double(offsetTable);

% Compute the location in the instance data where the offset table ends.
offsetDelta = offsetDelta + double(len);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tf = needToSwapOffsetTable

persistent swapOffset
if ~isempty(swapOffset)
    tf = swapOffset;
else
    % All encapsulated data is stored little-endian.
    swapOffset = isequal(getEndianOfMachine, 'B');
    tf = swapOffset;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, prevWarning] = decompressJpegFrame(metadata, offset, prevWarning)

% Skip the item delimiter, moving to the start of the codestream.
offset = offset + 4;

% Get the length of the encoded data segment.
len = metadata.InstanceData((1:4) + offset);
if needToSwapOffsetTable
    len = swap32Bit(len);
end
len = dicom_typecast(len, 'uint32');

offset = offset + 4;

% Write the encapsulated data to a temporary file.
tempfile = getTempfileName;

fid = fopen(tempfile, 'w');

if (fid < 0)
    error('Images:dicomread:tempfileCreation', ...
        'Couldn''t create temporary file to decode encapsulated data.')
end

fwrite(fid, metadata.InstanceData((1:len) + offset), 'uint8');
fclose(fid);

% Read the data and clean up.
X = imread(tempfile);

% IMREAD always returns unsigned values.  Convert if necessary.
if (metadata.PixelRepresentation == 1)
    X = convertJpegType(X);
end

delete(tempfile)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = convertJpegType(in)

switch (class(in))
    case 'uint8'
        out = reshape(dicom_typecast(in(:), 'int8'), size(in));

    case 'uint16'
        out = reshape(dicom_typecast(in(:), 'int16'), size(in));

    otherwise
        out = in;
        
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, prevWarning] = decompressRleFrame(metadata, startOfFrame, prevWarning)

% Skip the item delimiter, moving to the start of the codestream.
offset = startOfFrame + 4;

% Get the length of the current RLE frame.
swapOffsetBytes = needToSwapOffsetTable;
frameLength = dicom_typecast(metadata.InstanceData((1:4) + offset), ...
    'uint32', swapOffsetBytes);

offset = offset + 4;

% The first 64 bytes comprise the segment offset table, which
% contains the RLE segment locations relative to the beginning of
% the RLE codestream (i.e., the segment's offset).  The first
% number is the number of segments and the remaining 15 numbers are
% the offsets to the segments or 0 for unused entries.  This RLE
% offset table is different than the basic offset table.
segmentOffsets = double(dicom_typecast(metadata.InstanceData((1:64) ...
    + offset),  'uint32', swapOffsetBytes));

% Create an output array for the decompressed data.
decompSegmentSize = metadata.Rows * metadata.Columns;
pixCodes = repmat(uint8(0), [segmentOffsets(1), decompSegmentSize]);

% Decompress each segment into the byte buffer.  The result is a
% set of "composite pixel codes," or the individual bytes comprising
% the pixel data.  This step re-interleaves the bytes from the
% individual RLE-compressed segments to produce the pixel codes.
for p = 1:segmentOffsets(1)

    % Compute the range of data between the start of this segment and
    % the end of the frame.  This is the easiest way to determine
    % what data could be of use to the decoder.
    start = offset + segmentOffsets(p+1) + 1;
    stop = offset + frameLength;

    % Decode this segment of the composite pixel code.
    [pixCodes(p,:), prevWarning] = ...
        dicom_decode_rle_segment(metadata.InstanceData(start:stop), ...
                                 decompSegmentSize, prevWarning);

end

% Convert the "composite pixel codes" into "pixel cells," the same
% representation MATLAB uses for images.
oneFrame = getMinimumMetadataForRLE(metadata);
oneFrame.InstanceData = pixCodes(:);
oneFrame.NumberOfFrames = 1;
oneFrame.PlanarConfiguration = 0;
X = processRawPixels(oneFrame, []);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outputClass = getOutputClass(metadata)

if (metadata.BitsStored <= 8)

    if (metadata.PixelRepresentation == 0)
        outputClass = 'uint8';
    else
        outputClass = 'int8';
    end

else

    if (metadata.PixelRepresentation == 0)
        outputClass = 'uint16';
    else
        outputClass = 'int16';
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tf = needToSwapPixelData(transferSyntaxUID)

endian = getEndianOfMachine;

if (isempty(transferSyntaxUID))

    % Handle the case of fragmentary DICOM files, which we assume to
    % have little-endian pixels.
    tf = isequal(endian, 'B');
    return

end

% Decide whether to swap based on the file's transfer syntax UID.
txfrDetails = dicom_uid_decode(transferSyntaxUID);

if (isempty(txfrDetails.Value))

    error('Images:dicomread:unrecognizedTxfrUID', ...
        'Unrecognized DICOM transfer syntax (''%s'').  Cannot decode.', ...
        transferSyntaxUID)

else

    tf = (isequal(endian, 'B') && ...
        isequal(txfrDetails.PixelEndian, 'ieee-le')) || ...
        (isequal(endian, 'L') && ...
        isequal(txfrDetails.PixelEndian, 'ieee-be'));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = swap16Bit(in)

out = reshape(in, [2, numel(in) / 2]);
out = flipud(out);
out = out(:)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = swap32Bit(in)

out = reshape(in, [4, numel(in) / 4]);
out = flipud(out);
out = out(:)';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function map = getColormap(metadata)

% See PS 3.3-2000 Sec. C.7.6.3.1.5 and C.7.6.3.1.6.

% If there are no descriptors, there is no colormap.
if (isempty(metadata.RedPaletteLUTDescriptor))

    map = [];
    return

end

% Reconstitute the MATLAB-style colormap from the color data and
% descriptor values.
red = double(metadata.RedPaletteLUTData) ./ ...
    (2 ^ double(metadata.RedPaletteLUTDescriptor(3)) - 1);

green = double(metadata.GreenPaletteLUTData) ./ ...
    (2 ^ double(metadata.GreenPaletteLUTDescriptor(3)) - 1);

blue = double(metadata.BluePaletteLUTData) ./ ...
    (2 ^ double(metadata.BluePaletteLUTDescriptor(3)) - 1);

map = [red' green' blue'];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function alpha = getAlpha(X, metadata)

if (isequal(metadata.PhotometricInterpretation, 'ARGB'))

    alpha = X(:,:,1,:);

else

    % No alpha channel.
    alpha = [];

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [overlays, X] = getOverlays(X, metadata)

if ((isempty(metadata.OverlayBitsAllocated)) || ...
        (isempty(metadata.OverlayBitsAllocated{1})))

    overlays = [];
    return

end

if isempty(metadata.NumberOfFramesInOverlay)
    % do not have a multi-frame overlay
    numOverlays = numel(metadata.OverlayRows);

    overlays = false([metadata.OverlayRows{1}, metadata.OverlayColumns{1}, ...
        1, numOverlays]);
    
    % Process each of the overlays.
    attrOverlayCount = 0;
    
    for p = 1:numOverlays
        
        if (metadata.OverlayBitPosition{p} == 0)
            
            % The overlay is located in the next (60xx,3000) attribute.
            % Separate its bits into the overlay, reshape it, and
            % transpose.
            %
            % Because of padding, not all bits may be used.
            attrOverlayCount = attrOverlayCount + 1;
            
            cols = double(metadata.OverlayColumns{p});
            rows = double(metadata.OverlayRows{p});
            
            tmp = tobits(metadata.OverlayData{attrOverlayCount});
            overlays(:,:,1,p) = reshape(tmp(1:(cols * rows)), [cols, rows])';
            
        else
            
            % The overlay is with the rest of the instance data (pixels).
            % Mask out the overlay bits and remove from the instance data.
            overlays(:,:,1,p) = bitget(X(:,:,1,1), ...
                metadata.OverlayBitPosition{p} + 1);
            X = bitset(X(:,:,:,:), metadata.OverlayBitPosition{p} + 1, 0);
            
        end
    end

else
    % cannot process file that has numel(metadata.OverlayRows) > 1 and a
    % multiframeOverlay.
    if numel(metadata.OverlayRows) > 1
        warning('Images:dicomread:multiframeOverlay', ...
            'Multiframe images contains multiple overlays. Just returning first one.');
    end
    [overlays, X] = getMultiframeOverlay(X, metadata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [overlays, X] = getMultiframeOverlay(X, metadata)

numOverlays = metadata.NumberOfFramesInOverlay{1};
overlays = false([metadata.OverlayRows{1}, metadata.OverlayColumns{1}, ...
        1, numOverlays]);

if (metadata.OverlayBitPosition{1} == 0)
    
    % The overlay is located in the next (60xx,3000) attribute.
    % Separate its bits into the overlay, reshape it, and
    % transpose.
    %.
    % Because of padding, not all bits may be used.
    cols = double(metadata.OverlayColumns{1});
    rows = double(metadata.OverlayRows{1});
    
    tmp = tobits(metadata.OverlayData{1});
    overlays = reshape(tmp(1:cols*rows*double(metadata.NumberOfFramesInOverlay{1})), ...
        [cols rows 1 numOverlays]);
    overlays = permute(overlays, [2 1 3 4]);
else
    
    % The overlay is with the rest of the instance data (pixels).
    % Mask out the overlay bits and remove from the instance data.
    overlays(:,:,1,:) = bitget(X(:,:,1,:), ...
        metadata.OverlayBitPosition{1} + 1);
    X = bitset(X(:,:,:,:), metadata.OverlayBitPosition{1} + 1, 0);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tempfile = getTempfileName

nFiles = 1;

persistent tempfiles counter;
if (isempty(tempfiles))

    for p = 1:nFiles
        tempfiles{p} = tempname;
    end

    counter = 0;
end

counter = rem(counter, nFiles) + 1;
tempfile = tempfiles{counter};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = ycbcr2rgbDicom(in, format, bits)
% ycbcr2rgbDicom uses conversion matrices from PS 3.3-2000 Sec
% C.7.6.3.1.2., which is different than IPT's ycbcr2rgb.
%
% 4:2:2 data should have already been upsampled to 4:4:4.

% Rescale data to [0, 255] and convert to double.
switch (class(in))
    case {'uint8'}

        if (rem(bits, 8) == 0)
            tmp = double(in);
        else
            tmp = double(bitshift(in, (8 - bits)));
        end

    case 'uint16'

        if (rem(bits, 8) == 0)
            tmp = double(in)/(2^8 + 1);
        else
            tmp = double(bitshift(in, (16 - bits)));
            tmp = tmp/(2^8 + 1);
        end

    case 'uint32'

        if (rem(bits, 8) == 0)
            tmp = double(in)/(2^24 + 1);
        else
            tmp = double(bitshift(in, (32 - bits)));
            tmp = tmp/(2^24 + 1);
        end

end

switch (format)
    case 'full'

        scale = [0 128 128]';

        RGB = [ 0.2990  0.5870  0.1140;
            -0.1687 -0.3313  0.5000;
            0.5000 -0.4187 -0.0813];

    case 'partial'

        scale = [16 128 128]';

        RGB = [ 0.2568  0.5041  0.0979;
            -0.1482 -0.2910  0.4392;
            0.4392 -0.3678 -0.0714];

end

Ybr = inv(RGB);

% Convert values.
out = zeros(size(tmp));
for p = 1:size(in, 4)

    tmp(:,:,1,p) = tmp(:,:,1,p) - scale(1);
    tmp(:,:,2,p) = tmp(:,:,2,p) - scale(2);
    tmp(:,:,3,p) = tmp(:,:,3,p) - scale(3);

    out(:,:,1,p) = Ybr(1,1) * tmp(:,:,1,p) + Ybr(1,2) * tmp(:,:,2,p) + ...
        Ybr(1,3) * tmp(:,:,3,p);
    out(:,:,2,p) = Ybr(2,1) * tmp(:,:,1,p) + Ybr(2,2) * tmp(:,:,2,p) + ...
        Ybr(2,3) * tmp(:,:,3,p);
    out(:,:,3,p) = Ybr(3,1) * tmp(:,:,1,p) + Ybr(3,2) * tmp(:,:,2,p) + ...
        Ybr(3,3) * tmp(:,:,3,p);

end

% Convert to original type.
switch (class(in))
    case {'uint8'}
        out = uint8(out);
    case 'uint16'
        out = uint16(out * (2^8 + 1));
    case 'uint32'
        out = uint32(out * (2^24 + 1));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function metadataOut = getMinimumMetadataForRLE(metadataIn)

metadataOut = struct('TransferSyntaxUID', metadataIn.TransferSyntaxUID, ...
    'BitsAllocated', metadataIn.BitsAllocated, ...
    'PixelRepresentation', metadataIn.PixelRepresentation, ...
    'Columns', metadataIn.Columns, ...
    'Rows', metadataIn.Rows, ...
    'SamplesPerPixel', metadataIn.SamplesPerPixel, ...
    'NumberOfFrames', metadataIn.NumberOfFrames, ...
    'InstanceData', []);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = findpattern(array, pattern)
%FINDPATTERN  Find a pattern in an array.

% Despite its name, "strfind" is very good at finding numeric patterns in
% numeric vectors.
idx = strfind(array, pattern);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function offsetTable = rebaseOffsetTable(offsetTable, frames)
%REBASEOFFSETTABLE  Change offsets to accomodate missing frames.

frames = sort(frames);

lastBase = 0;
lastFrameLength = 0;
for p = frames
  
    frameLocation = lastBase + lastFrameLength;
    
    if (p ~= numel(offsetTable))
        lastBase = frameLocation;
        lastFrameLength = offsetTable(p+1) - offsetTable(p);
    end
    
    offsetTable(p) = frameLocation;
    
end
