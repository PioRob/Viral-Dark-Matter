function dialogTitle = getDialogTitle(this)
%GETDIALOGTITLE Get the dialogTitle.

%   Author(s): J. Schickler
%   Copyright 2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2009/04/21 04:23:04 $

if strcmpi(this.OperatingMode, 'Simulink')
    dialogTitle = FilterDesignDialog.message('OctaveFilter');
else
    dialogTitle = FilterDesignDialog.message('OctaveDesign');
end

% [EOF]