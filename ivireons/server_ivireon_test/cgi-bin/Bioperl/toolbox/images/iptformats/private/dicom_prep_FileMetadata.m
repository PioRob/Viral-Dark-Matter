function metadata = dicom_prep_FileMetadata(metadata, IOD_UID, txfr)
%DICOM_PREP_FILEMETADATA  Fill necessary file metadata information.
%
%   See PS 3.10 Sec. 7.1

%   Copyright 1993-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/03/22 03:49:29 $

metadata.(dicom_name_lookup('0002', '0001')) = uint8([0 1]);
metadata.(dicom_name_lookup('0002', '0002')) = IOD_UID;
metadata.(dicom_name_lookup('0002', '0003')) = ...
    metadata.(dicom_name_lookup('0008', '0018'));
metadata.(dicom_name_lookup('0002', '0010')) = txfr;

[uid, name] = get_implementation_details;
metadata.(dicom_name_lookup('0002', '0012')) = uid;
metadata.(dicom_name_lookup('0002', '0013')) = name;



function [implementation_UID, implementation_name] = get_implementation_details
%GET_IMPLEMENTATION_DETAILS   Create implementation class UID and name.

% The Implementation Class UID (0002,0012) is a UID that we create which
% identifies the modality (i.e., the Image Processing Toolbox) writing
% the file.  The Implementation Version Name (0002,0013 is a description
% of the modality (16 characters max).  These values must be updated
% together.

% Class UIDs generated by the Image Processing Toolbox have the following
% structure:
%
%    IPT_UID_ROOT.3.x.y
%
% Where 3 is the (new) constant value for class UIDs, x is the constant class,
% and y is the individual instance of the class.

ipt_root = dicom_generate_uid('ipt_root');
ipt_uid_definitions = '3';
imp_class_constant = '100';

% This is quite slow and does not compile.  Hard-code the value until its
% performance improves.

% ipt_ver = ver('images');
% 
% if (isempty(ipt_ver))
%     error('Images:dicom_prep_FileMetadata:unknownIPT', 'Unrecognized Image Processing Toolbox version.')
% end
% 
% idx = find(ipt_ver(1).Version > '9');
% if (~isempty(idx))
%     ipt_ver(1).Version(idx(1):end) = '';
% end
ipt_ver(1).Version = '7.1';

implementation_UID = [ipt_root, '.', ...
                      ipt_uid_definitions, '.', ...
                      imp_class_constant, '.', ...
                      ipt_ver(1).Version];

implementation_name = ['MATLAB IPT ' ipt_ver(1).Version];
         
