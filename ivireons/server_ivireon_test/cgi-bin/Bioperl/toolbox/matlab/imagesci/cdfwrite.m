function cdfwrite(filename, varcell, varargin)
%CDFWRITE Write data to a CDF file.
% 
%   CDFWRITE(FILE, VARIABLELIST) writes out a CDF file whose name
%   is specified by FILE.  VARIABLELIST is a cell array of ordered
%   pairs, which are comprised of a CDF variable name (a string) and
%   the corresponding CDF variable value.  To write out multiple records
%   for a variable, put the variable values in a cell array, where each
%   element in the cell array represents a record.
%
%   CDFWRITE(..., 'PadValues', PADVALS) writes out pad values for given
%   variable names.  PADVALS is a cell array of ordered pairs, which
%   are comprised of a variable name (a string) and a corresponding 
%   pad value.  Pad values are the default value associated with the
%   variable when an out-of-bounds record is accessed.  Variable names
%   that appear in PADVALS must appear in VARIABLELIST.
%
%   CDFWRITE(..., 'GlobalAttributes', GATTRIB) writes the structure
%   GATTRIB as global meta-data for the CDF.  Each field of the
%   struct is the name of a global attribute.  The value of each
%   field contains the value of the attribute.  To write out
%   multiple values for an attribute, the field value should be a
%   cell array.
%
%   In order to specify a global attribute name that is illegal in
%   MATLAB, create a field called "CDFAttributeRename" in the 
%   attribute struct.  The "CDFAttribute Rename" field must have a value
%   which is a cell array of ordered pairs.  The ordered pair consists
%   of the name of the original attribute, as listed in the 
%   GlobalAttributes struct and the corresponding name of the attribute
%   to be written to the CDF.
%
%   CDFWRITE(..., 'VariableAttributes', VATTRIB) writes the
%   structure VATTRIB as variable meta-data for the CDF.  Each
%   field of the struct is the name of a variable attribute.  The
%   value of each field should be an mx2 cell array where m is the
%   number of variables with attributes.  The first element in the
%   cell array should be the name of the variable and the second
%   element should be the value of the attribute for that variable.
%
%   In order to specify a variable attribute name that is illegal in
%   MATLAB, create a field called "CDFAttributeRename" in the 
%   attribute struct.  The "CDFAttribute Rename" field must have a value
%   which is a cell array of ordered pairs.  The ordered pair consists
%   of the name of the original attribute, as listed in the 
%   VariableAttributes struct and the corresponding name of the attribute
%   to be written to the CDF.   If you are specifying a variable attribute
%   of a CDF variable that you are re-naming, the name of the variable in
%   the VariableAttributes struct must be the same as the re-named variable.
%
%   CDFWRITE(..., 'WriteMode', MODE) where MODE is either 'overwrite'
%   or 'append' indicates whether or not the specified variables or 
%   should be appended to the CDF if the file already exists.  The 
%   default is 'overwrite', indicating that CDFWRITE will not append
%   variables and attributes.
%
%   CDFWRITE(..., 'Format', FORMAT) where FORMAT is either 'multifile'
%   or 'singlefile' indicates whether or not the data is written out
%   as a multi-file CDF.  In a multi-file CDF, each variable is stored
%   in a *.vN file where N is the number of the variable that is
%   written out to the CDF.  The default is 'singlefile', which indicates
%   that CDFWRITE will write out a single file CDF.  When the 'WriteMode'
%   is set to 'Append', the 'Format' option is ignored, and the format
%   of the pre-existing CDF is used.
%
%   CDFWRITE(..., 'Version', VERSION) where VERSION is a string which 
%   specifies the version of the CDF library to use in writing the file.
%   The default option is to use the latest version of the library 
%   (which is currently version 3.1), and may be specified '3.0'.  The 
%   other available version is version 2.7 ('2.7').  Note that 
%   versions of MATLAB before R2006b will not be able to read files 
%   which were written with CDF versions greater than 3.0.
%
%
%   Notes:
%
%     CDFWRITE creates temporary files when writing CDF files.  Both the
%     target directory for the file and the current working directory
%     must be writeable.
%
%     CDFWRITE performance can be noticeably influenced by the file 
%     validation done by default by the CDF library.  Please consult
%     the CDFLIB package documentation for information on controlling
%     the validation process.
%
%
%   Examples:
%
%   % Write out a file 'example.cdf' containing a variable 'Longitude'
%   % with the value [0:360]:
%
%   cdfwrite('example', {'Longitude', 0:360});
%
%   % Write out a file 'example.cdf' containing variables 'Longitude'
%   % and 'Latitude' with the variable 'Latitude' having a pad value
%   % of 10 for all out-of-bounds records that are accessed:
%
%   cdfwrite('example', {'Longitude', 0:360, 'Latitude', 10:20}, ...
%            'PadValues', {'Latitude', 10});
%
%   % Write out a file 'example.cdf', containing a variable 'Longitude'
%   % with the value [0:360], and with a variable attribute of
%   % 'validmin' with the value 10:
%
%   varAttribStruct.validmin = {'Longitude' [10]};
%   cdfwrite('example', {'Longitude' 0:360}, ...
%            'VariableAttributes', varAttribStruct);
%
%   Please read the file cdfcopyright.txt for more information.
%
%   See also CDFREAD, CDFINFO, CDFEPOCH, CDFLIB.GETVALIDATE,
%   CDFLIB.SETVALIDATE.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.10 $  $Date: 2009/11/09 16:27:06 $

