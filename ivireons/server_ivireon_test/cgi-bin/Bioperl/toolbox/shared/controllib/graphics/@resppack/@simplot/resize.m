function resize(this,NewOutputNames,NewInputNames)
%RESIZE  Reconfigures plot given new set of collective I/O names.

%   Author: P. Gahinet
%  Copyright 1986-2008 The MathWorks, Inc.
%  $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:24:52 $

% Adjust input width and update input names
NewInputSize = length(NewInputNames);
setInputWidth(this,NewInputSize)
this.Input.ChannelName = NewInputNames;

% Compare output sizes
AxGrid = this.AxesGrid;
OldSize = AxGrid.Size;
NewRowSize = length(NewOutputNames);

% Resize if necessary
if NewRowSize~=OldSize(1)
   % Axes grid needs to be resized
   % 1) Reparent all responses to first axes (other axes may be deleted
   %    when downsizing)
   Axes = getaxes(AxGrid);
   Axes = Axes(ones(OldSize));
   for r=allwaves(this)'
      r.reparent(Axes)
   end
   % 2) Resize the axes grid
   AxGrid.Size = [NewRowSize 1 1 1];
   % 3) Tatoo new HG axes
   ax = allaxes(this);
   for ct=1:numel(ax)
      setappdata(ax(ct),'WaveRespPlot',this)
   end
   % 4) Update plot's I/O-related properties (no listeners to prevent
   %    errors due to partial update)
   this.Listeners.setEnabled(false);
   this.OutputName = NewOutputNames;
   this.OutputVisible = repmat({'on'},[NewRowSize 1]);
   if NewRowSize==1
      this.IOGrouping = 'none';
   end
   this.Listeners.setEnabled(true);
   % 5) Update plot labels
   rclabel(this)
else
   % Just updates I/O names (cf. geck 84020)
   this.OutputName = NewOutputNames;
end

% Relocate responses in axes grid
for r=allwaves(this)'
   localize(r)
end