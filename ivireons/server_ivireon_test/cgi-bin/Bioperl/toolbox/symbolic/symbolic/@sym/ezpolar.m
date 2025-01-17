function ezpolar(varargin)
% EZPOLAR Easy to use polar coordinate plotter.
%   EZPOLAR(f) plots the polar curve rho = f(theta) over the
%   default domain 0 < theta < 2*pi.
%
%   EZPOLAR(f,[a,b]) plots f for a < theta < b.
%
%   Examples
%       syms t
%       ezpolar(1 + cos(t))
%       ezpolar(cos(2*t))
%       ezpolar(sin(tan(t)))
%       ezpolar(sin(3*t))
%       ezpolar(cos(5*t))
%       ezpolar(sin(2*t)*cos(3*t),[0,pi])
%       ezpolar(1 + 2*sin(t/2))
%       ezpolar(1 - 2*sin(3*t))
%       ezpolar(sin(t)/t, [-6*pi,6*pi])
%
%       r = 100/(100+(t-1/2*pi)^8)*(2-sin(7*t)-1/2*cos(30*t));
%       ezpolar(r,[-pi/2,3*pi/2])
%
%  See also EZPLOT3, EZPLOT, EZSURF, PLOT, PLOT3, POLAR

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/05/10 20:10:14 $

switch nargin
case 1
   ezpolar(char(varargin{1}));
otherwise
    checkNoSyms(varargin(2:end));
    ezpolar(char(varargin{1}),varargin{2:end});
end

function checkNoSyms(args)
    if any(cellfun(@(arg)isa(arg,'sym'),args))
        error('symbolic:ezhelper:TooManySyms','Too many sym objects to plot.');
    end
