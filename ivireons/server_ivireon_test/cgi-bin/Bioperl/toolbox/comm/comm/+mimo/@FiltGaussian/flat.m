function flat(h, i)
%FLAT  Use flat Doppler filter impulse response.
%
%   Inputs:
%     h - mimo.FiltGaussian object

%   Copyright 2008 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2008/10/31 05:54:54 $

% Use smallest sample period across all Doppler spectra
Ts = min(h.OutputSamplePeriod);
fc = h.CutoffFrequency(i);
fcmin = min(h.CutoffFrequency);

% Time domain for filter response
tmax = 50/(2*pi*fcmin); % Use largest time domain across all Doppler spectra
t = -tmax:Ts:tmax;

% Set filter time domain and impulse response.
h.ImpulseResponse(i,:) = flatir(fc, t);
h.TimeDomain(i,:) = t;
