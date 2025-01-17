function varargout=web(varargin)
%WEB Open Web browser on site or files.
%   WEB opens up an empty internal web browser.  The default internal web
%   browser includes a toolbar with standard web browser icons, and an address
%   box showing the current address.
%
%   WEB URL displays the specified URL (Uniform Resource Locator) in an
%   internal web browser window.  If one or more internal web browsers are
%   already running, the last active browser (determined by the last
%   browser which had focus) will be reused.  If the URL is located underneath
%   docroot, then it will automatically be displayed inside the Help
%   browser.  If the file is on the MATLAB path, a fully qualified name is
%   not necessary.  Also, the file can be referenced relative to the
%   current working directory.
%
%   WEB URL -NEW displays the specified URL in a new internal web browser
%   window.
%
%   WEB URL -NOTOOLBAR displays the specified URL in an internal web
%   browser without a toolbar (and address box).
%
%   WEB URL -NOADDRESSBOX displays the specified URL in an internal web
%   browser without an address box (but does include a toolbar with standard
%   web browser icons).
%
%   WEB URL -HELPBROWSER displays the specified URL in the Help browser.
%
%   STAT = WEB(...) -BROWSER returns the status of the WEB command in the
%   variable STAT. STAT = 0 indicates successful execution. STAT = 1
%   indicates
%   that the browser was not found. STAT = 2 indicates that the browser was
%   found, but could not be launched.
%
%   [STAT, BROWSER] = WEB returns the status, and a handle to the last active
%   browser.
%
%   [STAT, BROWSER, URL] = WEB returns the status, a handle to the last active
%   browser, and the URL of the current location.
%
%   WEB URL -BROWSER opens a System Web browser and loads the file or Web site
%   specified in the URL (Uniform Resource Locator).  The URL can be of any form
%   that your browser can support.  Generally, it can specify a local  file or a
%   Web site on the Internet.  On Windows and Macintosh, the Web browser
%   is determined by the operating system.  On UNIX (excluding the Mac), it is
%   determined as specified in the "Web" preferences panel.
%
%   Examples:
%      web file:///disk/dir1/dir2/foo.html
%         opens the file foo.html in an internal browser.
%
%      web('foo.html');
%         opens the file foo.html if it is on the MATLAB path.
%
%      web('html/foo.html');
%         opens the file html/foo.html, which is relative to the current
%         working directory.
%
%      web('text://<html>Hello World</html>');
%         displays the html formatted text inside an internal browser.
%
%      web('http://www.mathworks.com', '-new');
%         loads the MathWorks Web page into a new internal browser.
%
%      web('http://www.mathworks.com', '-new', '-notoolbar');
%         loads the MathWorks Web page into a new internal browser without
%         a toolbar or address box.
%
%      web('file:///disk/helpfile.html', '-helpbrowser');
%         opens the file helpfile.html in the Help browser.
%
%      web('file:///disk/dir1/dir2/foo.html', '-browser');
%         opens the file foo.html in a system browser.
%
%      web mailto:email_address
%         uses your system browser to send mail.
%

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.36 $

% Examine the inputs to see what options are selected.
[options, html_file] = examineInputs(varargin{:});

% Handle matlab: protocol by passing the command to evalin.
if strncmp(html_file, 'matlab:', 7)
    evalin('caller', html_file(8:end));
    return;
end

if ~options.useSystemBrowser && usejava('mwt') && ~strncmp(html_file,'mailto:',7)
    % If in Java environment, use the MATLAB web browser for everything
    % other than mailto.
    [activeBrowser, html_file] = openMatlabBrowser(html_file, options);
    if nargout > 0
        varargout = {0 activeBrowser html_file};
    end
    return;
elseif ~usejava('mwt') && isUnderDocroot(html_file)
    displayWarningMessage('MATLAB:web:NoHelpBrowser', sprintf('%s%s',...
        'Displaying a documentation page in the Help browser requires ',...
        'Java, which is unavailable due to your startup options.'),...
        options.showWarningInDialog);
    if nargout > 0
        varargout = {1 [] ''};
    end
    return;
end

% Otherwise, use system web browser.

% If no URL is specified with system browser, complain and exit.
if isempty(html_file)
    displayWarningMessage('MATLAB:web:NoURL', 'No URL specified.',...
        options.showWarningInDialog);
    if nargout > 0
        varargout(1) = {1};
    end;
    return;
