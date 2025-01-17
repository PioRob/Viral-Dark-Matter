function installtip(this,gobjects,tipfcn,info)
%INSTALLTIP  Installs point tip on specified G-objects.

%   Author(s): P. Gahinet, John Glass
%   Copyright 1986-2007 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2009/10/16 06:18:47 $

% RE: TIPFCN is either '' or a MATLAB callback. The tip text is generated by evaluating the 
%     tip function according to
%        TIPTEXT = feval(@fcn,INFO,arg1,...,argN)
%     for TIPFCN = {@fcn arg1 ... argN}
if isempty(tipfcn)
   % Clear tip function
   BDF = '';
else
   BDF = {@localLineButtonDown tipfcn info};
end
set(gobjects,'ButtonDownFcn',BDF)

for ct = 1:length(gobjects)
    set(gobjects(ct),'handlevisibility','off')
    %% Get the behavior object
    hb = hggetbehavior(gobjects(ct),'DataCursor');
    % Do not serialize this behavior object during saves because update
    % function will have a stale handle to resppack object
    set(hb,'Serialize',false);
    if iscell(tipfcn)
        set(hb,'UpdateFcn',{tipfcn{1} info tipfcn{2:end}});
    else
        set(hb,'UpdateFcn',{tipfcn info});
    end
end

%%%%%%%%%%  Local Functions   %%%%%%%%%%  

function tip = localLineButtonDown(EventSrc,EventData,tipfcn,info)
% Creates data tip and sets its tip function

if ~isa(info.View.PointTips{info.Row,info.Col},'tippack.linetip') 
    tip = pointtip(EventSrc,info.TipOptions{:});
    
    %% Listener for the Frequency Units of the Nichols Plot object. 
    tip.addlistener(handle.listener(info.Carrier.Parent,...
        info.Carrier.Parent.findprop('FrequencyUnits'),...
        'PropertyPostSet',{@LocalUpdateString, tip}));
        
    PointTips = info.View.PointTips; 
    PointTips{info.Row,info.Col} = tip;
    info.View.PointTips = PointTips;
else
    tip = [];
end

%%% Local function to update the string if the units change.
function LocalUpdateString(EventSource,EventData,tip)

tip.updatestring