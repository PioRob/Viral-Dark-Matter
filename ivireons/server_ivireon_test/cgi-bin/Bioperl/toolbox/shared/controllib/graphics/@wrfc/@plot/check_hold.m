function [this,HeldRespFlag,HeldGridFlag] = check_hold(this,ax,gridsize)
%CHECK_HOLD  Checks HOLD state of AX.

%  Author(s): P. Gahinet
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:29:16 $

HeldRespFlag = 0;
HeldGridFlag = 0;

if strcmp(get(ax,'NextPlot'),'replace')
   % Replace mode: clear supplied axes
   cla(ax)
else
   % Held axes
   p = gcr(ax); % REVISIT: for respplot only
   if isempty(p)
      % Held axes do not contain a valid response plot
      if prod(gridsize)>1
         % Cannot go from regular plot to multiple axes plot: issue warning and clear axes
         ctrlMsgUtils.warning('Controllib:plots:HoldNotSupported')
         set(ax,'NextPlot','replace','Visible','off')
         cla(ax)
      else
         % Carry over special grids (for, e.g., sgrid('new') + pzmap(sys))
         gridobj = findall(ax,'Tag','CSTgridLines');
         HeldGridFlag = ~isempty(gridobj);
         delete(gridobj)
      end    
   else
      % Held axes are associated with a valid response plot
      if strcmp(class(p),class(this)) & ...
            p.AxesGrid.Size(1)>=gridsize(1) & ...
            p.AxesGrid.Size(2)>=gridsize(2)
         % Add to existing response plot of the same type
         this = p;
         HeldRespFlag = 1;
      else
         ctrlMsgUtils.error('Controllib:plots:hold1')
      end
   end
end
      
   
   
   