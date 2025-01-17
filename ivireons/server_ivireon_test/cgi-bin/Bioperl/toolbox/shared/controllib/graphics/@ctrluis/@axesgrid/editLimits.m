function LimBox = editLimits(this,XY,BoxLabel,BoxPool)
%EDITLIMITS  Builds group box for editing axis limits.

%   Author(s): A. DiVergilio, P. Gahinet
%   Copyright 1986-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.2 $  $Date: 2010/04/21 21:45:25 $

% RE: XY is the axis (X or Y), and RCLabel is the row/column denomination
Tag = sprintf('%sLims-Grid',XY);
LimBox = find(handle(BoxPool),'Tag',Tag);
if isempty(LimBox)
   % Create groupbox if not found
   LimBox = LocalCreateUI(this,XY);
end
LimBox.GroupBox.setLabel(sprintf(BoxLabel))
LimBox.Tag = Tag;

% Target
LimBox.Target = this;

% Target listeners
pconfig = [findprop(this,'XlimSharing');...
      findprop(this,'YlimSharing');...
      findprop(this,'AxesGrouping')];
LimBox.TargetListeners = ...
   [handle.listener(this,'PostLimitChanged',{@localReadProp XY LimBox});...
      handle.listener(this,pconfig,'PropertyPostSet',{@localConfigure XY LimBox})];

% Initialize content
localConfigure([],[],XY,LimBox)   % RC selector vis
localReadProp([],[],XY,LimBox)


%------------------ Local Functions ------------------------

function LimBox = LocalCreateUI(AxesGrid,XY)
%GUI for editing axesgroup limits

%---Get Toolbox Preferences
Prefs = cstprefs.tbxprefs;
import com.mathworks.mwt.*;

%---Definitions
LCENTER = MWLabel.CENTER;
LRIGHT  = MWLabel.RIGHT;
LLEFT   = MWLabel.LEFT;
BCENTER = MWBorderLayout.CENTER;
BWEST   = MWBorderLayout.WEST;
BEAST   = MWBorderLayout.EAST;
GL_N1 = java.awt.GridLayout(3,1,0,4);

% Axis dependent
if strcmpi(XY,'x')
   RCLabel = 'Column:';
else
   RCLabel = 'Row:';
end

%---Top-level panel (MWGroupbox)
Main = MWGroupbox;
Main.setFont(Prefs.JavaFontB);
Main.setLayout(MWBorderLayout(8,0));

%---Column 1 (west in Main)
s.C1 = MWPanel(GL_N1); Main.add(s.C1,BWEST);
s.RCLabel = MWLabel(sprintf('%s',RCLabel),LRIGHT); s.C1.add(s.RCLabel);
s.RCLabel.setFont(Prefs.JavaFontP);
s.AutoScaleLabel = MWLabel(ctrlMsgUtils.message('Controllib:gui:strAutoScaleLabel'),LLEFT); 
s.C1.add(s.AutoScaleLabel);
s.AutoScaleLabel.setFont(Prefs.JavaFontP);
s.LimitsLabel = MWLabel(ctrlMsgUtils.message('Controllib:gui:strLimitsLabel'),LRIGHT); 
s.C1.add(s.LimitsLabel);
s.LimitsLabel.setFont(Prefs.JavaFontP);

%---Center panel (center in Main, holds s.C2,s.C3)
s.Center = MWPanel(MWBorderLayout(8,0)); Main.add(s.Center,BCENTER);

%---Column 2 (west in s.Center)
s.C2 = MWPanel(GL_N1); s.Center.add(s.C2,BWEST);
s.RCSelect = MWChoice; s.C2.add(s.RCSelect);
s.RCSelect.setFont(Prefs.JavaFontP);
s.AutoScalePanel = MWPanel(MWBorderLayout(8,0)); s.C2.add(s.AutoScalePanel);
s.AutoScale = MWCheckbox; s.AutoScalePanel.add(s.AutoScale,BWEST);
s.AutoScale.setFont(Prefs.JavaFontP);

%---Column 3 (subgrid labels, center in s.Center)
s.C3 = MWPanel(GL_N1); 
s.C3L1 = MWLabel;   s.C3.add(s.C3L1);
s.C3L1.setFont(Prefs.JavaFontP);
s.C3L2 = MWLabel;   s.C3.add(s.C3L2);
s.C3L2.setFont(Prefs.JavaFontP);

