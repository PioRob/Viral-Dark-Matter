function b = setGUI(this, Hd)
%SETGUI   Set the GUI when calling filterbuider(Hd)

%   Copyright 2006-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2010/05/20 03:03:26 $

b = true;
hfdesign = getfdesign(Hd);
if ~strcmpi(get(hfdesign, 'Response'), 'parametric equalizer')
    b = false;
    return;
end

switch hfdesign.Specification
    case 'F0,BW,BWp,Gref,G0,GBW,Gp'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth, passband width', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'BWpass', num2str(hfdesign.BWpass), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...
            'Gpass',  num2str(hfdesign.Gpass));
    case 'F0,BW,BWst,Gref,G0,GBW,Gst'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth, stopband width', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, stopband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'BWstop', num2str(hfdesign.BWstop), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...            
            'Gstop',  num2str(hfdesign.Gstop));
    case 'F0,BW,BWp,Gref,G0,GBW,Gp,Gst'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth, passband width', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband, stopband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'BWpass', num2str(hfdesign.BWpass), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...
            'Gpass',  num2str(hfdesign.Gpass), ...
            'Gstop',  num2str(hfdesign.Gstop));
    case 'N,F0,BW,Gref,G0,GBW'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW));      
    case 'N,F0,BW,Gref,G0,GBW,Gp'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...            
            'Gpass',  num2str(hfdesign.Gpass));
    case 'N,F0,BW,Gref,G0,GBW,Gst'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, stopband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...            
            'Gstop',  num2str(hfdesign.Gstop));
    case 'N,F0,BW,Gref,G0,GBW,Gp,Gst'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, bandwidth', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband, stopband', ...
            'F0',     num2str(hfdesign.F0), ...
            'BW',     num2str(hfdesign.BW), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0), ...
            'GBW',    num2str(hfdesign.GBW), ...            
            'Gpass',  num2str(hfdesign.Gpass), ...
            'Gstop',  num2str(hfdesign.Gstop));
    case 'N,F0,Qa,Gref,G0'
        set(this, ...
            'FrequencyConstraints', 'Center frequency, quality factor', ...
            'MagnitudeConstraints', 'Reference, center frequency', ...
            'F0',     num2str(hfdesign.F0), ...
            'Qa',     num2str(hfdesign.Qa), ...
            'Gref',   num2str(hfdesign.Gref), ...
            'G0',     num2str(hfdesign.G0));
    case 'N,F0,Fc,Qa,G0'
        if isequal(hfdesign.F0,0)
            st = 'Lowpass';
        else
            st = 'Highpass';
        end
        set(this, ...
            'FrequencyConstraints', 'Shelf type, cutoff frequency, quality factor', ...
            'MagnitudeConstraints', 'Boost/cut', ...
            'ShelfType', st, ...
            'Fc',        num2str(hfdesign.Fc),...
            'Qa',        num2str(hfdesign.Qa), ...
            'Gbc',       num2str(hfdesign.G0));
    case 'N,F0,Fc,S,G0'
        if isequal(hfdesign.F0,0)
            st = 'Lowpass';
        else
            st = 'Highpass';
        end        
        set(this, ...
            'FrequencyConstraints', 'Shelf type, cutoff frequency, shelf slope parameter', ...
            'MagnitudeConstraints', 'Boost/cut', ...
            'ShelfType', st, ...
            'Fc',        num2str(hfdesign.Fc),...
            'S',         num2str(hfdesign.S), ...
            'Gbc',       num2str(hfdesign.G0));
    case 'N,Flow,Fhigh,Gref,G0,GBW'
        set(this, ...
            'FrequencyConstraints', 'Low frequency, high frequency', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth', ...
            'Flow',   num2str(hfdesign.Flow), ...
            'Fhigh',  num2str(hfdesign.Fhigh));
    case 'N,Flow,Fhigh,Gref,G0,GBW,Gp'
        set(this, ...
            'FrequencyConstraints', 'Low frequency, high frequency', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband', ...
            'Flow',   num2str(hfdesign.Flow), ...
            'Fhigh',  num2str(hfdesign.Fhigh), ...
            'Gpass',  num2str(hfdesign.Gpass));
    case 'N,Flow,Fhigh,Gref,G0,GBW,Gst'
        set(this, ...
            'FrequencyConstraints', 'Low frequency, high frequency', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, stopband', ...
            'Flow',   num2str(hfdesign.Flow), ...
            'Fhigh',  num2str(hfdesign.Fhigh), ...
            'Gstop',  num2str(hfdesign.Gstop));
    case 'N,Flow,Fhigh,Gref,G0,GBW,Gp,Gst'
        set(this, ...
            'FrequencyConstraints', 'Low frequency, high frequency', ...
            'MagnitudeConstraints', 'Reference, center frequency, bandwidth, passband, stopband', ...
            'Flow',   num2str(hfdesign.Flow), ...
            'Fhigh',  num2str(hfdesign.Fhigh), ...
            'Gpass',  num2str(hfdesign.Gpass), ...
            'Gstop',  num2str(hfdesign.Gstop));
    otherwise
        error(generatemsgid('IncompleteConstraints'), ...
            'Internal Error: Lowpass ''%s'' incomplete', hfdesign.Specification);
end

abstract_setGUI(this, Hd);

% [EOF]