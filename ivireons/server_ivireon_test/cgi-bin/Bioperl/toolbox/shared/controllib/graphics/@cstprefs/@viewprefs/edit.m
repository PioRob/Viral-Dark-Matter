function Frame = edit(h)
%EDIT  Open GUI for editing LTI Viewer Preferences

%   Author(s): A. DiVergilio
%   Revised  : Kamesh Subbarao
%   Copyright 1986-2010 The MathWorks, Inc.
%   $Revision: 1.1.8.2 $  $Date: 2010/04/21 21:45:15 $

%---Watch on
 set(h.Target,'Pointer','watch');

%---Get handle to editor frame for preference object
 Frame = h.EditorFrame;

%---Create a new editor if one is not found
if isempty(Frame)
   %---Get Toolbox Preferences
    Prefs = cstprefs.tbxprefs;
   %---Frame
    Frame = com.mathworks.mwt.MWFrame(ctrlMsgUtils.message('Controllib:gui:strLTIViewerPreferences'));
    Frame.setLayout(com.mathworks.mwt.MWBorderLayout(0,0));
    Frame.setFont(Prefs.JavaFontP);
    hc = handle(Frame, 'callbackproperties');
    set(hc,'WindowClosingCallback',@(es,ed) localCancel(Frame));
   %---Show empty Frame with some status text while loading
    Frame.setSize(java.awt.Dimension(360,280));
    centerfig(Frame,h.Target);
    s.Status = com.mathworks.mwt.MWLabel(ctrlMsgUtils.message('Controllib:gui:strLoadingLTIViewerPreferencesLabel'), ...
        com.mathworks.mwt.MWLabel.CENTER);
    Frame.add(s.Status,com.mathworks.mwt.MWBorderLayout.CENTER);
    awtinvoke(Frame,'setVisible(Z)',true);
    Frame.toFront;
    xypos1 = Frame.getLocation;

   %---Store handle to frame in preference object (this must occur before copy!)
    h.EditorFrame = Frame;

   %---Listen for Target destruction
    s.TargetDestroyedListener = handle.listener(h.Target,'ObjectBeingDestroyed',{@localDispose,Frame});

   %---Handle to current Viewer Preferences
    s.OldPrefs = h;
   %---Copy of current Viewer Preferences for editing
    s.NewPrefs = copy(s.OldPrefs);
   %---Temporarily clear property values (we'll set them back after listeners are installed)
    AllProps = fieldnames(s.NewPrefs);
    for n=1:size(AllProps,1)
       set(s.NewPrefs,AllProps{n,:},'');
    end

   %---ButtonPanel
    s.ButtonPanel = com.mathworks.mwt.MWPanel(java.awt.FlowLayout(java.awt.FlowLayout.RIGHT,7,0));
    s.ButtonPanel.setInsets(java.awt.Insets(2,5,5,-2));
       %---OK
        s.OK = com.mathworks.mwt.MWButton(ctrlMsgUtils.message('Controllib:general:strOK')); 
        s.ButtonPanel.add(s.OK);
        s.OK.setFont(Prefs.JavaFontP);
        hc = handle(s.OK, 'callbackproperties');
        set(hc,'ActionPerformedCallback',@(es,ed) localOK(Frame));
       %---Cancel
        s.Cancel = com.mathworks.mwt.MWButton(ctrlMsgUtils.message('Controllib:general:strCancel')); 
        s.ButtonPanel.add(s.Cancel);
        s.Cancel.setFont(Prefs.JavaFontP);
        hc = handle(s.Cancel, 'callbackproperties');
        set(hc,'ActionPerformedCallback',@(es,ed) localCancel(Frame));
       %---Help
        s.Help = com.mathworks.mwt.MWButton(ctrlMsgUtils.message('Controllib:general:strHelp')); 
        s.ButtonPanel.add(s.Help);
        s.Help.setFont(Prefs.JavaFontP);
        hc = handle(s.Help, 'callbackproperties');
        set(hc,'ActionPerformedCallback',@(es,ed) ctrlguihelp('viewer_preferences'));
       %---Apply
        s.Apply = com.mathworks.mwt.MWButton(ctrlMsgUtils.message('Controllib:general:strApply')); 
        s.ButtonPanel.add(s.Apply);
        s.Apply.setFont(Prefs.JavaFontP);
        hc = handle(s.Apply, 'callbackproperties');
        set(hc,'ActionPerformedCallback',@(es,ed) localApply(Frame));


   %---TabPanel
    s.TabPanel = com.mathworks.mwt.MWTabPanel;
    s.TabPanel.setInsets(java.awt.Insets(5,5,5,5));
    s.TabPanel.setMargins(java.awt.Insets(12,8,8,8));
    s.TabPanel.setFont(Prefs.JavaFontP);
       %---Units
        s.Units = unit_gui(s.NewPrefs); 
        s.UnitsTab = localMakeTab(s.Units);
        s.TabPanel.addPanel(sprintf('Units'),s.UnitsTab);
       %---Style
        s.Grid  = grid_gui(s.NewPrefs);
        s.Font  = font_gui(s.NewPrefs);
        s.Color = clr_gui(s.NewPrefs);
        s.StyleTab = localMakeTab(s.Grid,s.Font,s.Color);
        s.TabPanel.addPanel(sprintf('Style'),s.StyleTab);
       %---Characteristics
        s.Characteristics = char_gui(s.NewPrefs);
        s.FreqOptions = freq_gui(s.NewPrefs);
        s.CharacteristicsTab = localMakeTab(s.Characteristics,s.FreqOptions);
        s.TabPanel.addPanel(sprintf('Options'),s.CharacteristicsTab);
       %---Parameters
        s.TimeVector = tvec_gui(s.NewPrefs);
        s.FrequencyVector = fvec_gui(s.NewPrefs);
        s.ParametersTab = localMakeTab(s.TimeVector,s.FrequencyVector);
        s.TabPanel.addPanel(sprintf('Parameters'),s.ParametersTab);
   %---Start on the first tab panel
    s.TabPanel.selectPanel(0);

   %---Store structure in Frame UserData
    set(Frame,'UserData',s);

   %---Set property values (listeners will update GUI)
    for n=1:size(AllProps,1)
       set(s.NewPrefs,AllProps{n,:},s.OldPrefs.get(AllProps{n,:}));
    end

   %---Remove the status text, add the real components and pack
    Frame.remove(s.Status);
    Frame.add(s.TabPanel,com.mathworks.mwt.MWBorderLayout.CENTER);
    Frame.add(s.ButtonPanel,com.mathworks.mwt.MWBorderLayout.SOUTH);
    Frame.pack;
    xypos2 = Frame.getLocation;
    if abs(xypos1.x-xypos2.x)<5 && abs(xypos1.y-xypos2.y)<5
       centerfig(Frame,h.Target);
    end

else
   %---Structure of handles/data
    s = get(Frame,'UserData');
   %---Copy current Viewer Preferences to our editable copy
   %--- (our listeners will update the GUI automatically)
    set(s.NewPrefs,get(s.OldPrefs));
   %---Raise Frame (no java methods here... findobj returns hg handles!)
   Frame.setMinimized(false);
   Frame.setVisible(false);
   Frame.setVisible(true);
end

%---Watch off
 set(h.Target,'Pointer','arrow');


%%%%%%%%%%%%%%%%
% localMakeTab %
%%%%%%%%%%%%%%%%
function Tab = localMakeTab(varargin)
% Combine panels into a single panel for use in a tab dialog
Tab = com.mathworks.mwt.MWPanel(com.mathworks.mwt.MWBorderLayout(0,0));
for n=1:nargin
   if n<nargin
      %---Not last element, leave 5-pixel spacing
      tmp = com.mathworks.mwt.MWPanel(com.mathworks.mwt.MWBorderLayout(0,5));
   else
      %---Last element, leave 0-pixel spacing
      tmp = com.mathworks.mwt.MWPanel(com.mathworks.mwt.MWBorderLayout(0,0));
   end
   %---Pack towards top
   tmp.add(varargin{n},com.mathworks.mwt.MWBorderLayout.NORTH);
   %---Add java handle to structure
   s(n,1) = tmp;
   %---Add first panel to Tab
   if n==1
      Tab.add(tmp,com.mathworks.mwt.MWBorderLayout.CENTER);
   %---Nest other panels
   else
      tmp2 = s(n-1,1);
      tmp2.add(tmp,com.mathworks.mwt.MWBorderLayout.CENTER);
   end
end
%---Store java handles
set(Tab,'UserData',s);


%%%%%%%%%%%
% localOK %
%%%%%%%%%%%
function localOK(Frame)

localApply(Frame);
Frame.setVisible(false);


%%%%%%%%%%%%%%%
% localCancel %
%%%%%%%%%%%%%%%
function localCancel(Frame)
 s = get(Frame,'UserData');
 set(s.NewPrefs,get(s.OldPrefs));
 Frame.setVisible(false);


%%%%%%%%%%%%%%
% localApply %
%%%%%%%%%%%%%%
function localApply(Frame)
%
s = get(Frame,'UserData');
oldcursor = Frame.getCursor;
Frame.setCursor(com.mathworks.mwt.MWFrame.WAIT_CURSOR);
set(s.OldPrefs,get(s.NewPrefs));
Frame.setCursor(oldcursor);

%%%%%%%%%%%%%%%%
% localDispose %
%%%%%%%%%%%%%%%%
function localDispose(~,~,Frame)
awtinvoke(Frame,'dispose');
 