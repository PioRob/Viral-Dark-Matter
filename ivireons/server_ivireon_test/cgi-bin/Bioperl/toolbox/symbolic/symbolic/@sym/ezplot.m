function hh = ezplot(f,varargin)
%EZPLOT Easy to use function plotter.
%   EZPLOT(f) plots the expression f = f(x) over the default
%   domain -2*pi < x < 2*pi.
%
%   EZPLOT(f, [a,b]) plots f = f(x) over a < x < b and
%
%   For implicitly defined functions, f = f(x,y)
%   EZPLOT(f) plots f(x,y) = 0 over the default domain
%   -2*pi < x < 2*pi and -2*pi < y < 2*pi
%   EZPLOT(f, [xmin,xmax,ymin,ymax]) plots f(x,y) = 0 over
%   xmin < x < xmax and  ymin < y < ymax.
%   EZPLOT(f, [a,b]) plots f(x,y) = 0 over a < x < b and a < y < b.
%   If f is a function of the variables u and v (rather than x and y), then
%   the domain endpoints a, b, c, and d are sorted alphabetically. Thus,
%   EZPLOT(u^2 - v^2 - 1,[-3,2,-2,3]) plots u^2 - v^2 - 1 = 0 over
%   -3 < u < 2, -2 < v < 3.
%
%   EZPLOT(x,y) plots the parametrically defined planar curve x = x(t)
%   and y = y(t) over the default domain 0 < t < 2*pi.
%   EZPLOT(x,y, [tmin,tmax]) plots x = x(t) and y = y(t) over
%   tmin < t < tmax.
%
%   EZPLOT(f, [a,b], FIG}, EZPLOT(f, [xmin,xmax,ymin,ymax], FIG), or
%   EZPLOT(x,y, [tmin,tmax], FIG) plots the given function over the
%   specified domain in the figure window FIG.
%
%   Examples:
%     syms x y t
%     ezplot(cos(x))
%     ezplot(cos(x), [0, pi])
%     ezplot(x^2 - y^2 - 1)
%     ezplot(x^2 + y^2 - 1,[-1.25,1.25],3); axis equal
%     ezplot(1/y-log(y)+log(-1+y)+x - 1)
%     ezplot(x^3 + y^3 - 5*x*y + 1/5,[-3,3])
%     ezplot(x^3 + 2*x^2 - 3*x + 5 - y^2)
%     ezplot(sin(t),cos(t))
%     ezplot(sin(3*t)*cos(t),sin(3*t)*sin(t),[0,pi])

%   Copyright 1993-2010 The MathWorks, Inc.

switch length(varargin)
case 0
   % ezplot(f) or ezplot(f(x,y) = 0) -> use default setting.
   h = ezplot(char(f));
case 1
   % ezplot(x,y)
   y = varargin{1};
   if length(y) == 1
      h = ezplot(char(f),char(y));
   % ezplot(f(x,y) = 0,[xmin,xmax,ymin,ymax])
   elseif isa(y,'sym')
       error('symbolic:ezhelper:TooManySyms','Too many sym objects to plot.');
   elseif length(y) == 4
      h = ezplot(char(f),[y(1) y(2)],[y(3) y(4)]);
   else
   % ezplot(f,[xmin,ymin]) covered in the default setting.
      h = ezplot(char(f),varargin{:});
   end
case 2
   % ezplot(x,y,domain)
   y = varargin{1};
   dom = varargin{2};
   checkNoSyms(varargin(2));
   if (length(y) == 1) && (length(dom) > 1)
      h = ezplot(char(f),char(y),dom);
   else
   % ezplot(f,xmin,ymin), ezplot(f,[xmin,xmax],fig), or 
   % ezplot(f(x,y) = 0,[xmin,xmax],[ymin,ymax])
      h = ezplot(char(f),varargin{:});
   end
otherwise
   y = varargin{1};
   checkNoSyms(varargin(2:end));
   h = ezplot(char(f),char(y),varargin{2:end});
end
if nargout > 0
   hh = h;
end

function checkNoSyms(args)
    if any(cellfun(@(arg)isa(arg,'sym'),args))
        error('symbolic:ezhelper:TooManySyms','Too many sym objects to plot.');
    end

