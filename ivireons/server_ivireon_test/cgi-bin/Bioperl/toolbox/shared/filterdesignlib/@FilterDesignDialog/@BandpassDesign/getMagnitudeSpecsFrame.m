function mspecs = getMagnitudeSpecsFrame(this)
%GETMAGNITUDESPECSFRAME   Get the magnitudeSpecsFrame.

%   Author(s): J. Schickler
%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2009/04/21 04:21:37 $

spacer.Name    = ' ';
spacer.Type    = 'text';
spacer.RowSpan = [1 1];
spacer.ColSpan = [1 1];
spacer.Tag     = 'Spacer';

items = getConstraintsWidgets(this, 'Magnitude', 1);

if ~strcmpi(this.MagnitudeConstraints, 'unconstrained')

    items = getMagnitudeUnitsWidgets(this, 2, items);

    switch lower(this.MagnitudeConstraints)
        case 'passband ripple'
            items = addConstraint(this, 3, 1, items, true, ...
                'Apass', FilterDesignDialog.message('Apass'), 'Passband ripple');
        case 'stopband attenuation'
            items = addConstraint(this, 3, 1, items, true, ...
                'Astop1', FilterDesignDialog.message('Astop'), 'Stopband attenuation');
        case 'passband ripple and stopband attenuations'
            [items col] = addConstraint(this, 3, 1,   items, true, ...
                'Astop1', FilterDesignDialog.message('Astop1'), 'First stopband attenuation');
            items       = addConstraint(this, 3, col, items, true, ...
                'Apass', FilterDesignDialog.message('Apass'), 'Passband ripple');
            items       = addConstraint(this, 4, 1,   items, true, ...
                'Astop2', FilterDesignDialog.message('Astop2'), 'Second stopband attenuation');
    end
    
else

    % If there is nothing added, add a spacer to reduce flicker.
    spacer.RowSpan = [2 2];
    spacer.Tag     = 'Spacer2';

    items = {items{:}, spacer}; %#ok<CCAT>

    spacer.RowSpan = [3 3];

    items = {items{:}, spacer}; %#ok<CCAT>
end

mspecs.Name       = FilterDesignDialog.message('magspecs');
mspecs.Type       = 'group';
mspecs.Items      = items;
mspecs.LayoutGrid = [5 4];
mspecs.RowStretch = [0 0 0 0 1];
mspecs.ColStretch = [0 1 0 1];
mspecs.Tag        = 'MagSpecsGroup';

% [EOF]