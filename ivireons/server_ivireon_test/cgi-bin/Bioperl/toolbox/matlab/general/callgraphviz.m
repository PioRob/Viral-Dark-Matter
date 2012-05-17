function [out, graphVizOutput] = callgraphviz (varargin)
    %CALLGRAPHVIZ   Runs a basic version of the AT&T Graphviz programs
    %   STATUS = CALLGRAPHVIZ(ALGORITHM, ARG1,ARG2,...) will run a basic
    %   version of the Graphviz program specified in the string ALGORITHM (for
    %   instance, 'dot') with input arguments ARG1,ARG2,...
    %
    %   Example:
    %
    %   STATUS = CALLGRAPHVIZ('dot','-Tplain',DOTFILE_NAME,'-o',OUTFILE_NAME)
    %
    %   In the above, STATUS is the exit code returned by the specified
    %   Graphviz ALGORITHM, 'dot',  as reported by the 'system' command.
    %
    %   See also SYSTEM.

    %   This function is NOT DOCUMENTED for external users. It is to be
    %   released only in p-code. See Lego minutes for 2004/01/27.
    
    %   Copyright 2004-2007 The MathWorks, Inc.
    %   $Revision: 1.1.6.16 $ $Date: 2009/12/14 22:24:48 $
    
    algorithm = lower(varargin{1});
    if isempty(strmatch(algorithm,{'dot','neato','twopi'}))
        error('freeware:graphviz:UnrecognizedAlgorithmName',...
            'The Graphviz algorithm %s is not recognized.',algorithm);
    end
    
    algorithm = ['mw' algorithm];
    
    graphviz_cmd = fullfile(matlabroot, 'bin', computer('arch'), algorithm);
    
    % Separate arguments with a space
    for i=1:nargin
        % if the argument has spaces and is not a -Option or already quoted
        % then assume that it is a pathname with space and quote it.
        theArg = strtrim(varargin{i});
        if any(isspace(theArg)) && ~ismember(theArg(1),{'-','''','"'})
            varargin{i} = ['"',varargin{i},'"'];
        end
        varargin{i} = [' ' varargin{i}];
    end
    
    % Quote graphviz_cmd as it might contain spaces.
    
    [out,graphVizOutput]=system(['"' graphviz_cmd '"' varargin{2:end}]);
end
