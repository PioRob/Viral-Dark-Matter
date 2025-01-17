function fspecs = getFrequencySpecsFrame(this)
%GETFREQUENCYSPECSFRAME   Get the frequencySpecsFrame.

%   Author(s): J. Schickler
%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2009/04/21 04:21:33 $

% Add the constraints popup.
items = getConstraintsWidgets(this, 'Frequency', 1);

items = getFrequencyUnitsWidgets(this, 2, items);

switch lower(this.FrequencyConstraints)
    case 'passband edges'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'Fpass1', FilterDesignDialog.message('Fpass1'), 'First passband edge');
        items       = addConstraint(this, 3, col, items, true, ...
            'Fpass2', FilterDesignDialog.message('Fpass2'), 'Second passband edge');
    case 'stopband edges'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'Fstop1', FilterDesignDialog.message('Fstop1'), 'First stopband edge');
        items       = addConstraint(this, 3, col, items, true, ...
            'Fstop2', FilterDesignDialog.message('Fstop2'), 'Second stopband edge');
    case 'passband and stopband edges'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'Fstop1', FilterDesignDialog.message('Fstop1'), 'First stopband edge');
        items       = addConstraint(this, 3, col,   items, true, ...
            'Fpass1', FilterDesignDialog.message('Fpass1'), 'First passband edge');
        [items col] = addConstraint(this, 4, 1, items, true, ...
            'Fpass2', FilterDesignDialog.message('Fpass2'), 'Second passband edge');
        items       = addConstraint(this, 4, col, items, true, ...
            'Fstop2', FilterDesignDialog.message('Fstop2'), 'Second stopband edge');
    case '3db points'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'F3dB1', FilterDesignDialog.message('freq3dB1'), 'First 3dB point');
        items       = addConstraint(this, 3, col, items, true, ...
            'F3dB2', FilterDesignDialog.message('freq3dB2'), 'Second 3dB point');
    case '6db points'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'F6dB1', FilterDesignDialog.message('freq6dB1'), 'First 6dB point');
        items       = addConstraint(this, 3, col, items, true, ...
            'F6dB2', FilterDesignDialog.message('freq6dB2'), 'Second 6dB point');
    case '3db points and stopband width'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'F3dB1', FilterDesignDialog.message('freq3dB1'), 'First 3dB point');
        items       = addConstraint(this, 3, col, items, true, ...
            'F3dB2', FilterDesignDialog.message('freq3dB2'), 'Second 3dB point');
        items       = addConstraint(this, 4, 1,   items, true, ...
            'BWstop', FilterDesignDialog.message('BWstop'));
    case '3db points and passband width'
        [items col] = addConstraint(this, 3, 1,   items, true, ...
            'F3dB1', FilterDesignDialog.message('freq3dB1'), 'First 3dB point');
        items       = addConstraint(this, 3, col, items, true, ...
            'F3dB2', FilterDesignDialog.message('freq3dB2'), 'Second 3dB point');
        items       = addConstraint(this, 4, 1,   items, true, ...
            'BWpass', FilterDesignDialog.message('BWpass'));
end

fspecs.Name       = FilterDesignDialog.message('freqspecs');
fspecs.Type       = 'group';
fspecs.Items      = items;
fspecs.LayoutGrid = [5 4];
fspecs.RowStretch = [0 0 0 0 1];
fspecs.ColStretch = [0 1 0 1];
fspecs.Tag        = 'FreqSpecsGroup';

% [EOF]