%
% Process arguments.
%

if (nargin < 2)
    error('MATLAB:cdfwrite:inputArgumentCount', ...
          'CDFWRITE requires at least two input arguments.')
end

% parse_inputs sorts out all of the input args.  Its return values:
%
% * args - an array of structs.  args.VarNames contains the names
% of the variables to be written to the CDF.  args.VarVals contains
% the corresponding values.  args.PadVals contains corresponding pad
% values.
% * isAppending - whether or not to delete this file or if we need to
% append to the file
% * isMultifile - whether or not to write out as a multi-file CDF
% * CDFversion - which version of the CDF library to use
% * varAttribStruct - a struct containing the variable attributes
% * globalAttribStruct - a struct containing the global CDF
% attributes
% * msg - an error message from parse_inputs that we pass on to the user.

[args, isAppending, isMultifile, CDFversion, varAttribStruct, globalAttribStruct, ...
 exception] = parse_inputs(varcell, varargin{:});

if (~isempty(exception.msg))
    error(exception.id, '%s', exception.msg)
end

%
% Create a proper filename for the CDF
%

% See if there is an extension
[pname, fname, ext] = fileparts(filename);

% If there is an extension, then remove it before passing it to CDFlib.
if (~isempty(ext))
    if (~isempty(strfind(ext, 'cdf')))
        filename = fullfile(pname, fname);
    end
end

%
% Call the underlying cdfwritec function which calls the CDFlib
%

cdfwritec(filename, args.VarNames, args.VarVals, args.PadVals,  ...
          globalAttribStruct, varAttribStruct, isAppending, ...
          isMultifile, CDFversion);

%%%
%%% Function parse_inputs
%%%

function [args, isAppending, isMultifile, CDFversion, varAttribStruct, ...
          globalAttribStruct, exception] = parse_inputs(varcell, varargin)

% Set default values
args.PadVals = {};
isAppending = 0;
isMultifile = 0;
varAttribStruct = struct([]);
globalAttribStruct = struct([]);
% The following value indicates no version preference.
CDFversion = -1.0;

exception.msg = '';
exception.id = '';

% First check that varcell meets all of our requirements
args.VarNames = {varcell{1:2:end}};
args.VarVals = {varcell{2:2:end}};
% Wrap the scalars non-empties in cell arrays.
for i = 1:length(args.VarVals)
    if ~isempty(args.VarVals{i}) && (ischar(args.VarVals{i}) || (numel(args.VarVals{i}) == 1))
        args.VarVals{i} = {args.VarVals{i}};    
    end
end

if length(args.VarNames) ~= length(args.VarVals)
    exception.msg = 'All variable names must have a corresponding variable value.';
    exception.id = 'MATLAB:cdfwrite:variableWithoutValue';
    return
end

