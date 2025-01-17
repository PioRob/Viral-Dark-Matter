function aero_radplot
%RADPLOT Radar Data Processing Tracker plotting function
%
% This function works with several extended Kalman filter
% demos in Simulink and other demos.

% Author: P. Barnard
% Copyright 1990-2008 The MathWorks, Inc.
% $Revision: 1.11.2.4 $  $Date: 2008/12/01 07:48:32 $

%--- Get radar measurement interval from model

deltat = 1;

%--- get logged data from workspace

data = locGetData();

if isempty(data)
  return;  % if there is no data, no point in plotting
else
  XYCoords          = data.XYCoords;
  Measurement_noise = data.Measurement_noise;
  PolarCoords       = data.PolarCoords;
  residual          = data.residual;
  X_hat             = data.X_hat;
end

%==== Plot data: set up figure

pos = [10 40 900 650];
h_1 = figure(1);
clf(h_1)
set(h_1,'pos',pos);

%--- Polar plot of actual/estimated position
margin = [ 0.075, 0.075, -0.1, -0.1 ];
pos = [ 0, 0.5, 0.33, 0.5 ];
axp = pos + margin;
subplot('Position', axp);
polar(PolarCoords(:,2) - Measurement_noise(:,2), ...
      PolarCoords(:,1) - Measurement_noise(:,1),'r')
hold on
rangehat = sqrt(X_hat(:,1).^2+X_hat(:,3).^2);
bearinghat = atan2(X_hat(:,3),X_hat(:,1));

hPolar = polar(bearinghat,rangehat,'g');
hAx    = get(hPolar, 'parent');
set(hAx, 'units', 'pixels');
axPos  = get(hAx, 'position');
figWidth = axPos(3); figHeight = axPos(4);
text('units', 'pixels', ...
     'pos', [figWidth/2 -figHeight/9], ...    
     'horizontalalign', 'center', ...
     'verticalalign', 'bottom', ...
     'String', sprintf('Actual Trajectory (red)\nEstimated Trajectory (green)'))

%--- Range Estimate Error
margin = [ 0.08, 0.075, -0.05, -0.1 ];
pos = [ 0, 0, 0.33, 0.5 ];
axp = pos + margin;
subplot('Position', axp);
plot(residual(:,1)); grid; set(gca,'xlim',[0 length(residual)]);
xlabel('Number of Measurements');
ylabel('Range Estimate Error - Feet')
title('Estimation Residual for Range')

%--- East-West position
XYMeas = [PolarCoords(:,1).*cos(PolarCoords(:,2)), ...
          PolarCoords(:,1).*sin(PolarCoords(:,2))];
numTSteps = size(XYCoords,1);
t_full    = 0.1 * (0:numTSteps-1)';
t_hat     = (0:deltat:t_full(end))';    
       
margin = [ 0.1, 0.05, -0.12, -0.1 ];
pos = [ 0.33, 0.5, 0.66, 0.5 ];
axp = pos + margin;
subplot('Position', axp);
plot(t_full,XYCoords(:,2),'r');
grid on;hold on
plot(t_full,XYMeas(:,2),'g');
plot(t_hat,X_hat(:,3),'b');
title('E-W Position');
legend('Actual','Meas','Est',3,'Location','Northwest');
hold off

%--- North-South position
margin = [ 0.1, 0.075, -0.12, -0.1 ];
pos = [ 0.33, 0, 0.66, 0.5 ];
axp = pos + margin;
subplot('Position', axp);
plot(t_full,XYCoords(:,1),'r');
grid on;hold on
plot(t_full,XYMeas(:,1),'g');
plot(t_hat,X_hat(:,1),'b');
xlabel('Time (sec)');
title('N-S Position');
hold off

end

%Function: locGetData ==================================================
%
%  Get data logged to workspace
%
function data = locGetData
% Get simulation result data from workspace 

% --- If necessary, convert logged signal data to local variables

if evalin('base','exist(''radarLogsOut'')')

    try
        logsOut = evalin('base','radarLogsOut');

        data.Measurement_noise = logsOut.Measurement_noise.Data;
        data.XYCoords          = logsOut.XYCoords.Data;
        data.PolarCoords       = logsOut.PolarCoords.Data;
        data.residual          = logsOut.residual.Data;
        data.X_hat             = logsOut.X_hat.Data;
    catch %#ok<CTCH>
        data = [];
    end
else
    
    if evalin('base','exist(''Measurement_noise'')')
        data.Measurement_noise = evalin('base','Measurement_noise');
        data.XYCoords          = evalin('base','XYCoords');
        data.PolarCoords       = evalin('base','PolarCoords');
        data.residual          = evalin('base','residual');
        data.X_hat             = evalin('base','X_hat');
    else
        data = [];  % something didn't run, skip retrieval
    end
end

end

%[EOF] aero_radplot.m