end

% We'll only issue a warning for a system error if we will not be 
% returning a status code.
options.warnOnSystemError = nargout == 0;

% open HTML file in browser
if ismac
    % We can't detect system errors on the Mac, so the warning options are unnecessary.
    stat = openMacBrowser(html_file);
elseif isunix
    stat = openUnixBrowser(html_file, options);
elseif ispc
    stat = openWindowsBrowser(html_file, options);
end

if nargout > 0
    varargout(1) = {stat};
end
end

%--------------------------------------------------------------------------
function underDocroot = isUnderDocroot(html_file)
if isempty(html_file)
    underDocroot = false;
else
    docrootCheck = regexprep(docroot,'[\\/]help[\\/]ja_JP[\\/]?$','/help','once');
    docrootCheck = regexprep(docrootCheck,'[\\/]','[\\\\/]');
    docrootRegexp = ['^(?:(\w{2,}:)+///?)?' docrootCheck];
    underDocroot = ~isempty(regexp(html_file,docrootRegexp,'once'));
end
end

%--------------------------------------------------------------------------
function [options, html_file] = examineInputs(varargin)
% Initialize defaults.
options = struct;

% If running in deployed mode, use the system browser since the builtin
% web browser is not available.
options.useSystemBrowser = isdeployed;
options.showWarningInDialog = 0;
options.useHelpBrowser = 0;
options.newBrowser = 0;
options.showToolbar = 1;
options.showAddressBox = 1;
options.waitForNetscape = 0;

html_file = [];

for i = 1:length(varargin)
    argName = strtrim(varargin{i});
    if strcmp(argName, '-browser') == 1
        options.useSystemBrowser = 1;
    elseif strcmp(argName, '-display') == 1
        options.showWarningInDialog = 1;
    elseif strcmp(argName, '-helpbrowser') == 1
        options.useHelpBrowser = 1;
    elseif strcmp(argName, '-new') == 1
        options.newBrowser = 1;
    elseif strcmp(argName, '-notoolbar') == 1
        options.showToolbar = 0;
    elseif strcmp(argName, '-noaddressbox') == 1
        options.showAddressBox = 0;
    elseif strcmp(argName, '1') == 1
        % assume this is the 'waitForNetscape' argument for the system browser.
        options.waitForNetscape = 1;
    else
        % assume this is the filename.
        html_file = argName;
    end
end
html_file = resolveUrl(html_file);
end

%--------------------------------------------------------------------------
function html_file = resolveUrl(html_file)
if ~isempty(html_file)
    if length(html_file) < 7 || ~(strcmp('text://', html_file(1:7)) == 1 || strcmp('http://', html_file(1:7)) == 1)
        % If the file is on MATLAB's search path, get the fully qualified
        % filename.
        fullpath = which(html_file);
        if ~isempty(fullpath)
            % This means the file is on the path somewhere.
            html_file = fullpath;
        else
            % If the file is referenced as a relative path, get the fully
            % qualified filename.
            fullpath = fullfile(pwd,html_file);
            if isOnFileSystem(fullpath)
                html_file = fullpath;
            end
        end
    end
end
end

%--------------------------------------------------------------------------
function [activeBrowser, html_file] = openMatlabBrowser(html_file, options)

% Initialize the active browser.
activeBrowser = [];

% if the file is under docroot, use the help browser.
options.useHelpBrowser = options.useHelpBrowser || isUnderDocroot(html_file);

% If no protocol specified, or an absolute/UNC pathname is not given,
% include explicit 'http:'.  Otherwise the web browser assumes 'file:'
if ~isempty(html_file) && isempty(findstr(html_file,':')) && ~strcmp(html_file(1:2),'\\') && ~strcmp(html_file(1),'/')
    html_file = ['http://' html_file];
end

% The file should be displayed inside the help browser
if options.useHelpBrowser
    if strncmp(html_file,'text://',7)
        com.mathworks.mlservices.MLHelpServices.setHtmlText(html_file(8:end));
    else
        com.mathworks.mlservices.MLHelpServices.setCurrentLocation(html_file);
    end
