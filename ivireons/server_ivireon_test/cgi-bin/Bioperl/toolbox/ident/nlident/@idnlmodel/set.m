function Out = set(nlsys, varargin)
%SET  Set properties of IDNLMODEL models.
%
%   SET(NLSYS, 'PropertyName', VALUE) sets the property 'PropertyName'
%   of the IDNLMODEL model NLSYS to the value VALUE. An equivalent syntax
%   is
%       NLSYS.PropertyName = VALUE
%
%   SET(NLSYS, 'Property1', Value1, 'Property2', Value2,...) sets multiple
%   IDNLMODEL property values with a single statement.
%
%   SET(NLSYS, 'Property') displays legitimate values for the specified
%   property of NLSYS.
%
%   SET(NLSYS) displays all properties of NLSYS and their admissible
%   values.
%
%   See also IDNLMODEL/GET.

% Copyright 2005-2008 The MathWorks, Inc.
% $Revision: 1.1.10.6 $ $Date: 2008/10/02 18:54:35 $

% Author(s): Qinghua Zhang

% Check input arguments.
ni = nargin;
no = nargout;
if ~isa(nlsys, 'idnlmodel')
    % Call built-in SET. Handles calls like set(gcf,'user',idnlarx).
    builtin('set', nlsys, varargin{:});
    return;
elseif (no && (ni > 2))
    ctrlMsgUtils.error('Ident:general:setOutputArg','idnlmodel/set','idnlmodel/set')
end

% Get public properties and their assignable values.
[AllProps, AsgnValues] = pnames(nlsys);

% Perform assignment.
if (ni == 1)
    % SET(NLSYS) or S = SET(NLSYS).
    if no
        Out = cell2struct(AsgnValues, AllProps, 1);
    else
        disp(idpvformat(AllProps, AsgnValues));
    end
elseif (ni == 2)
    % SET(NLSYS, 'Property') or STR = SET(NLSYS, 'Property').
    % Return admissible property value(s).
    try
        [Property, imatch] = nlpnmatchd(varargin{1}, AllProps, 18);
        if no
            Out = AsgnValues{imatch};
        else
            disp(AsgnValues{imatch});
        end
    catch E
        throw(E)
    end
else
    % SET(NLSYS, 'Prop1', Value1, ...).
    sysname = inputname(1);
    if isempty(sysname)
        ctrlMsgUtils.error('Ident:general:setFirstInput','idnlmodel/set')
    elseif (rem(ni-1, 2) ~= 0)
        ctrlMsgUtils.error('Ident:general:CompletePropertyValuePairs',upper(class(nlsys)),'idnlmodel/set')
    end
    
    % Get read-only properties.
    ReadonlyProps = pnames(nlsys, 'readonly');
    
    % Match specified property names against list of public properties.
    % Include all properties to appropriately detect multiple matches.
    try
        for i = 1:2:ni-1
            varargin{i} = nlpnmatchd(varargin{i}, AllProps, 18);
            % Note: if the i:th property name does not uniquely match an item
            % of AllProps, the error generated by nlpnmatchd is caught here.
            
            % Check if varargin{i} is settable.
            if ismember(varargin{i}, ReadonlyProps)
                ctrlMsgUtils.error('Ident:general:readOnlyProp',varargin{i},upper(class(nlsys)))
            end
        end
        nlsys = pvset(nlsys, varargin{:});
    catch E
        throw(E)
    end
    
    % Assign NLSYS in caller's workspace.
    assignin('caller', sysname, nlsys);
end

% FILE END