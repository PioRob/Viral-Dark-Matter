function m=dx_dy(processFcns,processSettings,m)
%PROCESSDX Applies processing functions and settings to a matrix.
%
% Syntax
%   
%   d = nnproc.dy_dx(processFcns,processSettings,m)
%
% Description
%
%   PROCESSDX(processFcns,processSettings,m1) takes:
%     processFcns - row cell array of N processing function names
%     processSettings - row cell array of N associated configurations
%     m - unprocessed NxQ matrix.
%   and returns the MxNxQ derivative of MxQ processed m with
%   respect to the NxQ unprocessed m.

% Copyright 2007-2010 The MathWorks, Inc.

[processFcns,processSettings] = nnproc.active_fcns(processFcns,processSettings);
if isnumeric(m)
  m = processMatrix(processFcns,processSettings,m);
else
  m = processCell(processFcns,processSettings,m);
end

%================================================
function d1=processMatrix(processFcns,processSettings,m)

[M,Q] = size(m);
d1 = eye(M);
d1 = d1(:,:,ones(1,Q));
m1 = m;

for i=length(processFcns):-1:1
  pf = processFcns{i};
  ps = processSettings{i};
  m2 = feval(pf,'reverse',m1,ps);
  di = feval(pf,'dx_dy',m2,m1,ps);
  
  N = size(m2,1);
  d2 = zeros(M,N,Q);
  for q=1:Q
    d2(:,:,q) = di(:,:,q) * d1(:,:,q);
  end
  
  m1 = m2; d1 = d2;
end

%================================================
function m=processCell(processFcns,processSettings,m)

[rows,cols] = size(m);
for i=1:rows
  for j=1:cols
    m{i,j} = processMatrix(processFcns,processSettings,m{i,j});
  end
end
