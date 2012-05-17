function optimoptions
%OPTIMOPTIONS displays options for the Optimization Toolbox.
%
%   This function displays option names and values for the Optimization Toolbox
%   used by OPTIMSET. 
%
%   OPTIMOPTIONS with no input arguments and no output arguments displays
%   all option names and their possible values, with defaults shown in {}
%   when the default is the same for all functions that use that option.

%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.10.4 $  $Date: 2009/09/23 14:02:17 $

% Future options (to be implemented):
%
%ActiveConstrTol - The tolerance used to determine which constraints are
%                  active for the interior-point methods at algorithm
%                  end [ positive scalar ]
%NoStopIfFlatInfeas - Tightens a stopping condition in FMINCON medium scale, 
%                     requiring that the iterate be feasible in addition to 
%                     the objective being flat [ on | {off} ] 
%PhaseOneTotalScaling - Also scales the constraints of auxiliary LP that finds
%                       initial feasible solution in private function QPSUB
%                       instead of only scaling the constraints of the original
%                       problem [ on | {off} ]
%Preconditioner - Alternative preconditioning function for PCG [ function ]
%TolGradCon: - Tolerance to determine convergence to infeasible stationary point of 
%              constraint violation [ positive scalar | {1e-6} ]

% This list only includes the options not in MATLAB; see optimset for the rest
fprintf('              Algorithm: [ active-set | interior-point | levenberg-marquardt | sqp | ...\n');
fprintf('                           trust-region-dogleg | trust-region-reflective ]\n');
fprintf(' AlwaysHonorConstraints: [ none | {bounds} ]\n');
fprintf('         BranchStrategy: [ mininfeas | {maxinfeas} ]\n');
fprintf('        DerivativeCheck: [ on | {off} ]\n');
fprintf('            Diagnostics: [ on | {off} ]\n');
fprintf('          DiffMaxChange: [ positive scalar | {1e-1} ]\n');
fprintf('          DiffMinChange: [ positive scalar | {1e-8} ]\n');
fprintf('            FinDiffType: [ {forward} | central ]\n');
fprintf('      GoalsExactAchieve: [ positive scalar | {0} ]\n');
fprintf('             GradConstr: [ on | {off} ]\n');
fprintf('                GradObj: [ on | {off} ]\n');
fprintf('                HessFcn: [ function | {[]} ]\n');
fprintf('                Hessian: [ user-supplied | bfgs | lbfgs | fin-diff-grads | on | off ]\n');
fprintf('               HessMult: [ function | {[]} ]\n');
fprintf('            HessPattern: [ sparse matrix | {sparse(ones(numberOfVariables))} ]\n');
fprintf('             HessUpdate: [ dfp | steepdesc | {bfgs} ]\n');
fprintf('       InitBarrierParam: [ positive scalar | {0.1} ]\n');
fprintf('        InitialHessType: [ identity | {scaled-identity} | user-supplied ]\n');
fprintf('      InitialHessMatrix: [ scalar | vector | {[]} ]\n');
fprintf('  InitTrustRegionRadius: [ positive scalar | {sqrt(numberOfVariables)} ]\n');
fprintf('               Jacobian: [ on | {off} ]\n');
fprintf('              JacobMult: [ function | {[]} ]\n');
fprintf('           JacobPattern: [ sparse matrix | {sparse(ones(Jrows,Jcols))} ]\n');
fprintf('             LargeScale: [ on | off ]\n');
fprintf('     LevenbergMarquardt: [ {on} | off ]\n');
fprintf('         LineSearchType: [ cubicpoly | {quadcubic} ]\n');
fprintf('               MaxNodes: [ positive scalar | {1000*numberOfVariables} ]\n');
fprintf('             MaxPCGIter: [ positive scalar | {max(1,floor(numberOfVariables/2))} ]\n');
fprintf('          MaxProjCGIter: [ positive scalar | {2*(numberOfVariables-numberOfEqualities)} ]\n');
fprintf('             MaxRLPIter: [ positive scalar | {100*numberOfVariables} ]\n');
fprintf('             MaxSQPIter: [ positive scalar | {10*max(numberOfVariables,numberOfInequalities+numberOfBounds)} ]\n');
fprintf('                MaxTime: [ positive scalar | {7200} ]\n');
fprintf('          MeritFunction: [ singleobj | {multiobj} ]\n');
fprintf('              MinAbsMax: [ positive scalar | {0} ]\n');
fprintf('    NodeDisplayInterval: [ positive scalar | {20} ]\n');
fprintf('     NodeSearchStrategy: [ df | {bn} ]\n');
fprintf('       NonlEqnAlgorithm: [ {dogleg} | lm | gn ]\n');
fprintf('         ObjectiveLimit: [ scalar | {-1e20} ]\n');
fprintf('       PrecondBandWidth: [ positive scalar | 0 | Inf ]\n');
fprintf('         RelLineSrchBnd: [ positive scalar | {[]} ]\n'); 
fprintf(' RelLineSrchBndDuration: [ positive scalar | {1} ]\n'); 
fprintf('           ScaleProblem: [ none | obj-and-constr | jacobian ]\n');
fprintf('                Simplex: [ on | {off} ]\n');
fprintf('    SubproblemAlgorithm: [ cg | {ldl-factorization} ]\n');
fprintf('                 TolCon: [ positive scalar ]\n');
fprintf('              TolConSQP: [ positive scalar | {1e-6} ]\n');
fprintf('                 TolPCG: [ positive scalar | {0.1} ]\n');
fprintf('              TolProjCG: [ positive scalar | {1e-2} ]\n');
fprintf('           TolProjCGAbs: [ positive scalar | {1e-10} ]\n');
fprintf('              TolRLPFun: [ positive scalar | {1e-6} ]\n');
fprintf('            TolXInteger: [ positive scalar | {1e-8} ]\n');
fprintf('               TypicalX: [ vector | {ones(numberOfVariables,1)} ]\n');
fprintf('            UseParallel: [ always | {never} ]\n');


