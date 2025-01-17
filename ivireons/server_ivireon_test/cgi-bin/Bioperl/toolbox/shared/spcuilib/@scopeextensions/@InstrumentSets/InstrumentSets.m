function this = InstrumentSets(varargin)
%INSTRUMENTSETS Construct an INSTRUMENTSETS object

%   Author(s): J. Schickler
%   Copyright 2007 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2009/08/14 04:06:34 $

this = scopeextensions.InstrumentSets;

this.init(varargin{:});

% Create the recent files UI object.
hRecentUI = uimgr.uirecentitemslist('scope', 'RecentISets');

% Configure the recent files object.
hRecentUI.RecentFiles.setMax(4);
hRecentUI.RecentFiles.EmptyListMsg = '<no recent sets>';
hRecentUI.RecentFiles.LoadFileTitle =  'Load instrumentation set:';
hRecentUI.RecentFiles.SaveFileTitle = 'Save instrumentation set:';
hRecentUI.RecentFiles.FileFilterSpec = {'*.iset','Instrumentation Sets (*.iset)'; ...
    '*.*',  'All Files (*.*)'};
hRecentUI.RecentFiles.LoadCallback = @() callback(this.Application, ...
    @() load(this, this.RecentFilesUI.RecentFiles.SelectedItem), ...
    @(str, id) warningParser(this, str, id));

hRecentUI.RecentFiles.SaveCallback = @() callback(this.Application, ...
    @() save(this, this.RecentFilesUI.RecentFiles.SelectedItem), ...
    @(str, id) warningParser(this, str, id));

% set(hRecentUI.RecentFiles, ...
%     'EmptyListMsg', '<no recent sets>', ...
%     'LoadFileTitle', 'Load instrumentation set:', ...
%     'SaveFileTitle', 'Save instrumentation set:', ...
%     'FileFilterSpec', {'*.iset','Instrumentation Sets (*.iset)'; ...
%     '*.*',  'All Files (*.*)'}, ...
%     'LoadCallback', @() callback(this.Application, ...
%     @() load(this, this.RecentFilesUI.RecentFiles.SelectedItem), ...
%     @(str, id) warningParser(this, str, id)), ...
%     'SaveCallback', @() callback(this.Application, ...
%     @() save(this, this.RecentFilesUI.RecentFiles.SelectedItem), ...
%     @(str, id) warningParser(this, str, id)));

% Cache the objects for later use.
this.RecentFilesUI = hRecentUI;

% [EOF]
