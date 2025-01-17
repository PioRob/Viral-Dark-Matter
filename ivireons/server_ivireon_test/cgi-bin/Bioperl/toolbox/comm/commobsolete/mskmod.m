function [y, varargout] = mskmod(x, nSamp, varargin)
% MSKMOD Minimum shift keying modulation.
%
%
%WARNING: This is an obsolete function and may be removed in the future.
%         Please use MODEM.MSKMOD object instead.
%
%
%   Y = MSKMOD(X,NSAMP) outputs the complex envelope of the modulation of the
%   message signal X using minimum shift keying modulation.  The elements of X
%   must be 0 or 1.  NSAMP denotes the number of samples per symbol and must be
%   a positive integer.  For two dimensional signals, the function treats each
%   column as one channel.
%
%   Y = MSKMOD(X,NSAMP,DATAENC) specifies the data encoding method for MSK.
%   DATAENC can be either 'diff', specifying differentially encoded MSK, or
%   'nondiff', specifying nondifferentially encoded MSK.  The default is
%   'diff'.  The 'diff' and 'nondiff' methods are equivalent to conventional and
%   precoded MSK, respectively. 
%
%   Y = MSKMOD(X,NSAMP,DATAENC,INI_PHASE) specifies the initial phase of the MSK
%   modulator.  INI_PHASE is a row vector whose length is equal to the number of
%   channels in X, and has default values of 0.  Values in INI_PHASE must be
%   integer multiples of pi/2.  To avoid overriding the default value of
%   DATAENC, set DATAENC=[].
%
%   [Y,PHASEOUT] = MSKMOD(...) returns the final phase of Y for use in
%   modulating a future bit stream with differentially encoded MSK.
%
%   See also MSKDEMOD, FSKMOD, FSKDEMOD, MODEM.MSKMOD, MODEM, MODEM/TYPES.

%   Reference:  
%   [1] S. Pasupathy, "MSK: A Spectrally Efficient Modulation", IEEE
%   Communications Magazine, July 1979.
%   [2] M.K. Simon, S.M. Hinedi, and H.C. Lindsey, Digital Communication
%   Techniques - Signal Design and Detection, New Jersey: Prentice Hall, 1995

%   Copyright 1996-2007 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2007/06/08 15:53:56 $ 
   

% Error checks -----------------------------------------------------------------

% Check number of input arguments
error(nargchk(2, 4, nargin, 'struct'));

% Check X
if (~isnumeric(x) || ~isreal(x) || any(any(ceil(x) ~= x)) || ...
    (min(min(x)) < 0) || (max(max(x)) > 1))
    error('comm:mskmod:xreal', 'Elements of X must be 0 or 1.');
end

% Check that NSAMP is a positive integer
if(~isnumeric(nSamp) || (ceil(nSamp) ~= nSamp) || (nSamp <= 0))
    error('comm:mskmod:nSampPos', 'NSAMP must be a positive integer.');
end

% Check DATAENC
if nargin >= 3
    dataEnc = varargin{1};
    if isempty(dataEnc)
        dataEnc = 'diff';
    else
        valDataEnc = {'diff' 'nondiff'};
        if ~ismember(dataEnc, valDataEnc)
            error('comm:mskmod:invDataEnc', ...
                  'DATAENC must be either ''diff'' or ''nondiff''.');
        end
    end
else
    dataEnc = 'diff';
end

% Assure that X, if one dimensional, has the correct orientation.
nRowsInit = size(x,1);
if nRowsInit == 1
    x = x(:);
end

% If the signal is nondifferentially encoded and has an odd number of bits, add
% a trailing zero and issue a warning.
sigLen = size(x, 1);    % input signal length in symbols
nChan  = size(x, 2);     % # of channels
if strcmpi(dataEnc,'nondiff') && round(sigLen/2) ~= sigLen/2
    warning('comm:mskmod:oddNumBits', ...
        ['The signal has an odd number of bits.  Appending a zero ' ...
        'in order to create I and Q channels of equal length.']);
    x = [x; zeros(1, nChan)];
    sigLen = sigLen + 1;
end

