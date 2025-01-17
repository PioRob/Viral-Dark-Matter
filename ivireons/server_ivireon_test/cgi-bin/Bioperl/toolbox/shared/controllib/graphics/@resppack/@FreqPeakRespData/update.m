function update(cd,r)
%UPDATE  Data update method @FreqPeakRespData class

%  Author(s): John Glass
%  Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:18:23 $

% Get data of parent response
X = cd.Parent.Frequency;
Y = cd.Parent.Response;
nrows = length(r.RowIndex);
ncols = length(r.ColumnIndex);

% Compute Peak Response
Frequency = zeros(nrows, ncols);
PeakResp = zeros(nrows, ncols);
for ct=1:nrows*ncols
   Yabs = abs(Y(:,ct));
   indMax = find(Yabs==max(Yabs));
   indMax = indMax(end);
   Frequency(ct) = X(indMax);
   PeakResp(ct) = Y(indMax,ct);      
end

% Update data object
% REVISIT: simplify
cd.Frequency = Frequency;
cd.PeakResponse = PeakResp;
