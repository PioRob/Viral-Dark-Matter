function stop=plotperf(tr,goal,name,epoch)
%PLOTPERF Plot network performance.
%
% Obsoleted in R2008b NNET 6.0.  Last used in R2007b NNET 5.1.
%
%  Syntax
%
%    plotperf(tr,goal,name,epoch)
%
%  Description
%
%    PLOTPERF(TR,GOAL,NAME,EPOCH) takes these inputs,
%      TR - Training record returned by train.
%      GOAL - Performance goal, default = NaN.
%      NAME - Training function name, default = ''.
%      EPOCH - Number of epochs, default = length of training record.
%    and plots the training performance, and if available, the performance
%    goal, validation performance, and test performance.
%
%  Example
%
%    Here are 8 input values P and associated targets T.
%
%      P = 1:8; T = sin(P);
%
%    The code below creates a network and trains it on this problem.
%
%      net = newff(minmax(P),[4 1],{'tansig','tansig'});
%      [net,tr] = train(net,P,T);
%      plotperf(tr)

% Mark Beale 11-31-97, Orlando De Jesus 11-11-98, MHB 12-29-99
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.8.1 $ $Date: 2010/03/22 04:08:31 $

% ERROR CHECKS, DEFAULTS AND 3 SPECIAL CASES
% ==========================================

% Error check: must be at least one argument
if nargin < 1, nnerr.throw('Not enough input arguments.'); end

% NNT 5.1 Backward compatibility
if (nargin == 1) && ischar(tr)
  stop = 1;
  return
end

% Defaults
if nargin < 2, goal = NaN; end
if nargin < 3, name = 'Training Record'; end
if nargin < 4, epoch = length(tr.epoch)-1; end

% Special case 2: Delete plot if zero epochs
if (epoch == 0) || isnan(tr.perf(1))
  fig = find_existing_figure;
  if (fig), delete(fig); end
  if (nargout) stop = 0; end
  return
end

% Special case 3: No plot if performance is NaN
if (epoch == 0) || isnan(tr.perf(1))
  if (nargout) stop = 0; end
  return
end

% GET FIGURE AND USER DATA
% ========================

% Get existing/new figure
fig2 = find_existing_figure;
if (fig2 == 0), fig2 = new_figure(name); end
figure(fig2);

% Get existing/new userdata
ud=get(fig2,'userdata');
if isempty(ud)
  createNewPlot(fig2);
  ud = get(fig2,'userdata');
end

% UPDATE PLOTTING DATA
% ====================

% Epoch indices and initial y-limits
ind = 1:(epoch+1);
ymax=1e-20;
ymin=1e20;

% Update validation-performance plot and y-limits (if required)
if isfield(tr,'vperf')
  plotValidation = ~isnan(tr.vperf(1));
else
  plotValidation = 0;
end
if plotValidation
  set(ud.TrainLine(3),...
      'Xdata',tr.epoch(ind),...
      'Ydata',tr.vperf(ind),...
      'linewidth',2,'color','g');
  ymax=(max([ymax tr.vperf(ind)]));   
  ymin=(min([ymin tr.vperf(ind)]));   
end

% Update test-performance plot and y-limits (if required)
if isfield(tr,'tperf')
  plotTest = ~isnan(tr.tperf(1));
else
  plotTest = 0;
end
if plotTest
  set(ud.TrainLine(2),...
      'Xdata',tr.epoch(ind),...
      'Ydata',tr.tperf(ind),...
      'linewidth',2,'color','r');
  ymax=(max([ymax tr.tperf(ind)]));   
  ymin=(min([ymin tr.tperf(ind)]));   
end

% Update performance plot and ylimits
set(ud.TrainLine(4),...
    'Xdata',tr.epoch(ind),...
    'Ydata',tr.perf(ind),...
    'linewidth',2,'color','b');
ymax=(max([ymax tr.perf(ind)]));   
ymin=(min([ymin tr.perf(ind)]));
  
% Update performance goal plot and y-limits (if required)
% plot goal only if > 0, or if 0 and ymin is also 0
plotGoal = isfinite(goal) & ((goal > 0) | (ymin == 0));
if plotGoal
  set(ud.TrainLine(1),...
      'Xdata',tr.epoch(ind),...
      'Ydata',goal+zeros(1,epoch+1),...
      'linewidth',2,'color','k');
  ymax=(max([ymax goal]));   
  ymin=(min([ymin goal]));
end

% Update axis scale and rounded y-limits
if (ymin > 0)
  yscale = 'log';
  ymax=10^ceil(log10(ymax));
  ymin=10^fix(log10(ymin)-1);
else
  yscale = 'linear';
  ymax=10^ceil(log10(ymax));
  ymin=0;
end
set(ud.TrainAxes,'xlim',[0 epoch],'ylim',[ymin ymax]);
set(ud.TrainAxes,'yscale',yscale);

% UPDATE FIGURE TITLE, NAME, AND AXIS LABLES
% ====================

% Update figure title
tstring = sprintf('Performance is %g',tr.perf(epoch+1));
if isfinite(goal)
  tstring = [tstring ', ' sprintf('Goal is %g',goal)];
end
set(ud.TrainTitle,'string',tstring);

% Update figure name
if isempty(name)
  set(fig2,'name',['Training with ' upper(tr.trainFcn)],'numbertitle','off');
end

% Update axis x-label
if epoch == 0
   set(ud.TrainXlabel,'string','Zero Epochs');
elseif epoch == 1
   set(ud.TrainXlabel,'string','One Epoch');
else
   set(ud.TrainXlabel,'string',[num2str(epoch) ' Epochs']);
end

% Update axis y-lable
set(ud.TrainYlabel,'string','Performance');

% FINISH
% ======

% Make changes now
drawnow;

% Return stop flag if required
if (nargout), stop = 0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find pre-existing figure, if any
function fig = find_existing_figure

% Initially assume figure does not exist
fig = 0;

% Search children of root...
for child=get(0,'children')'
  % ...for objects whose type is figure...
  if strcmp(get(child,'type'),'figure') 
    % ...whose tag is 'train'
    if strcmp(get(child,'tag'),'train')
       % ...and stop search if found.
       fig = child;
     break
   end
  end
end

% Not sure if/why this is necessary
if length(get(fig,'children')) == 0
  fig = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New figure
function fig = new_figure(name)

fig = figure(...
    'Units',          'pixel',...
    'Name',           name,...
    'Tag',            'train',...
    'NumberTitle',    'off',...
    'IntegerHandle',  'off',...
    'Toolbar',        'none');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create new plot in figure
function createNewPlot(fig)

% Delete all children from figure
z = get(fig,'children');
for i=1:length(z)
    delete (z(i));
end

% Create axis
ud.TrainAxes     = axes('Parent',fig);
ud.TrainLine     = plot(0,0,0,0,0,0,0,0,'EraseMode','None','Parent',ud.TrainAxes);
ud.TrainXlabel   = xlabel('X Axis','Parent',ud.TrainAxes);
ud.TrainYlabel   = ylabel('Y Axis','Parent',ud.TrainAxes);
ud.TrainTitle    = get(ud.TrainAxes,'Title');
set(ud.TrainAxes,'yscale','log');
ud.XData      = [];
ud.YData      = [];
ud.Y2Data     = [];
set(fig,'UserData',ud,'menubar','none','toolbar','none');

legend([ud.TrainLine(4) ud.TrainLine(3) ud.TrainLine(2)],'Train','Validation','Test');

% Bring figure to front
figure(fig);

