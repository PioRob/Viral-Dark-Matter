function n = numelements(x)
%NUMELEMENTS_FAST (STRINGNNDATA)

% Copyright 2010 The MathWorks, Inc.

s = size(x,1);
n = zeros(s,1);
for i=1:s
  n(i) = size(x{i,1},1);
end

