function a = alim(arg1, arg2)
%ALIM Alpha limits.
%   AL = ALIM             gets the alpha limits of the current axes.
%   ALIM([AMIN AMAX])     sets the alpha limits.
%   ALMODE = ALIM('mode') gets the alpha limits mode.
%   ALIM(mode)            sets the alpha limits mode.
%                            (mode can be 'auto' or 'manual')
%   ALIM(AX,...)          uses axes AX instead of current axes.
%
%   ALIM sets or gets the Alim or AlimMode property of an axes.
%
%   See also ALPHA, ALPHAMAP, CAXIS, COLORMAP.
 
%   Copyright 1984-2005 The MathWorks, Inc. 
%   $Revision: 1.5.4.2 $  $Date: 2008/05/23 15:35:18 $

if nargin == 0
  a = get(gca,'alim');
else
  if isscalar(arg1) && ishghandle(arg1,'axes')
    ax = arg1;
    if nargin==2
      val = arg2;
    else
      a = get(ax,'alim');
      return
    end
  else
    if nargin==2
      error('MATLAB:alim:WrongNumberArguments', 'Wrong number of arguments')
    else
      ax = gca;
      val = arg1;
    end
  end
    
  if ischar(val)
    if(strcmp(val,'mode'))
      a = get(ax,'alimmode');
    else
      set(ax,'alimmode',val);
    end
  else
    set(ax,'alim',val);
  end
end
