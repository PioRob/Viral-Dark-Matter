function configure(this,varargin)
% Reconfigures editor when configuration or target changes

%   Copyright 1986-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.7 $  $Date: 2010/05/10 16:59:10 $
if strcmp(this.Visible,'on')
   [L,idxL] = getL(this);
   C = this.GainTargetBlock;
   % Update title
   if isempty(L.Name) || strcmp(L.Name,L.Identifier)
      this.Axes.Title = sprintf('Bode Editor for %s',L.Identifier);
   else
      this.Axes.Title = sprintf('Bode Editor for %s (%s)',L.Name,L.Identifier);
   end
   CLView = this.clview(this.LoopData,'default');
   this.ClosedLoopView = CLView;
   % Updates editor's dependency list
   Clist = getClosedLoopModel(this.LoopData.Plant,...
      CLView.Input,CLView.Output,[]); % which C's this loop depends on
   this.Dependency = [getDependency(this); this.Loopdata.C(Clist)]; 
   
   % Initialize Targets
   this.initializeCompTarget;
   
   % Turn on multi-model characteristics
   ClosedLoopOn = strcmp(this.ClosedLoopVisible,'on');
   if isUncertain(this.LoopData.Plant) && ClosedLoopOn
       % Enable Multi Model Menu
       setmenu(this,'on','multiplemodel')
       % If not visible show menu
       if ~this.UncertainBounds.isVisible
           this.UncertainBounds.Visible = 'on';
           this.update;
       end
   else
       % Disable Multi Model Menu
       setmenu(this,'off','multiplemodel')
       this.UncertainBounds.Visible = 'off';
   end
   
end

