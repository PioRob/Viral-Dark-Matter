function varargout = rsim_gui_sa(varargin)
% LAUNCH the Rapid Simulation Target GUI
%
% This is the stand alone version of rsim_gui. It contains minor
% differences in order to compile into a stand alone application.
%
% RSIM_GUI with no arguments starts the GUI with the default MAT-file
% loaded as well as the default executable file.
% 

%   Copyright 2002-2005 The MathWorks, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2005/12/19 07:38:17 $

% Check user input to make sure it is in a form of a string
if nargin == 1 & ~ischar(varargin{1})
  errordlg(['When loading data into the RSIM GUI, it must be done in the' ...
	' form of a string. Example: RSIM_GUI(''mymodel_rtp.mat'') '], ...
  'File Load Error')
  return
end
if nargin <= 1  
  fig = openfig(mfilename,'reuse');
  
  resizeFcn(fig);
  
  % Use system color scheme for figure window:
  set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
  % Generate a structure of handles to pass to callbacks, and store it. 
  handles = guihandles(fig); 
  % Save handles structure
  guidata(fig, handles);
  if nargin == 1
	% Needed to check if varargin is a MAT-file or workspace variable
	len = length(varargin{1});
  end
  if nargin == 0
	% Load the default mat file (rsim_rtp_struct.mat)
	Check_And_Load([],handles,0);
