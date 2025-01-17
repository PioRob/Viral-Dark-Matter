function [rxData, BER, yErr] = adapteq_pskdetect(y, x, txData, M);
%ADAPTEQ_PSKDETECT  Detect data from PSK signal.
% Syntax: [rxData, BER, yErr] = pskdetect(y, x, txData, M);
% Inputs/Outputs:
%      y: Received PSK symbols
%      x: Transmitted PSK symbols
% txData: Transmitted data (integers)
%      M: Number of modulation levels
% rxData: Detected data (integers)
%    BER: Bit error rate
%   yErr: errored symbols

%   Copyright 1996-2006 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2006/06/23 19:24:51 $

rxData = demodulate(modem.pskdemod(M), y);
pskSym = modulate(modem.pskmod(M), rxData);
[nSymErrors, SER, symError] = symerr(x, pskSym);
[nBitErrors, BER] = biterr(txData, rxData);
uNaN = nan;
yErr = uNaN(ones(1, length(y)));
n = logical(symError);
yErr(n) = y(n);