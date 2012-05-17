function plotutils(str,h,code)
%PLOTUTILS Helper function for plot objects
% This internal helper function may be removed in a future release.

%  PLOTUTILS('makemcode',H,HCODE) adds common code-generation
%  fragments to HCODE for graphics object H. Do not directly
%  call this function outside of code generation or plot
%  object management.
%  PLOTUTILS('BeginAxesUpdate',AX) turns off legend, colorbar,
%  and subplot layout listeners for axes AX. Nesting of update 
%  blocks is not supported.
%  PLOTUTILS('EndAxesUpdate',AX) turns on legend, colorbar,
%  and subplot layout listeners. 
%  PLOTUTILS('MCodeBaseLine',H,HCODE) adds get/set commands for
%  the baseline of H to HCODE to get custom property values.

%   Copyright 1984-2008 The MathWorks, Inc.

% check for BeginAxesUpdate or EndAxesUpdate
% since this gets called often code for performance
isBeginUpdate = str(1) == 'B';
if isBeginUpdate || (str(1) == 'E')
  if isempty(h) || ~ishandle(h), return; end
  p = get(h,'Parent');
  if ~ishandle(p), return; end
  if strcmp(get(p,'BeingDeleted'),'on'), return; end
  list = [];

  % Get subplot listeners, if any
  grid = getappdata(p,'SubplotGrid');
  if ~isempty(grid),
    test = double(h) == double(grid);
    if any(test(:))
      list = getappdata(p,'SubplotListeners');
    end
  end

  % Get legend listeners, if any
  if isprop(h,'LegendColorbarListeners')
    if isempty(list)
      list = get(h,'LegendColorbarListeners');
    else
      list2 = get(h,'LegendColorbarListeners');
      list = [list(:) ; list2(:)];
    end
  end

  if ~isempty(list)
    if isBeginUpdate
      set(list,'enable','off');
    else
      set(list,'enable','on');
      invalidateaxis(h);
    end
  end

% must be makemcode
elseif strcmp(str,'makemcode')
  % process Parent - assume if there is only 1 axes that it should be
  % implicit, if it is the parent object.
  fig = ancestor(h,'figure');
  ax = findobj(fig,'type','axes');
  if length(ax) == 1 && isequal(ax,get(h,'Parent'))
    ignoreProperty(code,'Parent')
  end

% generate code for setting baseline properties the user modified  
elseif strcmp(str,'MCodeBaseLine')
  baseline = handle(h.BaseLine);
  hObjMomento = get(code,'MomentoRef');
  hParentMomento = up(hObjMomento);
  
  if isempty(hParentMomento)
    return;
  end

  % Loop through peer momento objects looking for baseline
  hPeerMomentoList = find(hParentMomento,'-depth',1);
  hPeerObj = [];
  for n = 2:length(hPeerMomentoList)
    hPeerMomento = hPeerMomentoList(n);
    hPeerObj = get(hPeerMomento,'ObjectRef');
    if hPeerObj == baseline
      break;
    end
  end
  if isempty(hPeerObj) || ((hPeerObj ~= baseline) || hPeerMomento.Ignore)
    return; % no baseline or already done so exit
  end

  % now we have the baseline, mark it as done
  set(hPeerMomento,'Ignore',true);
  
  % generate the list of properties to put in set command
  hPeerPropertyList = get(hPeerMomento,'PropertyObjects');
  hGenPropList = true(1,length(hPeerPropertyList));
  for m = 1:length(hPeerPropertyList)
    if ~get(hPeerPropertyList(m),'Ignore')         
      name = get(hPeerPropertyList(m),'Name');
      % skip automatically controlled properties - BaseValue is
      % set by the plot.
      if any(strcmp(name,{'Parent','XData','YData','BaseValue'}))
        hGenPropList(m) = false;
      end
    end
  end

  % we have properties to set so we need to generate code for it
  if ~any(hGenPropList)
    return; 
  end

  % generate code to get the baseline handle from the plot
  getfunc = codegen.codefunction('Name','get','CodeRef',code);
  addPostConstructorFunction(code,getfunc);
  hArg = codegen.codeargument('Value',h,'IsParameter',true); 
  addArgin(getfunc,hArg);
  hArg = codegen.codeargument('Value','BaseLine'); 
  addArgin(getfunc,hArg);
  hArgVar = codegen.codeargument('Name','baseline'); 
  addArgout(getfunc,hArgVar);
  
  % generate code to set the custom baseline properties
  setfunc = codegen.codefunction('Name','set','CodeRef',code);
  addPostConstructorFunction(code,setfunc);
  addArgin(setfunc,hArgVar);
  generatePropValueList(setfunc,hPeerPropertyList(hGenPropList));
end
