function [X,Y] = move(Constr, action, X, Y, X0, Y0)
%MOVE  Moves constraint
%
%   [X0,Y0] = CONSTR.MOVE('init',X0,Y0) initialize the move. The
%   pointer may be slightly moved to sit on the constraint edge
%   and thus eliminate distortions due to patch thickness.
%
%   [X,Y] = CONSTR.MOVE('restrict',X,Y,X0,Y0) limits the displacement
%   to locations reachable by CONSTR.
%
%   STATUS = CONSTR.MOVE('update',X,Y,X0,Y0) moves the constraint.
%   For constraints indirectly driven by the mouse, the update is
%   based on a displacement (X0,Y0) -> (X,Y) for a similar constraint
%   initially sitting at (X0,Y0).

%   Author(s): P. Gahinet, Bora Eryilmaz
%   Copyright 1986-2009 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:32:24 $

% RE: Incremental move is not practical because the constraint cannot
%     track arbitrary mouse motion (e.g., enter negative gain zone)

hGroup  = Constr.Elements;
HostAx  = handle(hGroup.Parent);
XUnits  = Constr.xDisplayUnits;
YUnits  = Constr.yDisplayUnits;
Ylinabs = strcmp(YUnits, 'abs') & strcmp(HostAx.Yscale, 'linear');

switch action
    case 'init'
        % If the mouse is selecting this constraint, move pointer to ...
        HostFig = HostAx.Parent;
        hChildren = hGroup.Children;
        Tags = get(hChildren,'Tag');
        idx = strcmp(Tags,'ConstraintPatch');
        if hChildren(idx) == hittest(HostFig)
            % X = unitconv(Constr.OriginPha, 'deg', XUnits);
            % Y = unitconv(0, 'dB', YUnits);
            % Move pointer to new (X0,Y0)
            moveptr(HostAx, 'init')
            moveptr(HostAx, 'move',X,Y);
        end
        
        % Model is
        % Origin = -180 + 360k, k = ...,-1,0,1,... (in deg)
        % Save initial constraint origin data
        Constr.AppData = struct('Origin0', unitconv(Constr.OriginPha,Constr.Data.getData('xUnits'),'deg'));
        
    case 'restrict'
        % Restrict displacement Y0 -> Y to account for constraint.
        if Ylinabs
            Y = max(Y, 1e-3*max(HostAx.Ylim));  % prevent negative gain
        end
        
    case 'update'
        % Constraint origin should sit at -180 + 360k (in deg) for some k,
        % so that the initial origin is closest to the mouse position.
        dX = unitconv(X-X0, XUnits, 'deg') + Constr.AppData.Origin0;
        sgnPhaOrig = (dX >= 0) - (dX < 0);
        
        % Update phase margin origin (in deg)
        Constr.OriginPha = unitconv(sgnPhaOrig * (abs(dX) + 180 - rem(abs(dX),360)),'deg',Constr.Data.getData('xUnits'));
        
        % Update graphics and notify observers
        update(Constr)
        
        % Status
        Origin0 = unitconv(Constr.AppData.Origin0, 'deg', XUnits);
        Origin  = unitconv(Constr.OriginPha, 'deg', XUnits);
        LocStr = sprintf('Closed-loop peak gain requirement moved from %0.3g to %0.3g %s.', Origin0, Origin, XUnits);
        X = sprintf('Move requirement to desired location and release the mouse.\n%s',LocStr);
        
    case 'finish'
        %Notify listeners of data source change
        Constr.Data.send('DataChanged');
end
