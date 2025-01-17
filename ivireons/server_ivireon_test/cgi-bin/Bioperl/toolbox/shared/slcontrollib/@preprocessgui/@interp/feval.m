function datasetout = feval(h,dataset)
%FEVAL
%
% Author(s): James G. Owen
% Revised:
% Copyright 1986-2006 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2006/06/20 20:28:53 $

data = dataset.Data;
t = dataset.Time;
s = size(data);

% remove blank rows
if strcmp(h.Rowremove,'on')
    if s(2)>1 && strcmp(h.Rowor,'off')
       I = all(isnan(data)')';
    elseif s(2)>1 && strcmp(h.Rowor,'on')
       I = any(isnan(data)')'; 
    else
       I = isnan(data);
    end
    data = data(~I,:);
    t = t(~I);
    
    % Reset size in case it has changed
    s = size(data);
end

% Interpolate NaNs

if strcmp(h.Interpolate,'on') && strcmp(h.Method,'zoh')
    for row = 2:s(1)
        I = find(isnan(data(row,:)));
        data(row,I) = data(row-1,I);
    end
elseif strcmp(h.Interpolate,'on') && strcmpi(h.Method,'linear')
    for col=1:s(2)
        I = ~isnan(data(:,col));
        data(:,col) = interp1(t(I),data(I,col),t);
    end
end    
    
datasetout = preprocessgui.dataset(data,t);