function C = utArray2Cell(this,A)
% Converts array of uniformly-sized samples into cell array.
% The SampleSize value is used to infer the grid size. 

%   Author(s): P. Gahinet
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2005/12/22 18:14:26 $
if isempty(A)
   C = {};  return
end
SizeA = hdsGetSize(A);
SampleSize = this.SampleSize;
Ne = prod(SampleSize);
Ns = prod(SizeA)/Ne;

% Build cell array
if Ns==1
   % Optimizeation for single sample
   C = {hdsReshapeArray(A,SampleSize)};
else
   % General case
   C = cell(Ns,1);
   if Ns~=round(Ns)
      error('Array size not compatible with sample size')
   elseif this.GridFirst
      A = hdsReshapeArray(A,[Ns Ne]);
      for ct=1:Ns
         C{ct} = hdsReshapeArray(hdsGetSlice(A,{ct,':'}),SampleSize);
      end
      % Find out grid size
      idx = find(cumprod(SizeA)==Ns);
      if isempty(idx)
         GridSize = [1 1];
      else
         GridSize = SizeA(1:idx(1));
      end
   else
      A = hdsReshapeArray(A,[Ne Ns]);
      for ct=1:Ns
         C{ct} = hdsReshapeArray(hdsGetSlice(A,{':',ct}),SampleSize);
      end
      GridSize = SizeA(length(SampleSize)+1:end);
   end

   % Shape cell array
   GridSize = [GridSize ones(1,2-length(GridSize))];
   C = reshape(C,GridSize);
end