% Check and make sure that all variable values are of the same
% datatype, but ignore empties
if ~isempty(args.VarVals)
    for i = 1:length(args.VarVals)
        a = args.VarVals{i};
        if iscell(a)
            nonEmpties = {a{~cellfun('isempty',a)}};
            if iscell(nonEmpties) && ~isempty(nonEmpties)
                dtype = class(nonEmpties{1});
                if ~all(cellfun('isclass',nonEmpties,dtype))
                    exception.msg = 'All record values for a given variable must be of the same type.';    
                    exception.id = 'MATLAB:cdfwrite:inconsistentRecordTypes';
                elseif ~all(cellfun(@rightSize, nonEmpties))
                    exception.msg = 'All record values must contain fewer than 2^32 bytes of data.';
                    exception.id = 'MATLAB:cdfwrite:tooMuchData';
                end
            end
        else
            % If it isn't a cell array, then it is an array and
            % all elements are of the same type.  This is a single
            % record value and must be placed in a cell array.
            if (~rightSize(args.VarVals{i}))
                exception.msg = 'All record values must contain fewer than 2^32 bytes of data.';
                exception.id = 'MATLAB:cdfwrite:tooMuchData';
            end
            args.VarVals{i} = {args.VarVals{i}};
        end
    end
end

args.PadVals = cell(1,length(args.VarNames));

% Parse arguments based on their number.
if (nargin > 0)
    
    paramStrings = {'padvalues'
                    'globalattributes'
                    'variableattributes'
                    'writemode'
                    'format'
                    'version'};
    
    % For each pair
    for k = 1:2:length(varargin)
        param = lower(varargin{k});
            
        if (~ischar(param))
            exception.msg = 'Parameter name must be a string.';
            exception.id = 'MATLAB:cdfwrite:paramNameNotString';
            return
        end
        
        idx = strmatch(param, paramStrings);
        
        if (isempty(idx))
            exception.msg = sprintf('Unrecognized parameter name "%s".', param);
            exception.id = 'MATLAB:cdfwrite:unrecognizedParam';
            return
        elseif (length(idx) > 1)
            exception.msg = sprintf('Ambiguous parameter name "%s".', param);
             exception.id = 'MATLAB:cdfwrite:ambiguousParam';
           return
        end
        
        switch (paramStrings{idx})
        case 'padvalues'
           padCell = varargin{k+1};
           % If we weren't passed an even pair, then a variable
           % name or value was left out.
           if rem(length(padCell), 2)
               exception.msg = ['Number of variables to write out with ' ...
                      'padding does not match number of pad values.'];
               exception.id = 'MATLAB:cdfwrite:paddingMismatch';
               return;
           end
           vars = {padCell{1:2:end}};
           padVals = {padCell{2:2:end}};
           % Check that vars are in the list above.
           if ~iscellstr(vars)
               exception.msg = 'All variable names must be strings.';
               exception.id = 'MATLAB:cdfwrite:varNameNotString';
               return
           end
           if ~all(ismember(vars, args.VarNames))
               exception.msg = ['Variables listed in the PadValues ' ...
                      'cell must be on the list of variables ' ...
                      'to save.'];
               exception.id = 'MATLAB:cdfwrite:notSavingVarForPadValue';
               return
           end
           for i = 1:length(padVals)
               padVal = padVals{i};
               if isnumeric(padVal) || ischar(padVal) || isa(padVal,'cdfepoch')
                   args.PadVals{strcmp(args.VarNames,vars{i})} = padVals{i};
               else
                   exception.msg = 'Pad values must be numbers, strings, or cdfepochs.';
                   exception.id = 'MATLAB:cdfwrite:badPadValue';
                   return
               end
           end
       case 'globalattributes'
           globalAttribStruct = varargin{k+1};
           if ~isstruct(globalAttribStruct)
               exception.msg = '''GlobalAttributes'' must be a struct.';
               exception.id = 'MATLAB:cdfwrite:globalAttributesNotStruct';
               return
           end
           attribs = fieldnames(globalAttribStruct);
           
           % If the global attribute isn't a cell, then stuff it in one.
           for i = 1:length(attribs)
               attribVal = globalAttribStruct.(attribs{i});
               if ~iscell(attribVal)
                   globalAttribStruct.(attribs{i}) = {attribVal};
               end
           end
        case 'variableattributes'
           varAttribStruct = varargin{k+1};
           if ~isstruct(varAttribStruct)
               exception.msg = '''VariableAttributes'' must be a struct.';
               exception.id = 'MATLAB:cdfwrite:variableAttributesNotStruct';
               return
           end
           attribs = fieldnames(varAttribStruct);
           
           % Check the VariableAttributes struct.
           for i = 1:length(attribs)
               % If the variable attribute isn't in a cell (because
               % it is scalar, then put it into a cell.
               attribVal = varAttribStruct.(attribs{i});
               s = size(attribVal);
               if ~iscell(attribVal)
                   varAttribStruct.(attribVal) = {attribVal};
               end
               % The variable attribute struct may have more than one
               % variable per attribute.  However, there must only be
               % one associated value of the attribute for each variable,
               % hence the 2.
               if (s(2) == 2)
                   % Transpose it because CDFlib reads the arrays column-wise.
                   varAttribStruct.(attribs{i}) = attribVal';   
               else
                   % We have ordered pairs.
                   varAttribStruct.(attribs{i}) = reshape(varAttribStruct.(attribs{i})(:),numel(varAttribStruct.(attribs{i})(:))/2, 2);
               end
               
