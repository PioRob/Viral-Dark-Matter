function bfitplotdatastats(datahandle,stattype,dataselect,checkon)
% BFITPLOTDATASTATS Plot data statistics line for the Data Statistics GUI.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.18.4.10 $  $Date: 2009/01/29 17:16:45 $

% get data
xdata = get(datahandle,'xdata');
ydata = get(datahandle,'ydata');
axesH = get(datahandle,'parent'); % need this in case subplots in figure
figH = get(axesH,'parent');
xlims = get(axesH,'xlim');
ylims = get(axesH,'ylim');

bfitlistenoff(figH)
set(axesH,'xlimmode','manual');
set(axesH,'ylimmode','manual');

if isequal(dataselect,'x') % x-data selected
    xon = 1;
    data = xdata;
elseif isequal(dataselect,'y') % y-data selected
    xon = 0;
    data = ydata;
else
    error('MATLAB:bfitplotdatastats:DataSelectInvalidValue', 'Invalid value for dataselect: %s.', dataselect)
end

appdatanameH = ['Data_Stats_',upper(dataselect),'_Handles'];
appdatanameShow = ['Data_Stats_',upper(dataselect),'_Showing'];
% get handles
stathandles = getappdata(double(datahandle),appdatanameH);
statshowing = getappdata(double(datahandle),appdatanameShow);

% The order is important
ind = strmatch(stattype,strvcat('min','max','mean','median','mode','std','range'));

if checkon
    % save hold and units state and set it
    fignextplot = get(figH,'nextplot');
    axesnextplot = get(axesH,'nextplot');
    axesunits = get(axesH,'units');
    set(figH,'nextplot','add');
    set(axesH,'nextplot','add');
    set(axesH,'units','normalized');
    
    tagname = [stattype,' ',dataselect];
    % compute stats
    switch stattype
    case 'max'
        dataresults = max(data);
        color = [0 0 1];        % blue
    case 'min'
        dataresults = min(data);
        color = [0 0.75 0.75];  % darker cyan
    case 'median'
        dataresults = median(data);
        color = [1 0 0];        % red
    case 'mean'
        dataresults = mean(data);
        color = [0 0.5 0];      % darker green
    case 'mode'
        dataresults = mode(data);
        color = [0 0 .6];      % darker blue
    case 'std'
        meandata = mean(data);
        stddata = std(data); 
        dataresults = [meandata - stddata, meandata + stddata;];
        color = [0.75 0 0.75];  % darker magenta
    otherwise
        error('MATLAB:bfitplotdatastats:InvalidStatType', 'Invalid value for stattype: %s.', stattype);
    end
    if xon
        linetype = '--';
    else
        linetype = '-.';
    end
    % plot line representing the statistic
    if xon
        stath = verticalline(dataresults,'linestyle',linetype, ...
            'tag', tagname,...
            'color',color,'parent',axesH);
    else
        stath = horizontalline(dataresults,'linestyle',linetype, ...
            'tag', tagname, ...
            'color',color,'parent',axesH);
    end

    % code generation for plot line
    b = hggetbehavior(stath,'MCodeGeneration');
    set(b,'mcodeConstructorFcn',{@bfitMCodeConstructor, 'stat', datahandle, [], stattype, xon});

    stath = double(stath);
    x = get(stath,'xdata');
    y = get(stath,'ydata');
    if iscell(x)
        x = [x{:}]; 
        y = [y{:}];
    end
    adjustaxes(axesH,x,y,xlims,ylims,xon);
    if xon
        statappdata.type = 'stat x';
    else
        statappdata.type = 'stat y';
    end
    statappdata.index = ind;
    setappdata(double(stath),'bfit',statappdata);
    setappdata(double(stath), 'Basic_Fit_Copy_Flag',1);
   
    showing = true;

    % reset plot: hold and units
    set(figH,'nextplot',fignextplot);
    set(axesH,'nextplot',axesnextplot);
    set(axesH,'units',axesunits);
    
else % check off
	if ishghandle(stathandles(ind))
		delete(stathandles(ind));
		stath = Inf;
		showing = false;
	else % invalid handle, which can happen due to timing of clicking.
		% return so we don't reset appdata below
        bfitlistenon(figH)
		return;
	end
end

stathandles(ind) = stath;
statshowing(ind) = showing;
setappdata(double(datahandle),appdatanameH,stathandles);
setappdata(double(datahandle),appdatanameShow,statshowing);

bfitcreatelegend(axesH);
bfitlistenon(figH);

%-----------------------------------------------------------------
function adjustaxes(axesH,x,y,xlims,ylims,xon)
% ADJUSTAXES Adjust axes when lines are plotted very near axes limits.

if xon
    dmin = min(x);
    dmax = max(x);
    amin = xlims(1);
    amax = xlims(2);
else
    dmin = min(y);
    dmax = max(y);
    amin = ylims(1);
    amax = ylims(2);
end

if dmin <= (amin + ((amax-amin)/100))
    newamin = amin - (amax-amin)/100;
else
    newamin = amin;
end
if dmax >= (amax - ((amax-amin)/100))
    newamax = amax + (amax-amin)/100;
else
    newamax = amax;
end

if xon
    set(axesH,'xlim',[newamin newamax]);
else
    set(axesH,'ylim',[newamin newamax]);
end

