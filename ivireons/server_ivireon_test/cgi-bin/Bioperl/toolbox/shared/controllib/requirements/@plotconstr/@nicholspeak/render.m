function render(Constr, varargin)
%RENDER   Sets the vertices, X and Y data properties of the patch and markers.

%   Author(s): Bora Eryilmaz
%   Revised: A. Stothert
%   Copyright 1986-2009 The MathWorks, Inc. 
%   $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:32:26 $

% Get axes info
hGroup  = Constr.Elements;
HostAx  = handle(hGroup.Parent);
HostFig = HostAx.Parent;

if ~Constr.Activated
   % Initialize when constraint is not activated yet (preset for Activated=1)
   % Construct the constraint patch
   % Construct the constraint patch
   Patch = patch( ...
      'Parent', double(hGroup), ...
      'XlimInclude','off',...
      'YlimInclude','off',...
      'LineWidth', 2, ....
      'LineStyle', 'none', ...
      'CDataMapping', 'Direct', ...
      'FaceColor', Constr.PatchColor, ...
      'FaceAlpha', 0.75, ...
      'HelpTopicKey', Constr.HelpData.CSHTopic, ...
      'UIContextMenu', Constr.addmenu(HostFig), ...
      'ButtonDownFcn',Constr.ButtonDownFcn,...
      'Tag','ConstraintPatch');

   % Constraint 'inside edge'
   EdgeInfeasible = line(...
      'Parent', double(hGroup), ...
      'Color', Constr.EdgeColor, ...
      'LineWidth', 2, ...
      'Tag','ConstraintInfeasibleEdge', ...
      'Visible','on',...
      'XlimInclude','off',...
      'YlimInclude','off',...
      'HitTest', 'on',...
      'HelpTopicKey', Constr.HelpData.CSHTopic, ...
      'ButtonDownFcn',Constr.ButtonDownFcn);

   % Construct the constraint patch end markers
   Markers = line(...
      'Parent', double(hGroup),...
      'XlimInclude','off',...
      'YlimInclude','off',...
      'LineStyle','none', ...
      'Marker','s', ...
      'MarkerSize',4, ...
      'MarkerFaceColor','k', ...
      'MarkerEdgeColor','k', ...
      'HitTest','on',...
      'Visible',Constr.Selected,...
      'ButtonDownFcn',Constr.ButtonDownFcn,...
      'Tag', 'ConstraintMarkers');
end

% Get margin info
Gain   = unitconv(Constr.PeakGain,Constr.Data.getData('yData'),'db');   % in dB
Origin = unitconv(Constr.OriginPha,Constr.Data.getData('xData'),'deg'); % in deg

% Generate isogain lines for following gain values:
gain = Gain * [1 3];

% Phase points
phase = logspace(-3, log10(180), 35); % evently spaced points using approx.
phase = [phase, fliplr(360-phase(1:end-1))];

% Set number of points in rendered line
nP = length(phase);

% Convert data to open-loop gain and phase values
[g,p] = meshgrid(10.^(gain/20), (pi/180)*phase);  % mesh in H/(1+H) plane
z = g .* exp(1j*p);
H = z ./ (1-z);

% Create a multi-point line for curved constraint boundaries
Angles = rem((180/pi)*angle(H(:)) + 360, 360) - 180; 
i90 = find(Angles>-90);
nM = max(30,i90(1));     % Marker position index
XData = Origin + Angles; % Phase in deg
YData = 20*log10(abs(H(:)));  % Magnitude in dB

XData = unitconv(XData, 'deg' , Constr.xDisplayUnits);
YData = unitconv(YData, 'db', Constr.yDisplayUnits);

XLims = HostAx.Xlim;
YLims = HostAx.Ylim;
% Construct new X, Y and Z data for the patch
if (Gain <= 0)
    Xright  = XLims(2)*(1+0.5*sign(XLims(2)))+0.01*diff(XLims);
    Xleft = XLims(1)*(1-0.5*sign(XLims(1)))-0.01*diff(XLims);
    Ytop   = YLims(2)*(1+0.5*sign(YLims(2)))+0.01*diff(YLims);
    PatchXData = [...
       XData(1:nP); ...
       Xright; ...
       Xright; ...
       Xleft; ...
       Xleft];
    PatchYData = [...
       YData(1:nP); ...
       YData(nP); ...
       Ytop; ...
       Ytop; ...
       YData(1)];
    nPPatch = nP+4;
else
    PatchXData = XData(1:nP);
    PatchYData = YData(1:nP);
    nPPatch = nP;
end
PatchZData = Constr.Zlevel(ones(nPPatch,1),:);

hChildren = hGroup.Children;
Tags = get(hChildren,'Tag');

% Set the new patch data values
Vertices = [PatchXData(:) PatchYData(:) PatchZData(:)];
Faces = 1:nPPatch;
idx = strcmp(Tags,'ConstraintPatch');
set(hChildren(idx), 'Faces', Faces, 'Vertices', Vertices,'FaceColor',Constr.PatchColor);

% Plot left and right constraint selection markers in new position
idx = strcmp(Tags,'ConstraintInfeasibleEdge');
set(hChildren(idx),...
   'XData', PatchXData,...
   'YData', PatchYData, ...
   'Zdata',Constr.Zlevel(ones(size(PatchXData)))+0.1,...
   'Color',Constr.EdgeColor, ...
   'LineWidth', Constr.Weight(1)*2+eps, ...
   'visible', 'on')
idx = strcmp(Tags,'ConstraintMarkers');
nM = [nM, nP-nM+1]; %marker positions
set(hChildren(idx), ...
   'XData', XData(nM), ...
   'YData', YData(nM), ...
   'Zdata', Constr.Zlevel(ones(size(nM)))+0.1);


