function c = getCharacteristics(this,PlotType)
%getCharacteristics Gets the characteristics associated with the plot type
% for the data source

%  Copyright 1986-2010 The MathWorks, Inc.
%  $Revision: 1.1.8.2 $   $Date: 2010/04/11 20:36:27 $


%#function resppack.TimeFinalValueData
%#function resppack.TimeFinalValueView
%#function resppack.StepPeakRespData
%#function resppack.StepPeakRespView
%#function resppack.SettleTimeView
%#function resppack.StepRiseTimeData
%#function resppack.StepRiseTimeView
%#function resppack.StepSteadyStateView
%#function wavepack.TimePeakAmpData 
%#function wavepack.TimePeakAmpView
%#function resppack.SettleTimeData
%#function resppack.SimInputPeakView
%#function wavepack.FreqPeakGainData
%#function wavepack.FreqPeakGainView
%#function resppack.MinStabilityMarginData
%#function resppack.BodeStabilityMarginView
%#function resppack.AllStabilityMarginData
%#function resppack.BodeStabilityMarginView
%#function resppack.NicholsPeakRespView
%#function resppack.NyquistStabilityMarginView
%#function resppack.SigmaPeakRespData
%#function resppack.SigmaPeakRespView
%#function resppack.NyquistPeakRespView
%#function resppack.FreqPeakRespData


switch PlotType
    case 'step'
        c(1) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'resppack.StepPeakRespData',...
            'CharacteristicView', 'resppack.StepPeakRespView', ...
            'CharacteristicGroup', 'Characteristic');
        c(2) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strSettlingTime'), ...
            'CharacteristicID', 'SettlingTime', ...
            'CharacteristicData', 'resppack.SettleTimeData',...
            'CharacteristicView', 'resppack.SettleTimeView', ...
            'CharacteristicGroup', 'Characteristic');
        c(3) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strRiseTime'), ...
            'CharacteristicID', 'RiseTime', ...
            'CharacteristicData', 'resppack.StepRiseTimeData',...
            'CharacteristicView', 'resppack.StepRiseTimeView', ...
            'CharacteristicGroup', 'Characteristic');
        c(4) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strSteadyState'), ...
            'CharacteristicID', 'SteadyState', ...
            'CharacteristicData', 'resppack.TimeFinalValueData',...
            'CharacteristicView', 'resppack.StepSteadyStateView', ...
            'CharacteristicGroup', 'Characteristic');
    case 'impulse'
        c(1) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'wavepack.TimePeakAmpData',...
            'CharacteristicView', 'wavepack.TimePeakAmpView', ...
            'CharacteristicGroup', 'Characteristic');
        c(2) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strSettlingTime'), ...
            'CharacteristicID', 'SettlingTime', ...
            'CharacteristicData', 'resppack.SettleTimeData',...
            'CharacteristicView', 'resppack.SettleTimeView', ...
            'CharacteristicGroup', 'Characteristic');
    case 'initial'
        c = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'wavepack.TimePeakAmpData',...
            'CharacteristicView', 'wavepack.TimePeakAmpView', ...
            'CharacteristicGroup', 'Characteristic');
    case 'lsim'
        c = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'wavepack.TimePeakAmpData',...
            'CharacteristicView', 'wavepack.TimePeakAmpView', ...
            'CharacteristicGroup', 'Characteristic');
    case 'bode'
        c(1) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'wavepack.FreqPeakGainData',...
            'CharacteristicView', 'wavepack.FreqPeakGainView', ...
            'CharacteristicGroup', 'Characteristic');
        if issiso(this.Model)
            % Margin Characteristics for SISO systems
            c(2) = struct(...
                'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strMinimumStabilityMargins'), ...
                'CharacteristicID', 'MinimumStabilityMargins', ...
                'CharacteristicData', 'resppack.MinStabilityMarginData',...
                'CharacteristicView', 'resppack.BodeStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
            c(3) = struct(...
                'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strAllStabilityMargins'), ...
                'CharacteristicID', 'AllStabilityMargins', ...
                'CharacteristicData', 'resppack.AllStabilityMarginData',...
                'CharacteristicView', 'resppack.BodeStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
        end
    case 'nichols'
        c(1) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'wavepack.FreqPeakGainData',...
            'CharacteristicView', 'resppack.NicholsPeakRespView', ...
            'CharacteristicGroup', 'Characteristic');
        
        if issiso(this.Model)
            % Margin Characteristics for SISO systems
            c(2) = struct(...
                'CharacteristicLabel',  ctrlMsgUtils.message('Controllib:plots:strMinimumStabilityMargins'), ...
                'CharacteristicID', 'MinimumStabilityMargins', ...
                'CharacteristicData', 'resppack.MinStabilityMarginData',...
                'CharacteristicView', 'resppack.NicholsStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
            c(3) = struct(...
                'CharacteristicLabel',  ctrlMsgUtils.message('Controllib:plots:strAllStabilityMargins'), ...
                'CharacteristicID', 'AllStabilityMargins', ...
                'CharacteristicData', 'resppack.AllStabilityMarginData',...
                'CharacteristicView', 'resppack.NicholsStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
        end
    case 'nyquist'
        c(1) = struct(...
            'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
            'CharacteristicID', 'PeakResponse', ...
            'CharacteristicData', 'resppack.FreqPeakRespData',...
            'CharacteristicView', 'resppack.NyquistPeakRespView', ...
            'CharacteristicGroup', 'Characteristic');

        if issiso(this.Model)
            % Margin Characteristics for SISO systems
            c(2) = struct(...
                'CharacteristicLabel',  ctrlMsgUtils.message('Controllib:plots:strMinimumStabilityMargins'), ...
                'CharacteristicID', 'MinimumStabilityMargins', ...
                'CharacteristicData', 'resppack.MinStabilityMarginData',...
                'CharacteristicView', 'resppack.NyquistStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
            c(3) = struct(...
                'CharacteristicLabel',  ctrlMsgUtils.message('Controllib:plots:strAllStabilityMargins'), ...
                'CharacteristicID', 'AllStabilityMargins', ...
                'CharacteristicData', 'resppack.AllStabilityMarginData',...
                'CharacteristicView', 'resppack.NyquistStabilityMarginView', ...
                'CharacteristicGroup', 'Characteristic');
        end
    case 'sigma'
            c = struct(...
                'CharacteristicLabel', ctrlMsgUtils.message('Controllib:plots:strPeakResponse'), ...
                'CharacteristicID', 'PeakResponse', ...
                'CharacteristicData', 'resppack.SigmaPeakRespData',...
                'CharacteristicView', 'resppack.SigmaPeakRespView', ...
                'CharacteristicGroup', 'Characteristic');
    otherwise
        c = [];
end

end





