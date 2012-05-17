function tagnames = get_public_tagnames(version)
%GET_PUBLIC_TAGNAMES Create table of tag names
%   TAGNAMES = GET_PUBLIC_TAGNAMES(VERSION) returns an (n x 2) 
%   matrix of strings constituting a translation table for 
%   (public) ICC profile tags.  The first column contains all
%   the valid 4-character signatures for the profile tags, while
%   the second column contains the corresponding field names for 
%   MIPS (the in-Matlab ICC Profile Structure).  VERSION is the
%   major-version number of the relevant ICC profile spec.
%
%   See ICCREAD, ICCWRITE, GET_MATTRC_TAGNAMES.

%   Copyright 2003-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2008/04/03 03:10:24 $ Poe
%   Original authors: Scott Gregory, Toshia McCabe, Robert Poe 12/03/03

if nargin < 1
    version = 2;
end

% Build up a list of defined public tags:
tagnames = {   ...
        'A2B0', 'AToB0'; ...
        'A2B1', 'AToB1'; ...
        'A2B2', 'AToB2'; ...
        'B2A0', 'BToA0'; ...
        'B2A1', 'BToA1'; ...
        'B2A2', 'BToA2'; ...
        'bfd ', 'UcrBg'; ...
        'bkpt', 'MediaBlackPoint'; ...
        'calt', 'CalibrationDate'; ...
        'chad', 'ChromaticAdaptation'; ...
        'chrm', 'Chromaticity'; ...
        'cprt', 'Copyright'; ...
        'crdi', 'CRDInfo'; ...
        'desc', 'Description'; ...
        'devs', 'DeviceSettings'; ...
        'dmdd', 'DeviceModelDesc'; ...
        'dmnd', 'DeviceMfgDesc'; ...
        'gamt', 'Gamut'; ...
        'kTRC', 'GrayTRC'; ...
        'lumi', 'Luminance'; ...
        'meas', 'Measurement'; ...
        'ncl2', 'NamedColor2'; ...
        'pre0', 'Preview0'; ...
        'pre1', 'Preview1'; ...
        'pre2', 'Preview2'; ...
        'pseq', 'ProfileSequence'; ...
        'psd0', 'ps2CRD0'; ...
        'psd1', 'ps2CRD1'; ...
        'psd2', 'ps2CRD2'; ...
        'psd3', 'ps2CRD3'; ...
        'ps2s', 'ps2CSA'; ...
        'ps2i', 'ps2Renderingintent'; ...
        'resp', 'OutputResponse'; ...
        'scrd', 'ScreeningDesc'; ...
        'scrn', 'Screening'; ...
        'targ', 'CharTarget'; ...
        'tech', 'Technology'; ...
        'vued', 'ViewingCondDesc'; ...
        'view', 'ViewingConditions'; ...
        'wtpt', 'MediaWhitePoint'};

if version <= 2
    tagnames = [tagnames; {'ncol', 'NamedColor'}];
else
    tagnames = [tagnames; {'clro', 'ColorantOrder'; ...
                           'clrt', 'ColorantTable'; ...
                           'clot', 'ColorantTableOut'}];
end
