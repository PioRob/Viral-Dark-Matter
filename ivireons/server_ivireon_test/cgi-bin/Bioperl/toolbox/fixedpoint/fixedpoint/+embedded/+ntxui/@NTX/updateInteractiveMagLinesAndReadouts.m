function updateInteractiveMagLinesAndReadouts(ntx,newOverExp,newUnderExp)
% Update magnitude text readout and lines for interactive changes
% to overflow and/or underflow lines.
%
% newOverExp is the quantized exponent, N (and not the value 2^N)
% indicating the largest magnitude that must be represented without
% overflow.
%
% newUnderExp is the quantized exponent, N (and not the value 2^N)
% indicating the largest magnitude that must be represented without
% underflow.
%
% Ex: if overflow cursor is at 2^3, bar range is [4,8),
%       text readout shows 8-eps.
%     if underflow cursor is at 2^-2, bar range is [.5, .25),
%       text readout shows 1/4-eps

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.1.2.1 $     $Date: 2010/07/06 14:39:21 $

% Update thresholds
%
% Must set before updating word length / data type text
% It is assumed that newOverExp/newUnderExp are exponents (not 2^N value),
% are quantized
ntx.LastOver = newOverExp;
ntx.LastUnder = newUnderExp;

setInteractiveMagnitudes(ntx.hBitAllocationDialog,newOverExp,newUnderExp,...
    ntx.wasExtraMSBBitsAdded, ntx.wasExtraLSBBitsAdded);

% Update x-coords of cursor lines
% Include offset to put line between histogram bars. The fraction length
% cursor goes to the right of the bin. 
set(ntx.hlUnder,'xdata',[0 0]+newUnderExp-1+ntx.BarGapCenter);
set(ntx.hlOver,'xdata',[0 0]+newOverExp+ntx.BarGapCenter);
set(ntx.hlWordSpan,'xdata',[newUnderExp-1,newOverExp]+ntx.BarGapCenter);
