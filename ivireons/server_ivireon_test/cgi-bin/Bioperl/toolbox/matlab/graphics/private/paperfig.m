function pfig=paperfig(fig)
%PAPERFIG Create page representation of figure
%   H = PAPERFIG(FIG) copies the contents of FIG with possible page
%   header and returns the new figure handle H.

%   Copyright 1984-2008 The MathWorks, Inc.

if (~useOriginalHGPrinting())
    error('MATLAB:Print:ObsoleteFunction', 'The function %s should only be called when original HG printing is enabled.', upper(mfilename));
end

paperInch = LGetPaperInch(fig);
paperPosInch = LGetPaperPosInch(fig);
props = {'Alphamap','Color','Colormap','InvertHardcopy',...
	 'PaperOrientation','PaperUnits','PaperPosition',...
	 'PaperPositionMode',...
	 'PaperSize','PaperType','Renderer','RendererMode',...
	 'ResizeFcn','Position'};
vals = get(fig,props);
pfig = figure('HandleVisibility','off','Visible','off',props,vals);
set(pfig,'Units','inches');
set(pfig,'Position',paperPosInch);

allc = copyobj(allchild(fig),pfig);
for k=1:length(allc)
  if isprop(allc(k),'Units')
    set(allc(k),'Units','inch');
  end
  if isprop(allc(k),'ActivePositionProperty')
    posProp = get(allc(k),'ActivePositionProperty');
  else
    posProp = 'Position';
  end
  if isprop(allc(k),posProp) && ...
        any(strcmp(get(allc(k),'Type'),{'axes','uicontrol',...
                        'uicontainer','uipanel'}))
    oldpos = get(allc(k),posProp);
    newpos = [oldpos(1)+paperPosInch(1) oldpos(2)+paperPosInch(2) ...
              oldpos(3:4)];
    set(allc(k),posProp,newpos);
  end
end
set(pfig,'PaperPositionMode','manual');
set(pfig,'Position',[0 0 paperInch]);
set(pfig,'PaperUnits','inch');
set(pfig,'PaperPosition',[0 0 paperInch]);

hs = getappdata(fig,'PrintHeaderHeaderSpec');
if ~isempty(hs)

  headerax = axes(...
      'visible','off',...
      'parent',pfig,...
      'units','normalized',...
      'xtick',[],'ytick',[],...
      'position',[0 0 1 1]);

  set(headerax,'units','points');
  axpos = get(headerax,'position');
  datestring = '';
  if ~strcmp(hs.dateformat,'none')
    datestring = datestr(now,hs.dateformat,'local');
  end
  tstring = text(...
      'parent',headerax,...
      'units','points',...
      'horizontalalignment','left',...
      'verticalalignment','top',...
      'string',hs.string,...
      'fontname',hs.fontname,...
      'fontweight',hs.fontweight,...
      'fontsize',hs.fontsize,...
      'fontangle',hs.fontangle,...
      'tag','paperfigtstring',...
      'position',[hs.margin, axpos(4) - hs.margin 0]);
  if ~isempty(datestring)
    tdate = text(...
        'parent',headerax,...
        'units','points',...
        'horizontalalignment','right',...
        'verticalalignment','top',...
        'string',datestring,...
        'fontname',hs.fontname,...            
        'fontweight',hs.fontweight,...
        'fontsize',hs.fontsize,...
        'fontangle',hs.fontangle,...
        'tag','paperfigtdate',...
        'position',[axpos(3) - hs.margin, axpos(4) - hs.margin 0]);
  end
end

%-----------------------------------------------------------------%
function paperSize = LGetPaperInch(fig)

oldPaperUnits = get(fig,'PaperUnits');
set(fig,'PaperUnits','inch');
paperSize = get(fig,'PaperSize');
set(fig,'PaperUnits',oldPaperUnits);

%-----------------------------------------------------------------%
function paperPos = LGetPaperPosInch(fig)

if strcmp(get(fig,'PaperPositionMode'),'auto')
  paperPos = hgconvertunits(fig,get(fig,'Position'),...
                       get(fig,'Units'),'inches',0);
  paperInch = LGetPaperInch(fig);
  paperPos(1:2) = .5*(paperInch - paperPos(3:4));
else
  oldPaperUnits = get(fig,'PaperUnits');
  set(fig,'PaperUnits','inch');
  paperPos = get(fig,'PaperPosition');
  set(fig,'PaperUnits',oldPaperUnits);
end
