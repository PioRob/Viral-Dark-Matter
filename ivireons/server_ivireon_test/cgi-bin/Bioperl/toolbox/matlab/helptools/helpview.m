function helpview(path, varargin)
%HELPVIEW Displays an HTML file in the Help browser or 
% "What's This Help" window.
%
%SYNTAX:
%
%  helpview (topic_path)
%  helpview (topic_path, win_type)
%  helpview (topic_path, win_type, ...)
%  helpview (topic_path, win_type, parent)
%  helpview (topic_path, win_type, parent, ...)
%  helpview (map_path, topic_id)
%  helpview (map_path, topic_id, win_type)
%  helpview (map_path, topic_id, win_type, ...)
%  helpview (map_path, topic_id, win_type, parent)
%  helpview (map_path, topic_id, win_type, parent, ...)
%
%
%ARGUMENTS:
%
%  topic_path
%    Path of an html file. The path must end in .htm(l) or
%    .htm(l) and an HTML anchor reference, for example,
%
%       /v5/help/helpview.html#topicpath
%       d:/v5/help/helpview.html#topicpath
%
%  map_path
%    Path of a map file (see below) that maps
%    topic ids to the paths of topic files. The path must
%    end in the extension .map, for example,
%
%      d:/v5/help/ml_graph.map
%
%    The map path may be of the form mapkey:KEY where KEY 
%    identifies a map file specified in a topic map locator file
%    in a product's help tree.
%
%  topic_id
%    An arbitrary string that identifies a topic. HELPVIEW uses
%    the map file specified by path to map topic_id to
%    the path of the HTML file that documents the topic.
%
%  win_type
%    Type of window in which to display the help content.
%    Specify "CSHelpWindow" to use the context-sensitive help viewer.
%    Otherwise, the main "Help" window is used.
%
%  parent
%    Handle to a figure window.  Used by the "CSHelpWindow" win_type
%    to determine the parent of the help dialog.  This argument is ignored
%    if the win_type is not CSHelpWindow.
%
%  'position'
%    Position property (similar to figure property).  This property 
%    specifies the size and location on the screen of the help dialog.  
%    This argument is ignored if the win_type is not CSHelpWindow.
%
%  csh_position
%    Position of the help dialog.  Used by the "CSHelpWindow" win_type
%    to determine the size and location of the help dialog.  This argument 
%    is ignored if the win_type is not CSHelpWindow.
%
%  'size'
%    Size property.  This argument is ignored if the win_type is not 
%    CSHelpWindow.
%
%  csh_size
%    Size of the help dialog.  Used by the "CSHelpWindow" win_type
%    to determine the size of the help dialog.  This argument is ignored
%    if the win_type is not CSHelpWindow.
%
%  'location'
%    Location property.  This argument is ignored if the win_type is 
%    not CSHelpWindow.
%
%  csh_location
%    Location of the help dialog.  Used by the "CSHelpWindow" win_type
%    to determine the location of the help dialog.  This argument is 
%    ignored if the win_type is not CSHelpWindow.
%
%TOPIC MAP FILE
%
%  The map file is an ascii text file that is
%  essentially a two-column list.  Each line is
%  of the form:
%
%    TOPIC_ID PATHNAME
%
%  The TOPIC_ID is an arbitrary string identifying
%  a "chunk" of online help contained in an HTML
%  file.  Typically, the technical writer and the
%  developer will agree what these identifiers should be,
%  and the developer will use them in calls to helpview.
%
%  PATHNAME is a topic_path relative to
%  the directory containing the map file.
%
%  For example, suppose the following map file
%
%    % creating_plots.map
%    zoom     ../creating_plots/data_ex8.html#zoom
%    panning  ../creating_plots/data_ex9.html#panning
%
%  is in the directory DOCROOT/techdoc/creating_plots, where DOCROOT
%  is the root directory of the MATLAB help system. Then,
%  the following call
%
%    helpview([docroot '/techdoc/creating_plots/creating_plots.map'], 'zoom'); 
%
%  is equivalent to
%
%    helpview([docroot '/techdoc/creating_plots/data_ex8.html#zoom']);
%
%  Examples:
%
%   map_path = [docroot '/techdoc/matlab_prog/matlab_prog.map'];
%   helpview(map_path,'matlab_data_types','CSHelpWindow');
%   helpview(map_path,'matlab_data_types','CSHelpWindow','size',[500 400]);
%   helpview(map_path,'matlab_data_types','CSHelpWindow', 'location', ...
%            [100 100]);
%   helpview(map_path,'matlab_data_types','CSHelpWindow', 'position',... 
%            [50 50 100 100]);

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.24 $

