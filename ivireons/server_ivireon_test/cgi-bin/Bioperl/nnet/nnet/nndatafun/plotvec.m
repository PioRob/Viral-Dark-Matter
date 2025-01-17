function hh = plotvec(x,c,m)
%PLOTVEC Plot vectors with different colors.
%
%  <a href="matlab:doc plotvec">plotvec</a>(X,C,M) takes an SxQ matrix X, a row vector of Q color
%  coordinates C, and an optional marker type M (default = '+'), and plots
%  each ith column vector in X with marker M, using the ith value in C
%  as the color coordinate.
%  
%  <a href="matlab:doc plotvec">plotvec</a>(X) uses the the indices of the columns in X as the color
%  coordinates.
%  
%  For example, here is a plot of four 2-element vectors.
%
%    x = [0 1 0.5 0.7; -1 2 0.5 0.1];
%    c = [1 2 3 4];
%    <a href="matlab:doc plotvec">plotvec</a>(x,c)

% Mark Beale, 12-15-93
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.8.2 $  $Date: 2010/04/24 18:08:32 $

if nargin < 1,nnerr.throw('Not enough input arguments.'); end

% VECTORS
[xr,xc] = size(x);
if xr < 2
  x = [x; zeros(2-xr,xc)];
  xr = 2;
end

% COLORS
if nargin == 1
  c = [0:(xc-1)]/(xc-1);
end
map = colormap;
[mapr,mapc] = size(map);
mapr = mapr-1;
cc = map(round((c-min(c))*(mapr-1)/max(c))+1,:);

% MARKER
if nargin < 3
  m = '+';
end

hold on
H = zeros(1,xc);
minx = min(x,[],2);
maxx = max(x,[],2);
difx = maxx-minx;
minx = minx-difx*0.05;
maxx = maxx+difx*0.05;

% 2-D PLOTTING
if xr == 2
  for i=1:xc
    h = plot(x(1,i),x(2,i),m);
  set(h,'color',cc(i,:))
  H(i) = h;
  end
  
% 3-D PLOTTING
else
  for i=1:xc
    h = plot3(x(1,i),x(2,i),x(3,i),m);
  set(h,'color',cc(i,:))
  H(i) = h;
  end
end

set(gca,'box','on')
hold off
if nargout == 1, hh = H; end
set(gca,'color',[0 0 0]+0.5)
