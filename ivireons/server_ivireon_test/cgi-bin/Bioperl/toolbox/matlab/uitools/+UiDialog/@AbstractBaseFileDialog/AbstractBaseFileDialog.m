classdef AbstractBaseFileDialog < UiDialog.AbstractDialog
% $Revision: 1.1.6.9 $  $Date: 2010/03/31 18:26:30 $
% Copyright 2006-2009 The MathWorks, Inc.
    %%%%%%%%%%%%%%%%%%%
    % ALL PUBLIC PROPERTIES
    %%%%%%%%%%%%%%%%%%%
    properties
        InitialPathName = '';
    end
    
    % Consider moving this to AbstractDialog
    properties
        Title = '';
    end

    %%%%%%%%%%%%%%%%%%%
    % ALL ABSTRACT METHODS
    %%%%%%%%%%%%%%%%%%%
    methods(Abstract=true)
        show(obj)
    end

    %%%%%%%%%%%%%%%%%%%%
    % ALL SET and GET METHODS
    %%%%%%%%%%%%%%%%%%%%
    methods
        %Error checking for the start path
        function set.InitialPathName(obj,iStartPath)
            if ~isempty(iStartPath)
                iPath = checkString(obj, iStartPath, 'InitialPathName');
                iPath = PathParser(obj,iPath);
                obj.InitialPathName = iPath;
            else
                obj.InitialPathName = pwd;
            end
        end
        
        %Error checking for Title property
        function obj = set.Title(obj,v)
            if ~isempty(v)
                obj.Title = xlate(checkString(obj, v, 'Title'));
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%
    % PRIVATE/PROTECTED METHODS
    %%%%%%%%%%%%%%%%%%%%%%%
    methods (Access='protected')
        % Initialize the properties.
        function initialize(obj)
            % disp I_AbstractBaseFileDialog
            obj.InitialPathName = pwd;
        end
        
               
        %For objects whose peers have asynchronous show methods, where we block
        %MATLAB and wait for callbacks, we need to clear the callbacks
        %at the end of the show to ensure that the destructor is
        %called. Only those objects which have java references holding
        %on to matlab references and matlab references holding on to
        %java references need to implement this method. Others can
        %leave the body empty.
        function dispose(obj)
            unblockMATLAB(obj)
        end
       
        % Sets the path using the cd function and takes care of all
        % platforms. The initial directory to be set on the java peer is
        % determined in MATLAB code using the CD function since it can
        % handle special paths like ../.. , ~ , etc. Note that the isdir
        % function only determines if a given directory is a valid
        % directory. However, we need to rely on CD to convert special
        % characters to a full meaningful string directory name. 
        function full = PathParser(obj,v)
            if (isdir(v))
                nameconflictwarning = warning('off','MATLAB:dispatcher:nameConflict');
                pathwarning=warning('off','MATLAB:dispatcher:pathWarning');
                onCleanup(@() warnGuard(obj,pathwarning,nameconflictwarning));
                try
                    cur = cd(v);
                    full = cd(cur);
                catch ex
                    newEx = MException(ex.identifier, 'Invalid directory to operate on');
                    newEx.addCause(ex);
                    rethrow(newEx);
                end
            else
                full = pwd;
            end
        end
        
        function warnGuard(~,pathwarning,nameconflictwarning)
            warning(pathwarning);
            warning(nameconflictwarning);
        end
        % Check to see if the non-empty input variable is really a string;
        % if not, error out and tell the user which variable is bad.
        function stringout = checkString(obj, stringin, varName)
            if isempty(stringin)
                stringout = stringin;
                return;
            end
            
            stringsz = size(stringin);
            if ~(ischar(stringin) && isvector(stringin) && stringsz(1) == 1)
                error('MATLAB:AbstractBaseFileDialog:BadStringArgument',...
                    '%s must be a string.', varName)
            end
            stringout = stringin;
        end % checkString
        
        function bool = isValidFieldName(obj,iFieldName)
            switch(iFieldName)
                case {'InitialPathName', 'Title'}
                    bool = true;
                otherwise
                    bool = false;
            end
        end
        
       
    end
end

