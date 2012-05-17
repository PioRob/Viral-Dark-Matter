function OK = jobStateIsAfter(currentState, desiredState)
; %#ok Undocumented
%jobStateIsAfter 
%
%  OK = jobStateIsAfter(currentState, desiredState)

%  Copyright 2008 The MathWorks, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2008/10/02 18:40:17 $ 

OK = distcomp.pJobStateComparison(@gt, currentState, desiredState);