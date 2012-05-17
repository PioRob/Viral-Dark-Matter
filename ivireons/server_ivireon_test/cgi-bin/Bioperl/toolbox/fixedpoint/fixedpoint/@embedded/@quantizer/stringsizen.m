function n = stringsizen(q,s)
%STRINGSIZE Size of matrix of hex or binary string
%
%   D = STRINGSIZE(S) for M-by-N string matrix S, returns the two-element
%   row vector D = [M, N] containing the number of rows and columns
%   in the matrix. 
%
%   [M,N] = STRINGSIZE(S) returns the number of rows and columns in
%   separate output variables.

%   Thomas A. Bryan
%   Copyright 1999-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2007/12/10 21:33:18 $

error(nargoutchk(0,2,nargout,'struct'));

m = size(s,1);

if isempty(s)
  n = 0;
else
  [ri,ci] = find(s == 'i');
  if isempty(ci)
    % Real
    % Count the contiguous blocks of characters in the first row
    [r,c] = find(s ~= ' ' & s ~= 0);
    c = unique(c);
    n = sum(diff(c)~=1)+1;
  else
    % Complex
    % Count the number of i's in the first row.
    n = length(unique(ci));
  end
end

switch nargout
  case {0,1}
    varargout(1) = {[m n]};
  case 2
    varargout(1) = {m};
    varargout(2) = {n};
end
