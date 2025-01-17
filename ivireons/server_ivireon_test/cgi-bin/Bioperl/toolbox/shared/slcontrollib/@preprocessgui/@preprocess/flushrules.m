function flushrules(h)
% FLUSHRULES

% Author(s): James G. Owen
% Revised:
% Copyright 1986-2008 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2008/01/29 15:37:10 $

if ~isempty(h.Exclusion)
    h.Exclusion.disableListeners
    set(h.Exclusion,'Boundsactive', 'off', 'Outliersactive', 'off',...
    'Flatlineactive', 'off', 'Expressionactive' , 'off', 'Xlow', -inf, ...
    'Xlowstrict', 'off', 'Xhigh', inf, 'Xhighstrict', 'off','Ylow', -inf, ...
    'Ylowstrict', 'off', 'Yhigh' ,inf, 'Yhighstrict', 'off', 'Outlierwindow',...
    10, 'Outlierconf', 95, 'Flatlinelength', 5);
    h.Exclusion.enableListeners
end
if ~isempty(h.Filtering)
    h.Filtering.disableListeners
    set(h.Filtering,'Detrendactive', 'off', 'Filteractive', 'off', ...
	'Detrendtype', 'constant', 'Filter', 'firstord', 'Band', 'pass', ...
	'Range', [0 0.1], 'Acoeffs', [1 10], 'Bcoeffs', 1, 'Timeconst', 10);
    h.Filtering.enableListeners
end
if ~isempty(h.Interp)
    h.Interp.disableListeners
    set(h.Interp, 'Rowremove', 'off', 'Rowor', 'off', 'Interpolate', ...
		  'off', 'method', 'zoh');
    h.Interp.enableListeners
end