% Check INI_PHASE.
if nargin == 4
    ini_phase = abs(mod(varargin{2}, 2*pi));
    if (isempty(ini_phase))
        ini_phase = zeros(1, nChan);
    else
        valIniPhase = [0 pi/2 pi 3*pi/2];
        if (~isnumeric(ini_phase) || ~isvector(ini_phase) || ...
            ~isreal(ini_phase) || size(ini_phase,2)~=nChan)
            error('comm:mskmod:invIniPhase', ...
            ['INI_PHASE must be a real row vector with values equal to ', ...
             'integer multiples of pi/2 for each channel.']);
        end
        tol = 1e-4;
        for iChan = 1 : nChan
            if (all(abs(ini_phase(iChan) - valIniPhase) > tol))
                error('comm:mskmod:invIniPhase', ...
                ['INI_PHASE must be a real row vector with values equal ', ...
                 'to integer multiples of pi/2 for each channel.']);
            end
        end
    end
else
    ini_phase = zeros(1, nChan);
end
ini_phase = repmat(ini_phase, sigLen*nSamp, 1);

% End of error checking ------------------------------------------------------

if strcmpi(dataEnc, 'diff')  % Differentially encoded

    % Generate the phase trajectory.  Use the fact that the phase is piecewise
    % continuous, and changes linearly during each symbol.  Also, the phase at
    % the beginning of each symbol is a multiple of pi/2.  Input ones cause
    % phase to increase, and input zeros cause phase to decrease.

    xCum = cumsum([zeros(1,nChan); 2*x-1]); % prepend the state to start from
                                            % 0 phase, and use signed data

    % Interpolate linearly from symbols to samples.  The phase is n*pi/2 (for
    % integer n) at samples 1, nSamp+1, 2*nSamp+1, etc.
    coarseTime = (0 : sigLen)';
    fineTime = (0 : 1/nSamp : sigLen-1/nSamp)';
    phaseVec = pi/2 * interp1(coarseTime, xCum, fineTime);

    % Add initial phase
    phaseVec = phaseVec + ini_phase;
    
    % Modulate
    y = exp(j*phaseVec);

else        % Nondifferentially encoded
    
    % Commutate the single bit stream into I and Q channels, then create pulse
    % trains oversampled at 2*nSamp, reflecting the fact that each of the I and Q
    % channels transmit at half the total data rate.  Stagger the I channel by
    % half a symbol relative to the Q channel.
    xI = circshift(rectpulse(2*x(1:2:end-1, :)-1, 2*nSamp), -nSamp);
    xQ = rectpulse(2*x(2:2:end, :)-1, 2*nSamp);
    
    % Pulse shape by cos((pi*t/2T)+pi/2) and sin(pi*t/2T), and form complex
    % output.  Shift the cosine wave by pi to account for the circular shift of
    % the I rail.  The cosine and sine functions traverse one cycle each 4*nSamp
    % samples.
    arg   = pi * repmat((0 : size(xI,1)-1)', 1, nChan) / (2*nSamp);
    y     = complex(xI.*cos(arg+pi), xQ.*sin(arg)) .* exp(j*ini_phase);
    
    phaseVec = ini_phase;
end

% Restore the output signal to the original orientation
if nRowsInit == 1
    y = y.';
end

% Return PHASEOUT if specified.  The value should be 0, pi/2, pi, or 3pi/2 for
% each channel.  If, through numerical errors, the phase is slightly different
% from the desired values, fix them to those desired values.
if nargout == 2
    phaseOut = zeros(1, nChan);
    % Final phase between [0, 2*pi)
    endPhase = mod(phaseVec(end,:), 2*pi);
    
    % Search space for the phase
    valEndPhase = [0 pi/2 pi 3*pi/2 2*pi]';
    
    for iChan = 1 : nChan
        % Find minimum distance
        [dummy minIdx] = min(abs(valEndPhase - endPhase(iChan))); %#ok

        % Convert to [0, 2*pi)
        phaseOut(iChan) = mod(valEndPhase(minIdx), 2*pi);
    end
    varargout{1} = phaseOut;
end

% EOF -- mskmod.m