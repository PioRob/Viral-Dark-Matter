function [handles,names,varargout] = bfitopen(figHandle, cmd)
% BFITOPEN Open, or re-open, Data Statistics or Basic Fitting GUI.
%   [HANDLES,NAMES,XSTATS,YSTATS,XCHECK,YCHECK] = BFITOPEN(FIGHANDLE,'ds') 
%   sets up the appdata and figure window for the Data Stat
%   GUI. HANDLES and NAMES are from BFITGETDATA; XSTATS, YSTATS is
%   from BFITCOMPUTEDATASTATS; XCHECK and YCHECK are 6 element row
%   vectors (logical 0 and 1's) that designate if the checkbox is
%   checked in the GUI or not.
%
%   [HANDLES,NAMES,AXESOPEN,FITSCHECKED,BFINFO,] = BFITOPEN(FIGHANDLE,'bf') sets up
%   the appdata and figure window for the Basic Fitting GUI. HANDLES and NAMES are from
%   BFITGETDATA; ??? are the other arguments for filling out the GUI.


%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.15.4.6 $  $Date: 2009/01/29 17:16:44 $

% data counter, for naming, for both bfit and data stats
datacounter = getappdata(figHandle,'Basic_Fit_Data_Counter');
if isempty(datacounter) % not yet set
    datacounter = 1; % start counting at 1
    setappdata(figHandle,'Basic_Fit_Data_Counter',datacounter);
end

% turn the figure double-buffering mode on to prevent flashing
doublebuffer = getappdata(figHandle,'bfit_doublebuffer');
if isempty(doublebuffer) % not yet set/saved
    doublebufferstate = get(figHandle,'doublebuffer');
    setappdata(figHandle,'bfit_doublebuffer',doublebufferstate);
    if ~isequal(doublebufferstate,'on')
        set(figHandle,'doublebuffer','on');
    end
end

% For any legend that exists, use the legend strings to set
%  the names to be used by the GUI for existing lines
bfitsetdatanames(figHandle);

bfitlisten(figHandle);

%turn off displayname listener

axesList = datachildren(figHandle);
lineL = plotchild(axesList, 2, true);

for i = lineL'
    if ~isempty(bfitFindProp(i, 'bfit_CurveDisplayNameListeners'))
	listeners = get(handle(i), 'bfit_CurveDisplayNameListeners');
        bfitSetListenerEnabled(listeners.displaynamechanged, false);
    end
end

switch cmd
case 'bf'
    currdata = getappdata(figHandle,'Basic_Fit_Current_Data');
    if isempty(currdata) % Gui never open for this figure
        [handles, names] = bfitgetdata(figHandle, 2);
        if ~isempty(handles)
            currdata = handles{1};
            setappdata(figHandle,'Basic_Fit_Data_All',[handles{:}]);
        else
            currdata = [];
        end
        [axesCount,fitschecked,bfinfo,ignore,currentfit] = bfitsetup(figHandle, currdata);

		% Override bfinfo(9) from MATLAB prefs to determine initial # of panels. 
		bfinfo(9) = com.mathworks.services.Prefs.getIntegerPref('BasicFitting.NumPanels', 1);
		evalresultsstr = ' ';
        evalresultsx = ' ';
        evalresultsy = ' ';
        coeffresidstrings = ' ';
    else % reopen gui
        [handles, names] = bfitgetdata(figHandle, 2);
        % put currdata at the top of handles/names
        currind = find(currdata == [handles{:}]);
        ind = [currind, 1:currind-1, currind+1:length(handles)];
        handles = handles(ind);
        names = names(ind);
        
        % Get other info
        [axesCount,fitschecked,bfinfo,evalresultsstr,evalresultsx,evalresultsy,currentfit,coeffresidstrings] = ...
            bfitgetcurrentinfo(currdata);
    end
    % temporary
    if isempty(currentfit)
        currentfit = -1;
    end
    
    varargout = {axesCount,fitschecked,bfinfo, ...
            evalresultsstr,evalresultsx,evalresultsy,currentfit, ...
            coeffresidstrings};
case 'ds'
    currdata = getappdata(figHandle,'Data_Stats_Current_Data');
    if isempty(currdata) % Gui never open for this figure
        [handles, names] = bfitgetdata(figHandle, 2);
        if ~isempty(handles)
            currdata = handles{1};
            [x_str, y_str, xcolname, ycolname] = bfitdatastatsetup(figHandle, currdata); % data stats computed
        else
            x_str = ' ';
            y_str = ' ';
        end
        xstats = false(1,6);
        ystats = false(1,6);
    else % reopen gui
        [handles, names] = bfitgetdata(figHandle, 2);
        % put currdata at the top of handles/names
        currind = find(currdata == [handles{:}]);
        ind = [currind, 1:currind-1, currind+1:length(handles)];
        handles = handles(ind);
        names = names(ind);
        
        % gather stat info
        x = struct2cell(getappdata(double(currdata),'Data_Stats_X'));
        y = struct2cell(getappdata(double(currdata),'Data_Stats_Y'));
        xstats = cat(1,x{:}); ystats = cat(1,y{:});
        format = '%-12.4g';
        x_str = cellstr(num2str(xstats,format));
        y_str = cellstr(num2str(ystats,format));
        xstats = getappdata(double(currdata),'Data_Stats_X_Showing');
        ystats = getappdata(double(currdata),'Data_Stats_Y_Showing');
        [xcolname, ycolname] = bfitdatastatsgetcolnames(currdata);
    end
    varargout = {x_str,y_str,xstats,ystats,xcolname,ycolname};
end

axesHandle = get(currdata,'parent');
% set to axes units to normalized 
axesunits = getappdata(figHandle,'bfit_axesunits');
if isempty(axesunits) % not yet set/saved
    axesunitsstate = get(axesHandle,'units');
    setappdata(figHandle,'bfit_axesunits',axesunitsstate);
    if ~isequal(axesunitsstate,'normalized')
        set(axesHandle,'units','normalized');
    end
end

%turn displayname listener on
axesList = datachildren(figHandle);
lineL = plotchild(axesList, 2, true);

for i = lineL'
    if ~isempty(bfitFindProp(i, 'bfit_CurveDisplayNameListeners'))
	listeners = get(handle(i), 'bfit_CurveDisplayNameListeners');
        bfitSetListenerEnabled(listeners.displaynamechanged, true);
    end
end

%------------------------------------------------
function bfitsetdatanames(figHandle)
% BFITSETDATANAMES Name data with legend strings.

legends = findobj(figHandle,'type','axes','tag','legend');
for i=1:length(legends)
    ud = get(legends(i), 'userdata');
    datahandles = ud.handles;
    datanames = ud.lstrings;
    for j = 1:min(length(datahandles),length(datanames))
        d = datanames{j};
        % name must be a char row vector.
        if ~isequal(size(d,1),1)
            d = d';
            d = (d(:))';
        end
		% When deleting, the handle might be in the HG hierarchy, but not exist.
		if ishghandle(datahandles(j))
			setappdata(double(datahandles(j)),'bfit_dataname',d);
		end
    end
end