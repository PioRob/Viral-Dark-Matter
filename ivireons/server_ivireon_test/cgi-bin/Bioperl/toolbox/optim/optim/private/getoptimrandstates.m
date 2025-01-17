function [problemStruct, err] = getoptimrandstates(problemStruct,hashProb)
%GETOPTIMRANDSTATES get states of random number generator for solvers
%
%   Private to OPTIMTOOL

%   Copyright 2007-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2010/05/10 17:32:10 $

err = '';
% Update or create the appdata structure before getting it
setoptimrandstates(problemStruct,hashProb,false);
if isappdata(0,'optim_rand_states_struct')
    optimSolversRandStates =  getappdata(0,'optim_rand_states_struct');
else % random states are not available; return
    return;
end

problemStruct.rngstate = [];

switch problemStruct.solver
    case 'ga'
         if optimSolversRandStates.ga.garandchoice
            problemStruct.rngstate = optimSolversRandStates.ga.rngstate;
         end
    case 'gamultiobj'
         if optimSolversRandStates.gamultiobj.gamultiobjrandchoice
            problemStruct.rngstate = optimSolversRandStates.gamultiobj.rngstate;
        end
    case 'patternsearch'
         if optimSolversRandStates.patternsearch.patternsearchrandchoice
            problemStruct.rngstate = optimSolversRandStates.patternsearch.rngstate;
        end
    case 'simulannealbnd'
         if optimSolversRandStates.simulannealbnd.simulannealbndrandchoice
            problemStruct.rngstate = optimSolversRandStates.simulannealbnd.rngstate;
        end
end
