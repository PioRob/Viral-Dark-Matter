function h = ezplot3(varargin)
%EZPLOT3  Easy to use 3-d parametric curve plotter.
%   EZPLOT3(x,y,z) plots the spatial curve x = x(t), y = y(t),
%   and z = z(t) over the default domain 0 < t < 2*pi.
%
%   EZPLOT3(x,y,z,[tmin,tmax]) plots the curve x = x(t), y = y(t),
%   and z = z(t) over tmin < t < tmax.
%
%   EZPLOT3(x,y,z,'animate') or EZPLOT(x,y,z,[tminm,tmax],'animate')
%   produces an animated trace of the spatial curve.
%   
%   Examples
%      syms t
%      ezplot3(sin(t),cos(t),t)
%      ezplot3(sin(t),cos(t),t,[0,6*pi])
%      ezplot3(sin(3*t)*cos(t),sin(3*t)*sin(t),t,[0,12],'animate')
%      ezplot3((4+cos(1.5*t))*cos(t),(2+cos(1.5*t))*sin(t),sin(1.5*t),[0,4*pi])
%
%  See also EZPLOT, EZSURF, EZPOLAR, PLOT, PLOT3

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/05/10 20:10:13 $

clf;
% Change the first 3 input arguments to chars.
x = char(sym(varargin{1}));
y = char(sym(varargin{2}));
z = char(sym(varargin{3}));
checkNoSyms(varargin(4:end));
hh = ezplot3(x,y,z,varargin{4:end});
if nargout > 0
    h = hh;
end

function checkNoSyms(args)
    if any(cellfun(@(arg)isa(arg,'sym'),args))
        error('symbolic:ezhelper:TooManySyms','Too many sym objects to plot.');
    end