else
    activeBrowser = [];
    if ~options.newBrowser
        % User doesn't want a new browser, so find the active browser.
        activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.getActiveBrowser;
    end
    if isempty(activeBrowser)
        % If there is no active browser, create a new one.
        activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.createBrowser(options.showToolbar, options.showAddressBox);
    end
    
    if ~isempty(html_file)
        if strncmp(html_file,'text://',7)
            activeBrowser.setHtmlText(html_file(8:end));
        else
            activeBrowser.setCurrentLocation(html_file);
        end
    else
        html_file = char(activeBrowser.getCurrentLocation);
    end
end

end

%--------------------------------------------------------------------------
function stat = openMacBrowser(html_file)
% Escape some special characters.  We're eventually going to shell out,
% and  while some shells (such as bash) can handle the characters,
% some others (such as tcsh) can't.
html_file = regexprep(html_file, '[?&!()]','\\$0');

% Since we're opening the system browser using the NextStep open command,
% we must specify a syntactically valid URL, even if the user didn't
% specify one.  We choose The MathWorks web site as the default.
if isempty(html_file)
    html_file = 'http://www.mathworks.com';
else
    % If no protocol specified, or an absolute/UNC pathname is not given,
    % include explicit 'http:'.  MAC command needs the http://.
    if isempty(findstr(html_file,':')) && ~strcmp(html_file(1:2),'\\') && ~strcmp(html_file(1),'/')
        html_file = ['http://' html_file];
    end
end
unix(['open ' html_file]);
stat = 0;
end

%--------------------------------------------------------------------------
function stat = openUnixBrowser(html_file,options)
stat = 0;

% Get the system browser and options from the preferences.
doccmd = system_dependent('getpref', 'HTMLSystemBrowser');
unixOptions = system_dependent('getpref', 'HTMLSystemBrowserOptions');
unixOptions = unixOptions(2:end);  % Strip off the S

if isempty(doccmd)
    % The preference has not been set from the preferences dialog, so use the default.
    doccmd = 'firefox';
else
    % Strip off the "S" which was returned by the system_dependent command above.
    doccmd = doccmd(2:end);
end

if isempty(doccmd)
    % The preference was cleared in the preference dialog, so notify
    % the user there is no browser defined.
    handleWarning('MATLAB:web:NoBrowser', sprintf('%s\n\n%s', ...
        'No Web browser defined.', ...
        'To set up your System web browser, type "preferences(''Web'')" to display the Preferences dialog.'), ...
        options.warnOnSystemError, options.showWarningInDialog);
    stat = 1;
else
    % Use 'which' to determine if the user's browser exists, since we
    % can't catch an accurate status when attempting to start the
    % browser since it must be run in the background.
    [status,output] = unix(['which ' doccmd]);
    if status ~= 0
        handleWarning('MATLAB:web:BrowserNotFound', ...
            sprintf('%s\n\n%s\n\n%s', ...
            'MATLAB was unable to launch your System web browser:', ...
            output, ...
            'To configure your System web browser, type "preferences(''Web'')" to display the Preferences dialog.'), ...
            options.warnOnSystemError, options.showWarningInDialog);
        stat = 1;
    end
end

