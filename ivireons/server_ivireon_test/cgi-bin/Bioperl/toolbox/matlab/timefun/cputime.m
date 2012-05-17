%CPUTIME CPU time in seconds.
%   CPUTIME returns the CPU time in seconds that has been used
%   by the MATLAB process since MATLAB started.  
%
%   For example:
%
%       t=cputime; your_operation; cputime-t
%
%   returns the cpu time used to run your_operation.            
% 
%   The return value may overflow the internal representation
%   and wrap around.
%
%   See also ETIME, TIC, TOC, CLOCK

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.8.4.4 $  $Date: 2005/06/21 19:39:41 $
%   Built-in function.