% Make sure that we can support the doc command on this platform.
errormsg = javachk('mwt', 'The helpview command');
if ~isempty(errormsg)
    error('MATLAB:doc:UnsupportedPlatform', errormsg.message);
end 

import com.mathworks.mlwidgets.help.CSHelpTopicMap;

wintype = '';
parent = '';

if nargin < 1
    error('MATLAB:helpview:NotEnoughInputArgs', 'Not enough input arguments.  For MATLAB help, type ''help'' or ''helpbrowser''.');
end

if ~ ischar(path) || strcmp(path, '') || exist(path,'dir')==7
    error('MATLAB:helpview:InvalidFirstArg', 'First argument must be a map file or fully qualified filename.');
end

% Ensure that path uses correct separator for platform.
help_path = normalize_path(path);

% Get input parameters separated from size and location
% Note:  this is to be backwards compatible
[inputArgs, csh_size, csh_location] = getInputArgs(varargin);

% Does path specify a topic map key?
e = length(help_path);
if (e > 7) && strcmp(help_path(1:7), 'mapkey:')
    import com.mathworks.mlwidgets.help.TopicMapLocator;
    mapkey = help_path(8:e);
    help_path = char(TopicMapLocator.getMapPath(mapkey));
    if isempty(help_path)
        error('MATLAB:helpview:InvalidMapKey', 'Cannot locate topic map for mapkey: %s.', mapkey);
    end
end

% Does path specify a topic map file?
e = length(help_path);
b = e - 3;
if (b > 0) && strcmp(help_path(b:e), '.map')

    mapfilename = help_path;
        
    % First arg is path of a topic mapfile.  Get the id of the topic to be mapped.
    if (length(inputArgs) < 1)
        error('MATLAB:helpview:TopicIdRequired', 'Topic id required to find topic path from map file.');
    else
        topic_id = inputArgs{1};
    end
    
    % If mapfilename starts with /mapfiles and docroot is empty, assume doc is
    % missing and show the standard error page in the help browser.
    if ((strncmp(mapfilename, [filesep 'mapfiles'], 9)) || (strncmp(mapfilename, 'mapfiles', 8))) && (isempty(docroot) || exist(docroot,'dir') ~= 7)
        html_file = fullfile(matlabroot, 'toolbox', 'local', 'helperr.html');
        web(html_file, '-helpbrowser');
        return;
    end

    % Get topic map.
    topicMap = CSHelpTopicMap(mapfilename);
    
    if (~topicMap.exists())  
       error('MATLAB:helpview:TopicPathDoesNotExist', 'Specified map file does not exist:\n%s', mapfilename);
    end
  
    
    % Look up topic or collection path in the map file.
    help_path = char(topicMap.mapID(topic_id));  
       
    % Make sure the topic_id exists.
    if isempty(help_path)
        error('MATLAB:helpview:TopicPathDoesNotExist', 'Specified topic id (%s) does not exist in map file %s.',topic_id, mapfilename);
    end
    
      
    % Get windows type argument, if specified.
    if (length(inputArgs) >= 2)
        wintype = inputArgs{2};
        if ~ ischar(wintype)
            error('MATLAB:helpview:InvalidThirdParameter', 'Third parameter must specify a window type.');
        end
    end
    
    % Get parent argument, if specified.
    if (length(inputArgs) == 3)
        parent = inputArgs{3};
    end

else % First argument is a fully qualified path.
    % Is there also a wintype argument?
    if (length(inputArgs) >= 1)
        wintype = inputArgs{1};
        if ~ ischar(wintype)
            error('MATLAB:helpview:InvalidSecondParameter', 'Second parameter must specify a window type.');
        end
    end

    % Get parent argument, if specified.
    if (length(inputArgs) == 2)
        parent = inputArgs{2};
    end
