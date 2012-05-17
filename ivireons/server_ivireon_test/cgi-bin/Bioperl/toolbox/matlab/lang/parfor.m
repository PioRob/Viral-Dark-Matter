%PARFOR    Parallel FOR-loop
%   The general form of a PARFOR statement is:  
%
%       PARFOR loopvar = initval:endval
%           <statements>
%       END 
% 
%   MATLAB executes the loop body denoted by STATEMENTS for a vector of 
%   iterations specified by INITVAL and ENDVAL.  If you have Parallel 
%   Computing Toolbox, the iterations of STATEMENTS can execute in parallel
%   on separate MATLAB workers on your multi-core computer or computer 
%   cluster.  PARFOR differs from a traditional FOR loop in the following ways:
%
%     Iterations must be monotonically increasing integer values
%     Order in which the loop iterations are executed is not guaranteed  
%     Restrictions apply to the STATEMENTS in the loop body   
%   
%   PARFOR (loopvar = initval:endval, M); <statements>; END uses M to
%   specify the maximum number of MATLAB workers that will evaluate
%   STATEMENTS in the loop body.  M must be a nonnegative integer. By
%   default, MATLAB uses as many workers as it finds available.  When there
%   are no MATLAB workers available or M is zero, MATLAB will still execute
%   the loop body in an iteration independent order but not in parallel.  
%
%   In order to execute the iterations in parallel you must open a pool of 
%   MATLAB workers using MATLABPOOL.  MATLABPOOL is available with 
%   Parallel Computing Toolbox.  
%   
%   EXAMPLE
% 
%   Break three large eigenvalue computations across three computers or
%   cores:
% 	
%       matlabpool(3) 
%       parfor i = 1:3
%           c(:,i) = eig(rand(1000));
%       end
%     
%   See also for, matlabpool 

% Copyright 2008 The MathWorks, Inc.
% $Revision: 1.1.8.2 $  $Date: 2008/08/26 18:21:32 $
% Built-in function.
