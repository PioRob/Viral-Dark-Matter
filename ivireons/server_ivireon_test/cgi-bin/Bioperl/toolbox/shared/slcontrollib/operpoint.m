function op = operpoint(model)
%OPERPOINT Create operating point for Simulink model.
%
%   OP = OPERPOINT('sys') returns an object, OP, containing the operating 
%   point of a Simulink model, 'sys'. Use the object with the function 
%   LINEARIZE to create linearized models. 
%
%   To get and then view a formatted display of the operating point 
%   for a Simulink model run the commands:
%
%   >> op = operpoint('f14');
%   >> op 
%
%  The operating point object properties are:
%
%   STATES - describes the operating points of states in the Simulink
%   model. The States property is a vector of state objects that contains 
%   the operating point values of the states. There is one state object 
%   per block that has a state in the Simulink model. The States object 
%   has the following properties:
%        
%       Nx    - Number of states in the block. This property is read-only.
%       Block - Block that the states are associated with.
%       x     - Vector containing the values of states in the block.
%       Description - String describing the block.
%
%   INPUTS - Inputs is a vector of input objects that contains the input
%   levels at the operating point. There is one input object per root 
%   level inport block in the Simulink model. The Inputs object has the 
%   following properties: 
%
%       Block  - Inport block that the input vector is associated with.
%       PortWidth - Width of the corresponding inport.
%       u      - Vector containing the input level at the operating point.
%       Description - String describing the input.
%   
%   MODEL   - Specifies the name of the Simulink model that this operating
%             point object refers to.
%
%   TIME    - specifies the time at which any time-varying functions in the
%             model are evaluated.
%
%   See also LINEARIZE.

% Author(s): John Glass
% Copyright 1986-2010 The MathWorks, Inc.
% $Revision: 1.1.6.4.2.1 $ $Date: 2010/07/26 15:38:56 $

%% Create operating conditions object
op = opcond.OperatingPoint(model);

%% Update the operating condition constraint object
ModelParameterMgr = linearize.ModelLinearizationParamMgr.getInstance(model);
ModelParameterMgr.ModelParameters = struct('SimulationMode','normal');
ModelParameterMgr.ConfigSetParameters = createDisableWarningParameters(linutil);
ModelParameterMgr.loadModels
ModelParameterMgr.prepareModels('linearization');
try
   op = op.update;
catch E
   localRestoreParameterMgr(ModelParameterMgr)
   rethrow(E)
end
localRestoreParameterMgr(ModelParameterMgr)
end

function localRestoreParameterMgr(ModelParameterMgr)
%Helper to return parameter manager to original state
ModelParameterMgr.restoreModels;
ModelParameterMgr.closeModels;
end
