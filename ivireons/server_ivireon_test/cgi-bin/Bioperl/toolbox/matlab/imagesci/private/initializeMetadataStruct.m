function metadata = initializeMetadataStruct(format, varargin)
%INITIALIZEMETADATASTRUCT Create and initialize the metadata struct,
%fixing common IMFINFO fields.
%
% METADATA = INITIALIZEMETADATASTRUCT(FORMAT) returns a structure with the
% common IMFINFO fields initialized to empty and Format field set to
% FORMAT. 
%
% METADATA = INITIALIZEMETADATASTRUCT(FORMAT, FID) returns a structure with
% the Filename, FileModDate and FileSize fields set to information obtained from FID.

%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2007/03/27 19:14:59 $

% Initialize universal structure fields to fix the order
metadata.Filename = '';
metadata.FileModDate = [];
metadata.FileSize = [];
metadata.Format = format;
metadata.FormatVersion = [];
metadata.Width = [];
metadata.Height = [];
metadata.BitDepth = [];
metadata.ColorType = [];

if (nargin == 2)
    
    fid = varargin{1};
    filename = fopen(fid);  % Get the full path name if not in pwd
    d = dir(filename);      % Read directory information

    metadata.Filename = filename;
    metadata.FileModDate = d.date;
    metadata.FileSize = d.bytes;
    
end
