function [cnt,pct] = getTotalUnderflows(ntx)
% Add up the bins that are under the fraction threshold setting, returning
% a percentage from 0 to 100.
%
% This indicates the number of data values that will not be representable
% in the word size, if this number of integer bits is chosen.
% This implies these values will underflow the data type and become zero.

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2.2.1 $     $Date: 2010/07/06 14:39:09 $

bcnt = getUnderflowCounts(ntx);
cs = cumsum(bcnt);
% The underflow cursor goes to the right of ntx.LastUnder 
cnt = cs(find(ntx.LastUnder-1 > ntx.BinEdges,1,'last'));
if isempty(cnt)
    cnt = 0;
end
if ntx.DataCount == 0
    pct = 0;
else
    pct = 100*cnt/ntx.DataCount;
end
