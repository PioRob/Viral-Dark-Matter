function [m,i,j,wasCell] = nncell2mat(c)
%NNCELL2MAT Combines NN cell data into a matrix.
%
% [Y,i,j] = <a href="matlab:doc nncell2mat">nncell2mat</a>(X) takes neural network cell data, and returns it
% as a single matrix.
%
% Also returned are the  matrix row sizes i and column sizes j.
% These row and column sizes can be used to reconstruct the original cell
% array with MAT2CELL.
%
% Here neural network cell data is converted to a matrix and back.
%
%   c = {<a href="matlab:doc rands">rands</a>(2,3) <a href="matlab:doc rands">rands</a>(2,3); <a href="matlab:doc rands">rands</a>(5,3) <a href="matlab:doc rands">rands</a>(5,3)};
%   [m,i,j] = <a href="matlab:doc nncell2mat">nncell2mat</a>(c)
%   c3 = mat2cell(m,i,j)

% Copyright 2010 The MathWorks, Inc.

if iscell(c)
  wasCell = true;
  numElements = numel(c);
  if numElements == 0
    m = [];
    i = [];
    j = [];
  elseif numElements == 1
    m = c{1};
    [i,j]=size(m);
  else
    ts = numtimesteps(c);
    q = numsamples(c);
    n = numsignals(c);
    i = numelements(c);
    j = zeros(1,ts)+q;
    rows = cell(n,1);
    for k=1:n
      rows{k} = cat(2,c{k,:});
    end
    m = cat(1,rows{:});
  end
else
  wasCell = false;
  m = c;
  i = [];
  j = [];
end