%                % Don't forget to ignore the "CDFAttributeRename" attribute
%                completeSet = {args.VarNames{:} 'CDFAttributeRename'};
%                tmpVar = varAttribStruct.(attribs{i});
%                varsWithAttributes = {tmpVar{1,:}};
%                if ~all(ismember(varsWithAttributes, completeSet))
%                    exception.msg = ['Variables listed in the VariableAttributes ' ...
%                           'struct must be on the list of variables ' ...
%                           'to save.'];
%                    return
%                end               
           end
        case 'writemode'
            isAppending = varargin{k+1};
            if strcmpi(isAppending, 'overwrite')
                isAppending = 0;
            elseif strcmpi(isAppending, 'append')
                isAppending = 1;
            else
                exception.msg = '''WriteMode'' must be either  ''overwrite'' or ''append''';
                exception.id = 'MATLAB:cdfwrite:badWriteModeValue';
                return
            end
        case 'format'
            isMultifile = varargin{k+1};
            if strcmpi(isMultifile, 'singlefile')
                isMultifile = 0;
            elseif strcmpi(isMultifile, 'multifile')
                isMultifile = 1;
            else
                exception.msg = '''Format'' must be either  ''singlefile'' or ''multifile''';
                exception.id = 'MATLAB:cdfwrite:badFormatValue';
                return
            end
        case 'version'
            version = varargin{k+1};
            if ischar(version) && ...
                    (strcmp(version,'2.7') || strcmp(version,'3.0'))
                CDFversion = str2num(version);
            else
                exception.msg = '''Version'' must be either ''2.7'' or ''3.0''';
                exception.id = 'MATLAB:cdfwrite:badVersionValue';
                return
            end
        end  % switch
    end  % for
    
    % Do a sanity check on the sizes of what we are passing back
    if ~isequal(length(args.VarNames), length(args.VarVals), ...
                length(args.PadVals))
        exception.msg = 'Number of variable names, values, and pad values do not match.';
        exception.id = 'MATLAB:cdfwrite:sanityCheckMismatch';
        return    
    end
end  % if (nargin > 1)



function tf = rightSize(record)
% Check that CDF records and/or variables fit within signed 32-bit offsets.

% How many bytes does each element occupy in memory?
switch (class(record))
case {'uint8', 'int8', 'logical', 'char'}

    elementSize = 1;
    
case {'uint16', 'int16'}

    elementSize = 2;
    
case {'uint32', 'int32', 'single', 'cdfepoch'}

    elementSize = 4;
    
case {'uint64', 'int64', 'double'}
    
    elementSize = 8;
    
otherwise
    
    error('MATLAB:cdfwrite:unsupportedDatatype', ...
          'Unsupported variable datatype ''%s''.', class(record))
    
end

% Validate that the dataset/image will fit within 31-bit offsets.
max31 = double(intmax('int32'));

tf = (numel(record) * elementSize) <= max31;
