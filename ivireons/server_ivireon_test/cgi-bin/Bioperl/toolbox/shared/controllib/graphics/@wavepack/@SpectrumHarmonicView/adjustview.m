function adjustview(cv,cd,Event,NormalRefresh)
%ADJUSTVIEW  Adjusts view prior to and after picking the axes limits for
%spectrum harmonic view. Main difference between FreqPeakGainView
%(superclass) is that it does not draw vertical lines.
%
%  ADJUSTVIEW(cVIEW,cDATA,'prelim') hides HG objects that might interfer  
%  with limit picking.
%
%  ADJUSTVIEW(cVIEW,cDATA,'postlimit') adjusts the HG object extent once  
%  the axes limits have been finalized (invoked in response, e.g., to a 
%  'LimitChanged' event).

% Author(s): Erman Korkut 18-Mar-2009
% Revised:
% Copyright 1986-2009 The MathWorks, Inc.
% $Revision: 1.1.8.1 $ $Date: 2009/10/16 06:27:01 $


if strcmp(Event,'postlim')
    % Position dot and lines given finalized axes limits
    AxGrid = cv.AxesGrid;
    Xauto = strcmp(AxGrid.XlimMode,'auto');
    rData = cd.Parent;
    FreqFactor = unitconv(1,rData.FreqUnits,cv.AxesGrid.XUnits);
    Freq = FreqFactor * rData.Frequency;
    MagUnits = AxGrid.YUnits;
    if iscell(MagUnits)
        MagUnits = MagUnits{1};  % mag/phase plots
    end
    
    % Position dot and lines given finalized axes limits
    [s1,s2] = size(cv.Points);
    for ct=1:s1*s2
        % Parent axes and limits
        ax = cv.Points(ct).Parent;
        Xlim = get(ax,'Xlim');
        Ylim = get(ax,'Ylim');
        % Adjust dot position based on the X limits
        XDot = FreqFactor * cd.Frequency(ct);
        OutScope = (Xauto(ceil(ct/s1)) & (XDot<Xlim(1) | XDot>Xlim(2)));
        if OutScope & length(Freq)>1
            % Dot falls outside auto limit box
            XDot = max(Xlim(1),min(Xlim(2),XDot));
            MagData = unitconv(rData.Magnitude(:,ct),rData.MagUnits,MagUnits);
            if strcmp(AxGrid.XScale,'log')
                % Remove any points in the frequency response that are zero
                ind = find(Freq ~= 0);
                Freq = Freq(ind);
                MagData = MagData(ind);
                YDot = utInterp1(log(Freq),MagData,log(XDot));  
            else
                YDot = utInterp1(Freq,MagData,XDot);  
            end
            Color = get(ax,'Color');   % open circle   
        else
            YDot = unitconv(cd.PeakGain(ct),rData.MagUnits,MagUnits);
            Color = get(cv.Points(ct),'Color');
        end
        
        if OutScope | isnan(XDot)
            set(double([cv.HLines(ct),cv.VLines(ct)]),'XData',[NaN NaN],'YData', [NaN NaN])         
        else
            set(double(cv.HLines(ct)),'XData',[Xlim(1),XDot],'YData',[YDot,YDot])     
%             set(double(cv.VLines(ct)),'XData',[XDot XDot],'YData',[Ylim(1) YDot])
        end
        % Position dots
        set(double(cv.Points(ct)),'XData',XDot,'YData',YDot,'MarkerFaceColor',Color)
    end
end