end

% Call the help viewer.

% Use the appropriate viewer, based on window type.
if strcmp(wintype,'CSHelpWindow')
    openCSHelpWindow(help_path, parent, csh_size, csh_location);
else
    % Otherwise, use the main Help window.
    web(help_path, '-helpbrowser');
end

function normal_path = normalize_path(path)
% Ensures that path uses the correct separator
% for the current platform.
%
if ispc
    normal_path = strrep(path, '/', filesep);
else
    normal_path = strrep(path, '\', filesep);
end


%--------------------------------------------------------------------------

function [inputArgs, csh_size, csh_location] = getInputArgs(originalInputs)

% init parameters
csh_size = [];
inputArgs = [];
csh_location = [];

i = 1;
while i <= length(originalInputs)
    if ~ischar(originalInputs{i})
       % avoid non character
       inputArgs{end+1} = originalInputs{i};
    elseif strcmp(originalInputs{i}, 'position')
        i = i + 1;
        if i > length(originalInputs)
            error('MATLAB:helpview:UnspecifiedPosition', 'Position not specified');
        elseif ~(length(originalInputs{i}) == 4)
            error('MATLAB:helpview:InvalidPosition', 'Position must be [left bottom width height]');
        else
            % [left bottom width height]
            scrsz = get(0,'ScreenSize');
            v = originalInputs{i};
            csh_size = [v(3) v(4)];
            % watch out for small screen size, otherwise use default
            if (scrsz(4)-v(2)-v(4)) > -1 
               csh_location = [v(1) (scrsz(4)-v(2)-v(4))];
            elseif (scrsz(4)-v(4)) > -1
               csh_location = [v(1) (scrsz(4)-v(4))]; 
            end
        end
    elseif strcmp(originalInputs{i}, 'size')
        i = i + 1;
        if i > length(originalInputs)
            error('MATLAB:helpview:UnspecifiedSize', 'Location not specified');
        else
            csh_size = originalInputs{i};
        end
    elseif strcmp(originalInputs{i}, 'location')
        i = i + 1;
        if i > length(originalInputs)
            error('MATLAB:helpview:UnspecifiedLocation', 'Location not specified');
        else
            csh_location = originalInputs{i};
        end
    else
        inputArgs{end+1} = originalInputs{i};
    end
    i = i + 1;
end

% validate size
if ~isempty(csh_size)
    if ~(length(csh_size) == 2)
            error('MATLAB:helpview:InvalidSize', 'Size must be [width height]'); 
    elseif min(csh_size) < 1
        error('MATLAB:helpview:InvalidSize', 'Size must be > 0');
    end
end

% validate location
if ~isempty(csh_location)
    if ~(length(csh_location) == 2)
        error('MATLAB:helpview:InvalidLocation', 'Location must be [x y]');
    elseif min(csh_location) < 0
        error('MATLAB:helpview:InvalidLocation', 'Location must be >= 0');
    end
end

%--------------------------------------------------------------------------

function openCSHelpWindow(path, parent, csh_size, csh_location)

import com.mathworks.mlservices.MLHelpServices;

drawnow;

if ~isempty(csh_size)
    % set size
    MLHelpServices.cshSetSize(csh_size(1), csh_size(2));
end

if ~isempty(csh_location)
    % set location
    MLHelpServices.cshSetLocation(csh_location(1), csh_location(2));
end

if isempty(parent)
    MLHelpServices.cshDisplayFile(normalize_path(path));
else
    if ishghandle(parent, 'figure')

        % store the last warning thrown
        [ lastWarnMsg lastWarnId ] = lastwarn;
        oldstate = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

        % We actually want the parent of the figure...
        figpeer = get(parent,'javaframe');
        
        warning(oldstate.state,'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
        % restore the last warning thrown
        lastwarn(lastWarnMsg, lastWarnId); 

    else
        figpeer = parent;
    end
    MLHelpServices.cshDisplayFile(figpeer, normalize_path(path));
end

% End of helpview.m
