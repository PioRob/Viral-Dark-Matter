function tf = iscodistributed( ~ )
%ISCODISTRIBUTED True for a codistributed array
%   TF = ISCODISTRIBUTED( X ) returns true for a codistributed array and false
%   otherwise
%   
%   Example:
%   spmd
%     N = 1000;
%     D = codistributed.ones( N );
%     t = iscodistributed( D ) % returns t = true
%     f = iscodistributed( N )   % returns f = false
%   end
%   f = iscodistributed( D ) % returns f = false - D is now distributed
%   
%   See also CODISTRIBUTED, DISTRIBUTED, ISDISTRIBUTED, ISREPLICATED.
%   


%   Copyright 2009-2010 The MathWorks, Inc.
% $Revision: 1.1.6.1 $   $Date: 2009/04/15 23:01:08 $

tf = true;

end