%---Initialize struct array holding each row of limit editors
Panel = MWPanel(MWBorderLayout(5,0));  s.C2.add(Panel);
Lim1  = MWTextField(7); 
Panel.add(Lim1,MWBorderLayout.WEST);
Lim1.setFont(Prefs.JavaFontP);
LimTo = MWLabel(ctrlMsgUtils.message('Controllib:gui:strTo'),MWLabel.CENTER); 
Panel.add(LimTo,MWBorderLayout.CENTER);
LimTo.setFont(Prefs.JavaFontP);
Lim2  = MWTextField(7); 
Panel.add(Lim2,MWBorderLayout.EAST);
Lim2.setFont(Prefs.JavaFontP);
Label = MWLabel(sprintf(''));   s.C3.add(Label);
Label.setFont(Prefs.JavaFontP);
s.LimRows = struct('Panel',Panel,'Lim1',Lim1,'LimTo',LimTo,'Lim2',Lim2,'Label',Label);

%---Store java handles
set(Main,'UserData',s);

%---Create @editbox instance
LimBox = cstprefs.editbox;
LimBox.GroupBox = Main;

% Callbacks
hc = handle(s.RCSelect, 'callbackproperties');
set(hc,'ItemStateChangedCallback',@(es,ed) localReadProp(es,ed,XY,LimBox));
hc = handle(s.AutoScale, 'callbackproperties');
set(hc,'ItemStateChangedCallback',@(es,ed) localWriteLimMode(es,ed,XY,LimBox));