%   elseif exist(varargin{1},'file')
% 	% Check and Load the specified file
% 	Check_And_Load(varargin{1},handles);
%   elseif len <= 4 | (len > 4 & (~strcmp(varargin{1}(end-3:end),'.mat') | ...
% 	  ~strcmp(varargin{1}(end-3:end),'.MAT')))
% 	% Check and Load data from MATLAB workspace
% 	Check_And_Load(varargin{1},handles,2);
  else
	errordlg('Specified RSIM MAT-File (Structure) Not Found','File Load Error')
	handles.exe_File = 'None Loaded';
	guidata(handles.rsim_gui_sa,handles);
  end	  
  % If there is an output argument, the first one is the figure handle
  if nargout > 0
	varargout{1} = fig;
  end  
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
  try
	if (nargout)
	  [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	else
	  feval(varargin{:}); % FEVAL switchyard
	end
  catch
	disp(lasterr);
  end
end

% ------------------------------------------------------------
% Check to see if the MAT-file has the required fields - if so
% load it and display the first entry.
% ------------------------------------------------------------
function pass = Check_And_Load(file,handles,mat_file)
% Initialize the variable "pass" to determine if this is a valid file.
pass = 0;
% If called without any file then set file to the default file name.
% Otherwise if the file exists, load it.
% The mat_file value verifies the following when it is equal to:
% 0    - When no MAT-File is declared in calling RSIM_GUI
% 2    - When loading in a structure from the workspace
% None - Loading MAT-File using the 'Load MAT-File' menu 
if isempty(file) & mat_file == 0
  file                  = 'rsim_rtp_struct.mat'; 
  handles.exe_File      = [];
  handles.OutputMATFile = [];
  handles.exe_File      = Executable_Callback(handles.Run_Executable,[],handles);
  handles.exe_File      = char(handles.exe_File);
  if isunix
    handles.OutputMATFile = [handles.exe_File '.mat'];
  elseif ispc
    handles.OutputMATFile = [handles.exe_File(1:end-4) '.mat'];
  end   
  guidata(handles.rsim_gui_sa,handles);
end
check_file = dir(file);
% Need to check if exe is loaded
check_exe = dir(handles.exe_File);
try
  if isempty(check_exe) == 1
	handles.exe_File = 'None Loaded';
	set(handles.CurrentEXEFile,'string','- None Loaded -')
	set(handles.OutputMATFileName,'String','No RSIM EXE File Loaded')
  end
catch
  handles.exe_File = 'None Loaded';
  set(handles.CurrentEXEFile,'string','- None Loaded -')
  set(handles.OutputMATFileName,'String','No RSIM EXE File Loaded')
end
if length(check_file) > 0
  data = load(file);
  str_path = pwd;
  % Need to handle the path correctly on UNIX
  if isunix
    handles.LastFile = [str_path,'/',file];
    % Need to handle the path correctly on PC
  elseif ispc
    handles.LastFile = [str_path,'\',file];
  end
  % Set the 'Current MAT-File' edit box to the MAT-file name
  set(handles.CurrentMATFile,'string',file(1:end-4))
% elseif mat_file == 2
%   try
% 	data = evalin('base',file);
% 	handles.exe_File = 'None Loaded';
% 	handles.LastFile = [];
% 	if ~isstruct(data)
% 	  errordlg('Specified name is not a RSIM structure.',['Load RSIM '...
% 		  'Stucture Error'])
% 	  guidata(handles.rsim_gui,handles);
% 	  set(handles.CurrentMATFile,'string','- None Loaded -')
% 	  set(handles.Dimensions_label,'String','');
% 	  set(handles.Elements_label,'String','')
% 	  set(handles.DataType_label,'String','')
% 	  set(handles.listbox2,'string','')
% 	  set(handles.listbox_variables,'string','')
% 	  set(handles.EditData_label,'String','')
% 	  return
% 	end
%   catch
% 	errordlg('Specified RSIM structure Not Found.','Load RSIM Stucture Error')
% 	handles.exe_File = 'None Loaded';
% 	guidata(handles.rsim_gui,handles);
% 	set(handles.CurrentMATFile,'string','- None Loaded -')
% 	set(handles.Dimensions_label,'String','');
% 	set(handles.Elements_label,'String','')
% 	set(handles.DataType_label,'String','')
% 	set(handles.listbox2,'string','')
% 	set(handles.listbox_variables,'string','')
% 	set(handles.EditData_label,'String','')
% 	return
%   end
else
  warndlg('Demo MAT-File Not Found. Please load a RSIM MAT-File', ...
	'Load File Warning')
  guidata(handles.rsim_gui_sa,handles);
  return
end
% Validate the MAT-file or workspace structure by checking its fields
% The file/structure is only valid if the fields called 
% "modelChecksum" and "parameters" exist
flds = fieldnames(data);
guidata(handles.rsim_gui_sa,handles)
if length(flds) == 1
  handles.rtpStruct = getfield(data,flds{1}); 
  handles.lastdata  = flds{1};
  if isfield(handles.rtpStruct,'modelChecksum') & ...
	  isfield(handles.rtpStruct,'parameters') & ...
	  isfield(handles.rtpStruct.parameters,'map')
	pass = 1;
  end
elseif length(flds) == 2 & mat_file == 2
  handles.rtpStruct.modelChecksum = getfield(data,flds{1}); 
  handles.rtpStruct.parameters = getfield(data,flds{2});
  temp=handles.rtpStruct.parameters(1).map;
  handles.lastdata = file;
  if isfield(handles.rtpStruct.parameters,'map') & ...
	  isfield(temp,'ReferencedBy') & isfield(temp,'Identifier')
	pass = 1;
	set(handles.CurrentMATFile,'string','Please Save the RSIM Structure')
  end
end
if pass == 0
  errordlg('No valid rtP Structure found in MAT-File','RSIM Structure Error')
  set(handles.CurrentMATFile,'string','- None Loaded -')
  return
end
% Create handles to the information we want to display in the GUI. For Example:
% - Variable Names, - Dimensions, and - Datatype
Idx = 1;
handles.numTrans = length(handles.rtpStruct.parameters);
for paramIdx = 1:handles.numTrans
  numVars = length(handles.rtpStruct.parameters(paramIdx).map);
  for mapIdx = 1:numVars
	handles.Ident{Idx} = char(handles.rtpStruct.parameters(paramIdx). ...
	  map(mapIdx).Identifier);
	handles.Dim{Idx}   = handles.rtpStruct.parameters(paramIdx). ...
	  map(mapIdx).Dimensions;
	handles.ValInd{Idx}= handles.rtpStruct.parameters(paramIdx). ...
	  map(mapIdx).ValueIndices;
	handles.Dtype{Idx} = char(handles.rtpStruct.parameters(paramIdx). ...
	  dataTypeName);
	handles.Complx{Idx}= handles.rtpStruct.parameters(paramIdx).complex;
	handles.TransIdx{Idx} = handles.rtpStruct.parameters(paramIdx).dtTransIdx;
	Idx = Idx+1;
  end
  Idx = Idx;
end
% Display the Variable names in the listbox
set(handles.listbox_variables,'String',handles.Ident);
guidata(handles.rsim_gui_sa,handles);
listbox_variables_Callback(handles.listbox2,[],handles)
% ------------------------------------------------------------
% Callback for Load MAT-File menu - displays an open dialog
% ------------------------------------------------------------
function varargout = Open_Callback(h, eventdata, handles, varargin)
% Use UIGETFILE to allow for the selection of a custom address book.
[filename, pathname] = uigetfile( ...
  {'*.mat', 'All MAT-Files (*.mat)'; ...
	'*.*','All Files (*.*)'}, ...
  'Select RSIM MAT-File');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
  return
  % Otherwise construct the fullfilename and Check and load the file.
else
  File = fullfile(pathname,filename);
  % if the MAT-file is not valid, do not save the name
  if Check_And_Load(File,handles,1)
	handles=guidata(h);
	handles.LastFile = fullfile(pathname,filename);
	guidata(h,handles)
	% Set the 'Current MAT-File' edit box to the MAT-file name
	set(handles.CurrentMATFile,'string',filename(1:end-4))
	% Set the Dimensions,, Number of Elements, data, etc...
	listbox_variables_Callback(handles.listbox2,[],handles)
  end
end

% ------------------------------------------------------------
% Callback for Save and Save As menus 
% ------------------------------------------------------------
function varargout = Save_Callback(h, eventdata, handles, varargin)
% Get the Tag of the menu selected
Tag      = get(h,'Tag');
% Get the rtpStruct structure
% Based on the item selected, take the appropriate action
if isfield(handles,'lastdata') == 0
  warndlg('No MAT-File Loaded to Save.','Save File Error ')
  return
end
% Set the structure (with initial structure name) for the mat file
data_name = handles.lastdata;
%str_struct = handles.rtpStruct;
%pass_data = [data_name '=' 'handles.rtpStruct;'];
%eval(pass_data);
% If data is loaded, check to see if it is a file
if isempty(handles.LastFile)
  % Then it must be a MAT-File; change Tag to 'Save As'
  Tag = 'Save_As';
end
switch Tag
  % Check to see if there is a MAT-File or structure loaded
case 'Save'
  % Save to the default MAT-file name
  File = handles.LastFile;
  rtpStruct = handles.rtpStruct;
  save(File,'rtpStruct')
case 'Save_As'
  % Allow the user to select the file name to save to
  [filename, pathname] = uiputfile( ...
	{'*.mat';'*.*'}, ...
	'Save as');	
  % If 'Cancel' was selected then return
  if isequal([filename,pathname],[0,0])
	return
  else
	% Construct the full path and save
	File = fullfile(pathname,filename);
	rtpStruct = handles.rtpStruct;
	save(File,'rtpStruct');
    % Update this field with new MAT-File name
	handles.LastFile = File;
	guidata(h,handles)
	if strcmp(filename(end-3:end),'.mat') | strcmp(filename(end-3:end),'.MAT')
	  filename = filename(1:end-4);
	end
	set(handles.CurrentMATFile,'string',filename)
  end
end

% --------------------------------------------------------------------
function varargout = Executable_Callback_Menu(h,eventdata,handles,varargin)

Executable_Callback(handles.Run_Executable,[],handles);

% --------------------------------------------------------------------
function varargout = Executable_Callback(h, eventdata, handles, varargin)
Tag = get(h,'Tag');
switch Tag
case 'Run_Executable'
  checked = 0;
  % If the user has not loaded an .exe file, load the default
  if isempty(handles.exe_File)
    handles.exe_File = 'rtwdemo_rsim_param_tuning.exe';
    if isunix
      handles.exe_File = 'rtwdemo_rsim_param_tuning';
    end
    run_file = handles.exe_File;
    handles.OutputMATFile = handles.exe_File;
    % Check if the exe exists
    check_file = dir(handles.exe_File);
    if isempty(check_file) == 1
      warndlg(['RSIM Demo Executable File Not Found. Please load '...
          'a RSIM Executable File'],'RSIM Executable Warning')
      varargout = {run_file};
      return
    end
    checked = 1;
  end
  run_file   = handles.exe_File; 
  check_file = dir(run_file);
  
  if ~isempty(check_file) & checked == 1
    % Found Demo file; set the 'Current EXE File' box
    if isunix
      set(handles.CurrentEXEFile,'string',handles.exe_File)
      set(handles.OutputMATFileName,'String',handles.OutputMATFile)
    elseif ispc
      set(handles.CurrentEXEFile,'string',handles.exe_File(1:end-4))
      set(handles.OutputMATFileName,'String',handles.OutputMATFile(1:end-4))
    end
    str_path = pwd;
    % Need to handle the path correctly on UNIX
    if isunix
      handles.exe_File = [str_path,'/',handles.exe_File];
      % Need to handle the path correctly on PC
    elseif ispc
      handles.exe_File = [str_path,'\',handles.exe_File];
    end
    handles.OutputMATFile = handles.exe_File;
    run_file = handles.exe_File; 
    varargout = {run_file};
    guidata(handles.rsim_gui_sa,handles);
    return
  end
  % Check if the exe exists
  check_file= dir(handles.exe_File);
  if isempty(check_file) == 1
	% Check if the exe exists
	errordlg('No RSIM Executable File Found.','RSIM Executable Error')
	return
  end
  % Check to make sure a MAT-File is specified
  if isfield(handles,'LastFile') == 0 | isempty(handles.LastFile) == 1
	errordlg('No MAT-File specified or data saved.','RSIM Executable Error')
	return
  end
  % Run the Executable (DOS or in UNIX)
  if ispc == 1
	[err] = dos([run_file,' -p ',handles.LastFile,' -o ', ...
		handles.OutputMATFile,' -v']);
  elseif isunix == 1
	[err] = unix([run_file,' -p ',handles.LastFile,' -o ', ...
		handles.OutputMATFile ' -v']);
  end
  if err >= 1
	% Display any errors from execution
	errordlg('Check the command prompt for error details','RSIM Executable Error')
  else
	% Display the results
	msgbox('Successful RSIM Execution','RSIM Results')
  end
case 'Load_Executable'
  % Use UIGETFILE to allow for the selection of a custom address book.
  if isunix
	[filename, pathname] = uigetfile( ...
	  {'*.*','All Files (*.*)'}, ...
	  'Select RSIM Executable File');
  end
  if ispc
    [filename, pathname] = uigetfile( ...
      {'*.exe', 'All Executable-Files (*.exe)'; ...
        '*.*','All Files (*.*)'}, ...
      'Select RSIM Executable File');
  end
  % If "Cancel" is selected then return
  if isequal([filename,pathname],[0,0])
	return
	% Otherwise construct the fullfilename and load the executable.
  else
	handles.exe_File = fullfile(pathname,filename);
	% Set the 'Current RSIM EXE' and 'Output MAT-File' box to the file name
    if isunix
      set(handles.CurrentEXEFile,'string',filename);
	  handles.OutputMATFile = [filename '.mat'];
	  set(handles.OutputMATFileName,'String',handles.OutputMATFile(1:end-4));
      handles.OutputMATFile = [handles.exe_File '.mat'];
    elseif ispc
	  set(handles.CurrentEXEFile,'string',filename(1:end-4));
	  handles.OutputMATFile = [filename(1:end-4) '.mat'];
	  set(handles.OutputMATFileName,'String',handles.OutputMATFile(1:end-4));
      handles.OutputMATFile = [handles.exe_File(1:end-4) '.mat'];
    end
  end
end
guidata(h,handles); 

% --------------------------------------------------------------------
function varargout = listbox_variables_Callback(h, eventdata, handles, varargin)
ind   = get(h,'value');
% Check to make sure there is data loaded & specified
if isfield(handles,'lastdata') == 0
  warndlg('No RSIM data structure specified to be modified.', ...
	'Data Dimension Mismatch Warning')
  return
end  
%Display the Dimensions of the data
disp_dim = [num2str(handles.Dim{ind}(1)),'x',num2str(handles.Dim{ind}(2))];
set(handles.Dimensions_label,'String',disp_dim);
% Display the number of elements
num_elements = num2str(handles.Dim{ind}(1)*handles.Dim{ind}(2));
set(handles.Elements_label,'String',num_elements)
% Handles whether the data is complex or not
if isequal(handles.Complx(ind),{1})
  Dtype =[handles.Dtype{ind} '  (complex)'];
else
  Dtype = handles.Dtype(ind);
end
% Display the data type and whether it is complex
set(handles.DataType_label,'String',Dtype)
% Find the proper transition to obtain the correct data from RSIM structure
for i = 1:handles.numTrans
  if handles.TransIdx{ind} == handles.rtpStruct.parameters(i).dtTransIdx & ...
	  strcmp(handles.Dtype(ind),handles.rtpStruct.parameters(i).dataTypeName) & ...
	  handles.Complx{ind} == handles.rtpStruct.parameters(i).complex
	handles.paramIdx = i;
	break
  end
end
% If data is a matrix or column vector, need to reshape then display it
if handles.Dim{ind}(1) > 1 
  columnwise = handles.rtpStruct.parameters(handles.paramIdx). ...
	values(handles.ValInd{ind}(1):handles.ValInd{ind}(2));
  matrix = reshape(columnwise,handles.Dim{ind}(1),handles.Dim{ind}(2));
  % Convert the data into a string then display it
  for i = 1:length(matrix(:,1))
	handles.disp_matrix{i} = num2str(double(matrix(i,:)));
  end
  set(handles.listbox2,'Value',1)
  set(handles.listbox2,'string',handles.disp_matrix)
  % Send the data to the edit box as well
  set(handles.EditData_label,'String',handles.disp_matrix{1})
else
  % If not a matrix or column vector, convert it to a string then display it
  set(handles.listbox2,'Value',1)
  data = num2str(double(handles.rtpStruct.parameters ...
	(handles.paramIdx).values(handles.ValInd{ind}(1):handles.ValInd{ind}(2))));
  set(handles.listbox2,'string',data)
  set(handles.EditData_label,'String',data)
end
guidata(h,handles);

% --------------------------------------------------------------------
function varargout = listbox2_Callback(h, eventdata, handles, varargin)
ind_variable = get(handles.listbox_variables,'value');
ind_listbox2 = get(h,'value');
data         = get(h,'string');
% Check to make sure there is data loaded & specified
if isfield(handles,'lastdata') == 0
  warndlg('No RSIM data structure specified to be modified.', ...
	'Data Dimension Mismatch Warning')
  return
end  
if handles.Dim{ind_variable}(1) > 1 
  % If the data is a matrix or column vector
  set(handles.EditData_label,'String',data(ind_listbox2,:))
else
  set(handles.EditData_label,'String',data)
end
guidata(h,handles);

% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
data  = get(h,'string');
list2 = get(handles.listbox2,'string');
ind   = get(handles.listbox_variables,'value');
row   = get(handles.listbox2,'value');
% Check to make sure there is data loaded & specified
if isfield(handles,'lastdata') == 0
  warndlg('No RSIM data structure specified to be modified.', ...
	'Data Dimension Mismatch Warning')
  return
end  
% If the data is a matrix or column vector
if handles.Dim{ind}(1) > 1
  handles.disp_matrix{row} = char(data);
  data = char(handles.disp_matrix);
end
% 1. Need to find the data type using the index (ind) then convert to it. 
type      = (handles.Dtype{ind});
% exec      = [type '(str2num(data))'];
% new_data  = eval(exec);
exec      = str2num(data);
new_data  = feval(type,exec);
disp_data = num2str(double(new_data));
orig_data = (handles.rtpStruct.parameters(handles.paramIdx).values ...
  (handles.ValInd{ind}(1):handles.ValInd{ind}(2)));

if isempty(new_data)
  errordlg('New data must match original dimensions (See Dimensions field).', ...
	'Data Dimension Mismatch Error')
  set(handles.EditData_label,'String',list2)
  return
end
% 2. Reshape the data back if it was originally a matrix or column vector
if handles.Dim{ind}(1) > 1 
  column    = length(handles.ValInd{ind}(1):handles.ValInd{ind}(2));
  new_data  = reshape(new_data,1,column);
end
% 3. Check the datatype (class): complex or not
if isreal(new_data) ~= isreal(orig_data)
  errordlg('New data must match original data type (See DataType field).', ...
	'Data Type Mismatch Error')
  set(handles.EditData_label,'String',list2)
  return
end
% 4. Check the data size to make sure it is the same as original data
if size(new_data) == size(orig_data)
  handles.rtpStruct.parameters(handles.paramIdx).values ...
	(handles.ValInd{ind}(1):handles.ValInd{ind}(2)) = new_data;
  set(handles.listbox2,'string',disp_data)
  set(handles.EditData_label,'String',disp_data(row,:))
else
  errordlg('New data must match original dimensions (See Dimensions field).', ...
	'Data Dimension Mismatch Error')
  set(handles.EditData_label,'String',list2)
end
guidata(h,handles);

% --------------------------------------------------------------------
function varargout = edit12_Callback(h, eventdata, handles, varargin)

OutputMATFileName  = get(h,'string');
OutputMATFile      = OutputMATFileName;
len                = length(OutputMATFileName);
% Check that we have loaded in an EXE File by checking for OutputMATFile field
if strcmp(handles.exe_File,'None Loaded')
  warndlg('No RSIM Executable file has been loaded.', ...
	'Output RSIM File Warning')
  set(handles.OutputMATFileName,'String','No RSIM EXE File Loaded')
  return
end  

for i = 1:len
  if strcmp(OutputMATFileName(i),' ')
	warndlg('Output MAT-File name must contain no spaces', ...
	  'Output RSIM File Warning')
	set(handles.OutputMATFileName,'String',handles.OutputMATFile(1:end-4))
	return
  end
  check = len - (i+3);
  if check >= 0 & strcmp(OutputMATFileName(i:i+3),'.mat')
	OutputMATFile = OutputMATFileName(1:end-4);
  end
end

set(handles.OutputMATFileName,'String',OutputMATFile)
%Save the path from executable location, for the MAT-file to be saved in
if isunix
  str_path = findstr(handles.exe_File,'/');
  handles.OutputMATFile = [handles.exe_File(1:str_path(end)-1), ...
      '/',OutputMATFile,'.mat'];
elseif ispc
  str_path = findstr(handles.exe_File,'\');
  handles.OutputMATFile = [handles.exe_File(1:str_path(end)-1), ...
      '\',OutputMATFile,'.mat'];
end   
guidata(handles.rsim_gui_sa,handles);
%handles.OutputMATFile = [OutputMATFile '.mat'];
guidata(h,handles);

% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)

edit12_Callback(handles.OutputMATFileName,[],handles);
guidata(h,handles);

%--------------------------------------------------------------------
function resizeFcn(fig)

Sample = findall(fig,'tag','text7');
Ext = get(Sample, 'extent');
WidthRatio = Ext(3)/(0.1767);
HeightRatio = Ext(4)/(0.0335);
drawnow
Pos = get(fig,'position');
Pos(3) = Pos(3) * WidthRatio;
Pos(4) = Pos(4) * HeightRatio;
set(fig,'Position', Pos)
%End of Function