if stat == 0
    %determine what kind of shell we are running
    shell = getenv('SHELL');
    [~, shellname] = fileparts(shell);
    %construct shell specific command
    if isequal(shellname, 'tcsh') || isequal(shellname, 'csh')
        shellarg ='>& /dev/null &';
    elseif isequal(shellname,'sh') || isequal(shellname, 'ksh') || isequal(shellname, 'bash')
        shellarg ='> /dev/null 2>&1 & ';
    else
        shellarg ='& ';
    end
    
    % Need to escape ! on UNIX
    html_file = regexprep(html_file, '!','\\$0');
    
    % For the system browser, always send a file: URL
    if isOnFileSystem(html_file) && ~strcmp(html_file(1:5),'file:')
        html_file = ['file://' html_file];
    end
    
    comm = [doccmd ' ' unixOptions ' -remote "openURL(' html_file ')" ' shellarg];
    
    % separate the path from the filename for netscape
    [~,fname]=fileparts(doccmd);
    
    % Initialize status
    status = 1;
    
    % If netscape is the system browser, we can look for a lock file
    % which indicates that netscape is currently running, so we can
    % open the html_file in an existing session.
    if strmatch(fname, ['netscape';'Netscape'])
        % We need to explicitly use /bin/ls because ls might be aliased to ls -F
        lockfile = [getenv('HOME') '/.netscape/lock' sprintf('\n')];
        [~,result]=unix(['/bin/ls ' lockfile]);
        if ~isempty(findstr(result,lockfile))
            % if the netscape lock file exists than try to open
            % html_file in an existing netscape session
            status = unix(comm);
        end
    end
    
    if status
        % browser not running, then start it up.
        comm = [doccmd ' ' unixOptions ' ''' html_file ''' ' shellarg];
        [status,output] = unix(comm);
        if status
            stat = 1;
        end
        
        %
        % if waitForNetscape is nonzero, hang around in a loop until
        % netscape launches and connects to the X-server.  I do this by
        % exploiting the fact that the remote commands operate through the
        % netscape global translation table.  I chose 'undefined-key' as a
        % no-op to test for netscape being alive and running.
        %
        if options.waitForNetscape,
            comm = [doccmd ' ' unixOptions ' -remote "undefined-key()" ' shellarg];
            while ~status,
                status = unix(comm);
                pause(1);
            end
        end
        
        if stat ~= 0
            handleWarning('MATLAB:web:BrowserNotFound', ...
                sprintf('%s\n\n%s', ...
                'MATLAB was unable to launch your System web browser:', ...
                output),options.warnOnSystemError, options.showWarningInDialog);

        end
    end
end
end

%--------------------------------------------------------------------------
function stat = openWindowsBrowser(html_file,options)
if strncmp(html_file,'mailto:',7)
    % Use the user's default mail client.
    [stat,output] = dos(['cmd.exe /c start "" ' html_file]);
else
    html_file = strrep(html_file, '"', '\"');
    % If we're on the filesystem and there's an anchor at the end of
    % the URL, we need to strip it off; otherwise the file won't be
    % displayed in the browser.
    % This is a known limitation of the FileProtocolHandler.
    anchor_pos = findstr(html_file, '#');
    if ~isempty(anchor_pos) && isOnFileSystem(html_file)
        html_file = html_file(1:anchor_pos-1);
    end
    [stat,output] = dos(['cmd.exe /c rundll32 url.dll,FileProtocolHandler "' html_file '"']);
end

if stat ~= 0
    handleWarning('MATLAB:web:BrowserNotFound', ...
        sprintf('%s\n\n%s', ...
        'MATLAB was unable to launch your System web browser:', ...
        output),options.warnOnSystemError, options.showWarningInDialog);
    
end
end

%--------------------------------------------------------------------------
function handleWarning(messageID, message, warnOnSystemError, warnInDialog)
if warnOnSystemError
    displayWarningMessage(messageID, message, warnInDialog);
end
end

%--------------------------------------------------------------------------
function displayWarningMessage(messageID, message, warnInDialog)
if warnInDialog
    warndlg(message, xlate('MATLAB Warning'));
else
    warning(messageID, message);
end
end

%--------------------------------------------------------------------------
function onFileSystem = isOnFileSystem(html_file)
onFileSystem = false;
if ~isempty(html_file)
    % If the path starts with "file:" assume it's on the local
    % filesystem and return.
    if length(html_file) >= 5 && strcmp(html_file(5), 'file:')
        onFileSystem = true;
        return;
    end
    
    % If using the "file:" protocol OR the path begins with a forward slash
    % OR there is no protocol being used (no colon exists in the path), assume
    % it's on the filesystem.  Relative paths already should have been
    % converted to absolute before calling this function.
    if strcmp(html_file(1), '/') || isempty(findstr(html_file, ':'))
        onFileSystem = true;
    elseif ispc
        % On the PC, if the 2nd character is a colon OR the path begins
        % with 2 backward slashes, assume it's on the filesystem.
        if (strcmp(html_file(2), ':') || strcmp(html_file(1:2), '\\'))
            onFileSystem = true;
        end
    end
    
    % One last check, make sure the file actually exists...
    if onFileSystem
        % strip off the anchor if one exists
        anchor_pos = findstr(html_file, '#');
        if ~isempty(anchor_pos)
            html_file = html_file(1:anchor_pos-1);
        end
        if ~exist(html_file, 'file')
            onFileSystem = false;
        end
    end
end
end
