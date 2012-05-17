function this = BandpassDesign(varargin)
%BANDPASSDESIGN   Construct a BANDPASSDESIGN object.

%   Author(s): J. Schickler
%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2009/10/16 06:38:26 $

this = FilterDesignDialog.BandpassDesign;

set(this, 'VariableName', uiservices.getVariableName('Hbp'), varargin{:});

% Prepare dialog depending on license config and operating mode
setupDisabledOrEnabled(this);

set(this, 'FDesign', fdesign.bandpass);
set(this, 'DesignMethod', 'Equiripple');

% Cache the default states in "LastApplied".
set(this, ...
    'LastAppliedState',      getState(this), ...
    'LastAppliedSpecs',      getSpecs(this), ...
    'LastAppliedDesignOpts', getDesignOptions(this));

% [EOF]