function initHistDisplay(ntx)
% Initialize display after UI creation
% This updates axis size, title, xticks, datatype readout, etc

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $     $Date: 2010/03/31 18:21:25 $

adjustHistAxisSize(ntx); % Do first: affects overall axis
updateXTickLabels(ntx,1);
updateDTXTextAndLinesYPos(ntx);
updateYAxisTitle(ntx);
updateNumericTypesAndSigns(ntx);

% If BAStrategy is other then IL+FL (which is the one mode that
% carries out the automation immediately as the changes are
% made), we must perform threshold updates explicitly now.
dlg = ntx.hBitAllocationDialog;
%if dlg.BAStrategy ~= 3; % IL+FL
if dlg.BAWLMethod ~= 1  % Auto: IL+FL
    performAutoBA(ntx);
else
    updateThresholds(ntx);
end