% LimCallback = {@localWriteLims XY LimBox 1};
hc = handle(Lim1, 'callbackproperties');
set(hc,'ActionPerformedCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,1));
set(hc,'FocusLostCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,1));
hc = handle(Lim2, 'callbackproperties');
set(hc,'ActionPerformedCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,1));
set(hc,'FocusLostCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,1));



%%%%%%%%%%%%%%%%%%
% localConfigure %
%%%%%%%%%%%%%%%%%%
function localConfigure(eventSrc,eventData,XY,LimBox)
% Configure GUI for current target
import com.mathworks.mwt.*;
Prefs = cstprefs.tbxprefs;
s = get(LimBox.GroupBox,'UserData');

% Init
AxGrid = LimBox.Target;
if strcmpi(XY,'x')
   ShareAll = strcmp(AxGrid.XlimSharing,'all');
   SubgridSize = AxGrid.Size(4);
   Nselect = (AxGrid.Size(2)>1 & ~ShareAll & ...
      ~strcmp(AxGrid.XlimSharing,'peer') & ...
      ~any(strcmp(AxGrid.AxesGrouping,{'column','all'})));
   Nlimrows = 1 + (~ShareAll) * (SubgridSize-1);
   RCLabels = AxGrid.ColumnLabel(1:SubgridSize:end);
else
   ShareAll = strcmp(AxGrid.YlimSharing,'all');
   SubgridSize = AxGrid.Size(3);
   Nselect = (AxGrid.Size(1)>1 & ~ShareAll & ...
      ~strcmp(AxGrid.YlimSharing,'peer') & ...
      ~any(strcmp(AxGrid.AxesGrouping,{'row','all'})));
   Nlimrows = 1 + (~ShareAll) * (SubgridSize-1);
   RCLabels = AxGrid.RowLabel(1:SubgridSize:end);
end

% Visibility of row/column selector
if Nselect && isempty(s.RCSelect.getParent)
   % Add row/column selector
   GL = java.awt.GridLayout(s.C2.getComponentCount+1,1,0,4);
   s.C1.setLayout(GL); s.C2.setLayout(GL); s.C3.setLayout(GL);
   s.C1.add(s.RCLabel,1);
   s.C2.add(s.RCSelect,1);
   s.C3.add(s.C3L2,1);
elseif ~Nselect && ~isempty(s.RCSelect.getParent)
   % Hide row/column selector
   s.C1.remove(s.RCLabel);
   s.C2.remove(s.RCSelect);
   s.C3.remove(s.C3L2);
   GL = java.awt.GridLayout(s.C2.getComponentCount,1,0,4);
   s.C1.setLayout(GL); s.C2.setLayout(GL); s.C3.setLayout(GL);
end

% Initialize row/column selector contents
if Nselect && isempty(eventSrc)
   n = s.RCSelect.getSelectedIndex;  % last selection
   % Populate combo box
   nitems = 1+length(RCLabels);
   s.RCSelect.removeAll;
   s.RCSelect.addItem(sprintf('all'));
   for ct=1:nitems-1
      s.RCSelect.addItem(sprintf(RCLabels{ct}));
   end
   % Initial selection
   if n<0 || n>=nitems
      % Can happen when initializing or changing target
      n=1;
   end
   s.RCSelect.select(n);
end

% Visibility of subgrid labels
ShowSubLabels = (SubgridSize>1 & ~ShareAll);
if ShowSubLabels && isempty(s.C3.getParent)
   s.Center.add(s.C3,MWBorderLayout.CENTER);
elseif ~ShowSubLabels && ~isempty(s.C3.getParent)
   s.Center.remove(s.C3);
end
   
% Adjust number of rows of limit editors
% 1) Create missing rows
for ct=length(s.LimRows)+1:Nlimrows
   Panel = MWPanel(MWBorderLayout(5,0));
   Lim1  = MWTextField(7); 
   Panel.add(Lim1,MWBorderLayout.WEST);
   Lim1.setFont(Prefs.JavaFontP);
   LimTo = MWLabel(ctrlMsgUtils.message('Controllib:gui:strTo'),MWLabel.CENTER); 
   Panel.add(LimTo,MWBorderLayout.CENTER);
   LimTo.setFont(Prefs.JavaFontP);
   Lim2  = MWTextField(7); 
   Panel.add(Lim2,MWBorderLayout.EAST);
   Lim2.setFont(Prefs.JavaFontP);
   Label = MWLabel(sprintf(''));
   Label.setFont(Prefs.JavaFontP);
   s.LimRows(ct,1) = struct('Panel',Panel,'Lim1',Lim1,'LimTo',LimTo,'Lim2',Lim2,'Label',Label);
   % Callbacks
%    LimCallback = {@localWriteLims XY LimBox ct}; 
   hc = handle(s.LimRows(ct).Lim1, 'callbackproperties');
   set(hc,'ActionPerformedCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,ct));
   set(hc,'FocusLostCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,ct));
   
   hc = handle(s.LimRows(ct).Lim2, 'callbackproperties');
   set(hc,'ActionPerformedCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,ct));
   set(hc,'FocusLostCallback',@(es,ed) localWriteLims(es,ed,XY,LimBox,ct));
end
% 2) Adjust row visibility
Nlimrows0 = s.C2.getComponentCount-1-Nselect;  % current row count
for ct=Nlimrows+1:Nlimrows0
   % Remove extra rows
   s.C2.remove(s.LimRows(ct).Panel);    
   s.C3.remove(s.LimRows(ct).Label);    
end
GL = java.awt.GridLayout(1+Nselect+Nlimrows,1,0,4);
s.C1.setLayout(GL); s.C2.setLayout(GL); s.C3.setLayout(GL);
for ct=Nlimrows0+1:Nlimrows
   % Add missing rows
   s.C2.add(s.LimRows(ct).Panel);    
   s.C3.add(s.LimRows(ct).Label);    
end

% Store modified s
set(LimBox.GroupBox,'UserData',s)

% Context-dependent actions
if ~isempty(eventSrc)
   % In listener callback, repack frame to reflect changes\
   LimBox.GroupBox.getFrame.pack;
end


%%%%%%%%%%%%%%%%%
% localReadProp %
%%%%%%%%%%%%%%%%%
function localReadProp(eventSrc,eventData,XY,LimBox)
% Update GUI when limits change
s = get(LimBox.GroupBox,'UserData');
AxGrid = LimBox.Target;
if strcmpi(XY,'x')
   RCSize = AxGrid.Size([2 4]);
   LimSharing = AxGrid.XLimSharing;
   limfcn = 'getxlim';
else
   RCSize = AxGrid.Size([1 3]);
   LimSharing = AxGrid.YLimSharing;
   limfcn = 'getylim';
end

% Auto-Scale status
LimModes = AxGrid.(sprintf('%sLimMode',XY));
if isempty(s.RCSelect.getParent)
   % 1x1 or shared limits or grouped axes
   s.AutoScale.setState(strcmp(LimModes{1},'auto'));
else
   rc = s.RCSelect.getSelectedIndex;
   if rc>0
      s.AutoScale.setState(all(strcmp(LimModes((rc-1)*RCSize(2)+1:rc*RCSize(2)),'auto')))
   else
      s.AutoScale.setState(all(strcmp(LimModes,'auto')))
   end
end

% Limits
Limits = cell(RCSize(2),1);
if isempty(s.RCSelect.getParent)
   % 1x1 or shared limits or grouped axes
   if strcmp(LimSharing,'all')
      % Single row of limit editors
      Limits = {feval(limfcn,AxGrid)};
   elseif ~strcmp(LimSharing,'none')
      % RCSize(2) rows (read limits from first row of major grid)
      for ct=1:RCSize(2)
         Limits{ct} = feval(limfcn,AxGrid,[1 ct]);
      end
   end
else
   % Limits for selected row or column
   n = s.RCSelect.getSelectedIndex;
   if n>0 
      for ct=1:RCSize(2)
         Limits{ct} = feval(limfcn,AxGrid,[n ct]);
      end
   else
      % "All" selection
      AllLims = reshape(feval(limfcn,AxGrid),RCSize([2 1]));
      for ct=1:RCSize(2)
         if isequal(AllLims{ct,1},AllLims{ct,:})
            Limits{ct} = AllLims{ct,1};
         end
      end
   end
end

% Print limit values
for ct=1:length(Limits)
   if isempty(Limits{ct})
      s.LimRows(ct).Lim1.setText('');
      s.LimRows(ct).Lim2.setText('');
      set(s.LimRows(ct).Lim1,'UserData',[]);
   else
      Lim1Str = sprintf('%.3g',Limits{ct}(1));
      Lim2Str = sprintf('%.3g',Limits{ct}(2));
      s.LimRows(ct).Lim1.setText(Lim1Str);
      s.LimRows(ct).Lim2.setText(Lim2Str);
      % RE: Store value equivalent to displayed string, otherwise rounding may
      %     cause limit to switch to manual when just visiting the edit box
      set(s.LimRows(ct).Lim1,'UserData',str2double({Lim1Str Lim2Str}));
   end
end


%%%%%%%%%%%%%%%%%%
% localWriteLims %
%%%%%%%%%%%%%%%%%%
function localWriteLims(eventSrc,eventData,XY,LimBox,RCIndex)
% Update limits of target when content of limit editors changes
s = get(LimBox.GroupBox,'UserData');
AxGrid = LimBox.Target;

% Get new limit values
Lim1Str = char(s.LimRows(RCIndex).Lim1.getText);  % current string
Lim2Str = char(s.LimRows(RCIndex).Lim2.getText);
Lim1 = localEvalLim(Lim1Str);  % corresponding value
Lim2 = localEvalLim(Lim2Str);
CurrentLims = get(s.LimRows(RCIndex).Lim1,'UserData');
if ~isempty(Lim1) && ~isempty(Lim2) && Lim1<Lim2 && ~isequal(CurrentLims,[Lim1 Lim2])
   % Time to update the limits
   if strcmpi(XY,'x')
      RCSize = AxGrid.Size([2 4]);
      limfcn = 'setxlim';
   else
      RCSize = AxGrid.Size([1 3]);
      limfcn = 'setylim';
   end
   
   try
      if ~isempty(s.RCSelect.getParent) && s.RCSelect.getSelectedIndex>0
         % Single row or column affected
         feval(limfcn,AxGrid,[Lim1 Lim2],[s.RCSelect.getSelectedIndex RCIndex],'silent')
      elseif RCSize(2)==1
         % Global setting
         feval(limfcn,AxGrid,[Lim1 Lim2],'silent') 
      else
         % New limits apply to each row/col such that mod(row,RCSize(2))=RCIndex
         for ct=1:RCSize(1)
            feval(limfcn,AxGrid,[Lim1 Lim2],[ct RCIndex],'silent')  % all subgrid peers
         end
      end
      AxGrid.send('ViewChanged'); % send event after limits are updated
      set(s.LimRows(RCIndex).Lim1,'UserData',str2double({Lim1Str Lim2Str}))
   catch ME
      warndlg(ME.message,'Property Editor Warning','modal')
   end
end


%%%%%%%%%%%%%%%%%%%%%
% localWriteLimMode %
%%%%%%%%%%%%%%%%%%%%%
function localWriteLimMode(eventSrc,eventData,XY,LimBox)
% Update limit modes of target when Auto-Scale state changes
s = get(LimBox.GroupBox,'UserData');
AxGrid = LimBox.Target;
LimModeProp = sprintf('%sLimMode',XY);
SubgridSize = AxGrid.Size(3+strcmpi(XY,'x'));

if eventSrc.getState
   NewMode = {'auto'};
else
   NewMode = {'manual'};
end

% Update limit modes
LimMode = AxGrid.(LimModeProp);
if isempty(s.RCSelect.getParent) || s.RCSelect.getSelectedIndex==0
   % Global setting
   LimMode(:) = NewMode;
else
   % Change affects one row of major grid
   n = s.RCSelect.getSelectedIndex;
   LimMode((n-1)*SubgridSize+1:n*SubgridSize) = NewMode;
end
AxGrid.(LimModeProp) = LimMode;
   
   
%%%%%%%%%%%%%%%%
% localEvalLim %
%%%%%%%%%%%%%%%%
function val = localEvalLim(str)
% Evaluate string val, returning valid real scalar only, empty otherwise
if ~isempty(str)
   val = evalin('base',str,'[]');
   if   ~isreal(val) || any(~isfinite(val)) || ~isequal(size(val),[1 1])
      val = [];
   end
else
   val = [];
end