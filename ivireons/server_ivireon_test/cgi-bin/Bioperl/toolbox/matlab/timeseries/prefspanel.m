function prefspanel
%PREFSPANEL Registers a preferences control panel.
%   PREFSPANEL registers a Preferences Control panel with the MATLAB IDE.
%

%   Author: 
%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2005/06/27 23:06:29 $

%   Register Object-based Context menus items in the Workspace Browser for 
%   MATLAB's audio objects, AUDIOPLAYER and AUDIORECORDER.
%
%   Class:  audioplayer
%     Audio Controls ->
%       Play
%       Pause
%       Resume
%       Stop
%
%   Class: audiorecorder
%     Audio Controls ->
%       Record
%       Pause
%       Resume
%       Stop
%       ------
%       Get Audio Data
%       Plot Signal

%   Methods of MatlabObjectMenuRegistry are unsupported.  Calls to these
%   methods will become errors in future releases.
com.mathworks.mlwidgets.workspace.MatlabCustomClassRegistry.registerClassCallbacks(...
    {'tsdata.timeseries'},...
    'Timeseries Controls',...
    {'Viewer...'},...
    {'tstool($1);'} );

% com.mathworks.mlwidgets.workspace.MatlabCustomClassRegistry.registerClassCallbacks(...
%     {'audiorecorder'},...
%     'Audio Controls',...
%     {'Record','Pause','Resume','Stop','Play','-','Get Audio Data','Plot Signal'},...
%     {'record($1);','pause($1);','resume($1);','stop($1);',...
%         'audiouniquename(play($1),''$1_audioplayer'',''base'');',...
%         '','audiouniquename(getaudiodata($1), ''$1_audiodata'',''base'');',...
%         'plot(getaudiodata($1));'} );

% [EOF]
