function r = plot(this,z,p,varargin)
%PLOT  Adds data to a response plot.
%
%   R = PLOT(PZPLOT,Z,P) adds the zero/pole data (Z,P) to the 
%   pole/zero plot PZPLOT.  The response is drawn immediately.
%
%   R = PLOT(PZPLOT,Z,P,'Property1',Value1,...) further specifies 
%   data properties such as sample time. See the @pzdata class for 
%   a list of valid properties.
%
%   R = PLOT(PZPLOT,Z,P,...,'nodraw') defers drawing.  An explicit 
%   call to DRAW is then required to show the new response.  This 
%   option is useful to render multiple responses all at once.

%  Author(s): Bora Eryilmaz, P. Gahinet
%  Copyright 1986-2007 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:22:54 $

if nargin<3
    ctrlMsgUtils.error('Controllib:general:ThreeOrMoreInputsRequired', ...
        'resppack.pzplot/plot','resppack.pzplot/plot');
end

% Look for 'nodraw' flag
nargs = length(varargin);
varargin(strcmpi(varargin,'nodraw')) = [];
DrawFlag = (length(varargin)==nargs);

% Check data
if ~iscell(z)
   z = {z(:)};
end
if ~iscell(p)
   p = {p(:)};
end
[ny,nu] = size(z);
[ny2,nu2] = size(p);
if nu2==1 & ny2==1
   p = repmat(p,ny,nu);
elseif ny2~=ny | nu2~=nu
    ctrlMsgUtils.error('Controllib:plots:Plot2','plot(PZPLOT,Z,P)','Z','P')
end

% Create new response
try
   r = this.addresponse(1:ny,1:nu,1);
catch ME
   throw(ME)
end

% Store data and set properties
r.Data.Zeros = z;
r.Data.Poles = p;
if length(varargin)
   set(r.Data,varargin{:})
end

% Draw new response
if DrawFlag
   draw(r)
end