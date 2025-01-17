function initialize(h)

% Copyright 2004-2008 The MathWorks, Inc.

%% Builds the Data Selection GUI

import javax.swing.*; 
import com.mathworks.mwswing.*;
import com.mathworks.toolbox.timeseries.*;

% Build buttons
h.Handles.BTNok = uicontrol('String','OK','Parent',h.Figure,'Units','Characters','Position',...
    [53.6-15 1.1535 13.8 1.7687],'Callback',{@localOK h},'BusyAction','Cancel',...
    'Interruptible','off');
h.Handles.BTNcancel = uicontrol('String','Cancel','Parent',h.Figure,'Units','Characters','Position',...
    [70-15.5 1.1535 13.8 1.7687],'Callback',@(es,ed) set(h,'Visible','off'));
h.Handles.BTNhelp = uicontrol('String','Help','Parent',h.Figure,'Units','Characters','Position',...
    [70 1.1535 13.8 1.7687],'Callback',...
    @(es,ed) tsDispatchHelp('d_resample_data_plot','modal',h.Figure));

% Build time series panel
PNLselectTs = uibuttongroup('Parent',h.Figure,'Units','Characters','Position', ...
    [2.2 21.7627 80.8 15],'Title','Define Time Series');
h.Handles.tsTableModel = tsMatlabCallbackTableModel(cell(0,4),...
             {' ',xlate('Time series'),xlate('Path')},'tsDispatchTableCallback',...
             {'refresh' 1 h});
drawnow
h.Handles.tsTableModel.setNoEditCols([1 2]);        
h.Handles.tsTable = javaObjectEDT('com.mathworks.mwswing.MJTable',h.Handles.tsTableModel);
h.Handles.tsTable.setName('mergedlg:tstable');
javaMethod('setPreferredWidth',h.Handles.tsTable.getColumnModel.getColumn(2),...
    200);
javaMethod('setAutoResizeMode',h.Handles.tsTable,JTable.AUTO_RESIZE_OFF);
sPanel = javaObjectEDT('com.mathworks.mwswing.MJScrollPane',h.Handles.tsTable);
[junk,tsTablePanel] = javacomponent(sPanel,[0 0 1 1],h.Figure);
c = javaObjectEDT('javax.swing.JCheckBox');
javaMethod('setCellEditor',h.Handles.tsTable.getColumnModel.getColumn(0),...
    DefaultCellEditor(c));
javaMethod('setCellRenderer',h.Handles.tsTable.getColumnModel.getColumn(0),...
    tsCheckBoxRenderer);
set(tsTablePanel,'Units','Pixels','Parent',PNLselectTs,'Position', ...
    hgconvertunits(ancestor(PNLselectTs,'figure'),[3.2 5.5368 74.4 7.6900],...
    'Characters','Pixels',PNLselectTs))
h.Handles.RADIOinplace = uicontrol('style','radiobutton','String',...
    'Overwrite selected time series','Units',...
    'Characters','Parent',PNLselectTs,'Position',[3.8 3.2298 40.8 1.1535],'Value',1);
h.Handles.RADIOnewmerged = uicontrol('style','radiobutton','String',...
    'Create new time series','Units',...
    'Characters','Parent',PNLselectTs,'Position',[3.8 1.4611 52.8 1.1535]);

% 1st column is HTML
h.ViewNode.getRoot.setHTMTableColumn(h.Handles.tsTable,2);

% Build time interval panel
PNLInterval = uibuttongroup('Parent',h.Figure,'Units','Characters','Position', ...
    [2.2 9.6894 81.6 11.5350],'Title','Specify New Time Vector','SelectionChangeFcn',...
    @(es,ed) refresh(h));
h.Handles.RADIOunion = uicontrol('style','radiobutton','String',...
    'Union of time vectors on the interval where they overlap','Units',...
    'Characters','Parent',PNLInterval,'Position',[3.2 8.459 70 1.1535],'Value',1);
h.Handles.RADIOintersect = uicontrol('style','radiobutton','String',...
    'Intersection of time vectors on the interval where they overlap','Units',...
    'Characters','Parent',PNLInterval,'Position',[3.2 6.0751 70 1.1535]);
h.Handles.RADIOuniform = uicontrol('style','radiobutton','String',...
    'Uniform time vector with time interval','Units',...
    'Characters','Parent',PNLInterval,'Position',[3.2 3.6912 42.8 1.1535]);
h.Handles.RADIOtimeseries = uicontrol('style','radiobutton','String',...
    'Use time vector from time series','Units',...
    'Characters','Parent',PNLInterval,'Position',[3.2 1.3842 40.8 1.1535]);
h.Handles.EDITinterval = uicontrol('style','edit','Units',...
    'Characters','Parent',PNLInterval,'Position',[46.2 3.3836  14.4 1.6149],'String','1',...
    'HorizontalAlignment','Left','BackgroundColor',[1 1 1],'Callback',...
    @(es,ed) refresh(h));
h.Handles.COMBunits = uicontrol('style','popupmenu','Units',...
    'Characters','Parent',PNLInterval,'Position',[62.6 3.3067 15 1.6918],'String',...
    get(findtype('TimeUnits'),'String'),'Value',6,...
    'Callback',@(es,ed) refresh(h));
if ~ismac
   set(h.Handles.COMBunits,'BackgroundColor',[1 1 1]);
end
h.Handles.COMBts = uicontrol('style','popupmenu','Units',...
    'Characters','Parent',PNLInterval,'Position',[46 0.9228 31.8 1.6918],...
    'String',{' '},'Value',1,'Callback',@(es,ed) refresh(h));
if ~ismac
   set(h.Handles.COMBts,'BackgroundColor',[1 1 1]);
end

% Build time panel
PNLnewTime = uipanel('Parent',h.Figure,'Units','Characters','Position', ...
    [2.2 3.6143 81.6 5.5368],'Title',xlate('New Time Vector'));
h.Handles.TXTstarttime = uicontrol('style','text','Units',...
    'Characters','Parent',PNLnewTime,'Position',[3 2.353 74.8 1.3073],...
    'String',xlate('Start - end'),'HorizontalAlignment','Left');
h.Handles.TXTendtime = uicontrol('style','text','Units',...
    'Characters','Parent',PNLnewTime,'Position',[3 0.3536 74.8 1.3073],...
    'String','Number of samples','HorizontalAlignment','Left');

% Make the figure background color match the uipanel color
set(h.Figure,'Color',get(PNLnewTime,'BackGroundColor'))

% Install listeners
h.generic_listeners


function localOK(eventSrc, eventData, h)

% OK button callback to merge and resample the data
set(h.Figure,'Pointer','watch')

try % Prevent unexpected command line errors
    if h.eval;
       h.Visible = 'off';
    end 
    set(h.Figure,'Pointer','arrow')
catch %#ok<CTCH>
    set(h.Figure,'Pointer','arrow')
end