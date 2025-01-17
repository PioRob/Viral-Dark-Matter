function draw(this)
%DRAW  Draws all @waveform's in plot.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:29:20 $

if isvisible(this)
   % Turn off backdoor listeners
   % RE: LimitManager must be off so that DRAW on waveforms 
   %     does not trigger limit update
   AxGrid = this.AxesGrid;
   LimitMgrState = AxGrid.LimitManager;  % could come in off already
   AxGrid.LimitManager = 'off';
   
   % Draw waveforms
   for wf=allwaves(this)'
      draw(wf)
   end
   
   % Turn backdoor listeners back on
   AxGrid.LimitManager = LimitMgrState;
   
   % Broadcast ViewChanged event (triggers limit picker)
   AxGrid.send('ViewChanged')
end
