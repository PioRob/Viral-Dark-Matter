function detectedAnyChange = CompareHelp(this, prevFilePath)
    % COMPAREHELP - compares contents of helpContainer against help in an M-file.
    % For any help that is deemed the same, COMPAREHELP clears the relevant
    % help content stored in helpContainer.
    
    % Copyright 2009 The MathWorks, Inc.
    error(nargchk(2,2,nargin,'struct'));
    
    if ~ischar(prevFilePath) || ~exist(prevFilePath, 'file')
        error('MATLAB:abstractHelpContainer:CompareHelp:InvalidInputFile', ...
            'Input is not a valid file path');
    end
    
    if this.isClassHelpContainer
        % Check if inherited methods/properties are included in help
        % container.
        if ~this.onlyLocalHelp
            error('MATLAB:abstractHelpContainer:CompareHelp:NonLocalHelpInContainer', ...
            'Cannot compare non-locally defined help such as inherited properties and methods defined outside the classdef M-file');
        else
            detectedAnyChange = compareForClass(this, prevFilePath);
        end
    else
        detectedAnyChange = compareForNonClass(this, prevFilePath);
    end
end

%% -----------------------------
function detectedAnyChange = compareForNonClass(this, prevFilePath)
    % COMPAREFORNONCLASS - This function is used to compare the help stored
    % in the helpContainer with the help in 'prevFilePath' and clear the
    % help if no change detected.
    prevHelp = help(prevFilePath);
    currHelp = this.getHelp;

    detectedAnyChange = hasHelpChanged(prevHelp, currHelp);
    
    if ~detectedAnyChange
        this.mainHelpContainer.clearHelp;
    end
end

%% -----------------------------
function detectedAnyChange = compareForClass(this, prevFilePath)
    % compareForClass - This function is used compare the help stored in a
    % ClassHelpContainer with the help in 'prevFilePath'
    prevClassInfo = getPreviousClassInfo(prevFilePath);

    % Check Main help for changes
    prevMainHelp = prevClassInfo.getHelp;
    currMainHelp = this.getHelp;
    mainHelpChanged = hasHelpChanged(prevMainHelp, currMainHelp);
    
    if ~mainHelpChanged
        this.mainHelpContainer.clearHelp;
    end

    % Check constructor help for changes, mark help container if any
    constructorHelpContainer = this.getConstructorHelpContainer;

    if ~isempty(constructorHelpContainer) 
        [constructorChanged, currConstructorHelp] = checkConstructorHelpUpdate(constructorHelpContainer, prevClassInfo, prevMainHelp);
        
        % In case current constructorHelp and main help are the same, clear the
        % main help to avoid duplication.
        if constructorChanged && ~hasHelpChanged(currConstructorHelp, currMainHelp)
            % Checking for constructor change to shield against extraneous call to
            % clearHelp in case no change is detected.
            this.mainHelpContainer.clearHelp;
        end
    else
        % E.g. MException has no constructor metadata
        constructorChanged = false;
    end

    % Check methods' help and mark changes
    methodIterator = this.getMethodIterator;
    methodInfoFcnHandle = @(metaData)prevClassInfo.getMethodInfo(metaData, ~this.onlyLocalHelp);

    methodHelpChanged = checkMemberHelpUpdates(methodIterator, methodInfoFcnHandle);

    % Check properties' help and mark changes
    propertyIterator = this.getPropertyIterator;

    propertyInfoFcnHandle = @(metaData)prevClassInfo.getPropertyInfo(metaData);

    propHelpChanged = checkMemberHelpUpdates(propertyIterator, propertyInfoFcnHandle);

    % Return results
    detectedAnyChange = constructorChanged || mainHelpChanged || methodHelpChanged || propHelpChanged;

end


%% -----------------------------
function prevClassInfo = getPreviousClassInfo(prevFilePath)
    % getPreviousClassInfo - extracts the class information needed to
    % extract the help comments for each of the class members.
    [parentPath, fileName] = fileparts(prevFilePath);

    [~, lastDir] = fileparts(parentPath);

    switch lastDir(1) 
    case '+'
        prevClassInfo = helpUtils.splitClassInformation(prevFilePath);
    case '@'
        prevClassInfo = helpUtils.splitClassInformation(parentPath);
    otherwise
        prevClassInfo = helpUtils.classInformation.simpleMCOSConstructor(fileName, ...
                        prevFilePath, true);
    end
end

%% -----------------------------
function [constructorChanged, currConstructorHelp] = checkConstructorHelpUpdate(constructorHelpContainer, prevClassInfo, prevMainClassHelp)
    % CHECKCONSTRUCTORHELPUPDATE - performs 2 functions:
    % 1. Returns the result of comparing the constructor help in the
    %    helpContainer with that of the previous classdef M-file.
    %
    % 2. If the constructor help is unchanged, then it clears the
    %    constructor's helpContainer contents.
    currConstructorHelp = constructorHelpContainer.getHelp;

    if ~isempty(currConstructorHelp) 
         prevConstructorInfo = prevClassInfo.getConstructorInfo(false);
        
        if ~isempty(prevConstructorInfo)
            % True if class had a defined constructor
            prevConstructorHelp = prevConstructorInfo.getHelp;
        else
            % Constructor would have main class help if none is provided
            prevConstructorHelp = prevMainClassHelp;
        end
        
        constructorChanged = hasHelpChanged(currConstructorHelp, prevConstructorHelp);
    else
        % If there is no help to compare to, then we don't report any
        % change.
        constructorChanged = false; 
    end

    if ~constructorChanged
        constructorHelpContainer.clearHelp;
    end

end

%% -----------------------------
function detectedHelpChange = checkMemberHelpUpdates(memberIterator, getInfo)
    % CHECKMEMBERHELPUPDATES - returns a boolean indicating whether there
    % were updates to any of the members' help.

    detectedHelpChange = false;

    while memberIterator.hasNext
        memberHelpContainer = memberIterator.next;

        classMemberInfo = getInfo(memberHelpContainer.metaData);

        % classMemberInfo will be empty for new methods/properties
        if ~isempty(classMemberInfo) && ~hasHelpChanged(classMemberInfo.getHelp, memberHelpContainer.getHelp)
            memberHelpContainer.clearHelp;
        else
            detectedHelpChange = true;
        end
    end

end

function result = hasHelpChanged(firstHelp, secondHelp)
    % HASHELPCHANGED - returns a boolean indicating whether the two help
    % strings are different.
    firstHelp = strtrim(firstHelp);
    secondHelp = strtrim(secondHelp);
    result = ~strcmp(firstHelp, secondHelp);
end