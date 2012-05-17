 function sldvDataOutputs = recordExpectedOutput(sldvData, model)  

%   Copyright 2008 The MathWorks, Inc.

    sldvDataOutputs = sldvData;
    try
    expectedOutput = sldvruntest(model, sldvData);    
    catch Mex
        rethrow(Mex);
    end
    if ~isempty(expectedOutput)    
        outputPortInfo = sldvData.AnalysisInformation.OutputPortInfo;
        numOutports = length(outputPortInfo);    
        SimData = Sldv.DataUtils.getSimData(sldvData);   
        numTestCases = length(expectedOutput);
        origTsTimeInfo = cell(numTestCases,numOutports);
        for i=1:numTestCases               
            expectedOutputData = expectedOutput(i).Y;                        
            for j=1:numOutports
                [dataValuesInCell, tsTimeInfoPort] = ...
                    Sldv.DataUtils.storeDataValuesInCellFormat(expectedOutputData{j},outputPortInfo{j});
                expectedOutputData{j} = dataValuesInCell;                     
                origTsTimeInfo{i,j} = tsTimeInfoPort';                
            end
            SimData(i).expectedOutput = expectedOutputData;                                 
        end                   
                
        if ~acceptableOutData(origTsTimeInfo, outputPortInfo)
            wstate = warning('backtrace');
            warning('backtrace', 'off');
            warnmsg = ['Simulink Design Verifier is unable to record the expected output values\n' ...
                       'on sldvData because some Outport blocks of the model ''%s'' execute\n' ...
                       'conditionally. Expected output values of Outport blocks can be regenerated by invoking\n' ...
                       'sldvruntest after Simulink Design Verifier completes.'];
            warning('Sldv:DataUtils:recordExpectedOutput:MissingOutportValues',warnmsg,get_param(model,'Name'));
            warning('backtrace', wstate.state);
            return;
        end
        
        funTs = ...
            sldvshareprivate('mdl_derive_sampletime_for_sldvdata',sldvDataOutputs.AnalysisInformation.SampleTimes); 
        
        sldvDataOutputs = Sldv.DataUtils.setSimData(sldvDataOutputs,[],SimData); 
    
        for i=1:length(SimData)           
            simData = SimData(i);                                
            if isempty(simData.dataValues) 
                % No test case, no output value                
                continue;
            end          
            
            timeExpanded = Sldv.DataUtils.expandTimeForTimeseries(simData.timeValues, funTs);
                        
            for j=1:length(simData.expectedOutput)                                    
                simData.expectedOutput{j} = resampleOutputValues(timeExpanded,...
                                                                 simData.expectedOutput{j},...
                                                                 outputPortInfo{j},...
                                                                 origTsTimeInfo{i,j});                                                                                                                              
            end
            sldvDataOutputs = Sldv.DataUtils.setSimData(sldvDataOutputs,i,simData);
        end                            
    end
 end
 
 function status = acceptableOutData(origTsTimeInfo, outputPortInfo)
    status = true;
    [numTestCases, numOutports] = size(origTsTimeInfo);
    for idx = 1:numTestCases
        for jdx = 1:numOutports
            timeInfo = origTsTimeInfo{idx,jdx};
            if isempty(timeInfo)
                status = false;
                break;
            else                 
                outportDiscreteSampleTime = deriveSampleTime(outputPortInfo{jdx});
                nTimeStepsRequired = ...
                    floor((timeInfo(end)-outportDiscreteSampleTime(2))/outportDiscreteSampleTime(1))+1;
                if nTimeStepsRequired~=length(timeInfo)
                    status = false;
                    break;
                end              
             end
        end 
        if ~status
            break;
        end
    end
 end
 
 function outportDiscreteSampleTime = deriveSampleTime(outputPortInfo)
    if ~iscell(outputPortInfo)
        outportDiscreteSampleTime = outputPortInfo.ParentSampleTime;
    else
        outportDiscreteSampleTime = deriveSampleTime(outputPortInfo{2});        
    end
 end
 
 function sampledOutputValues = resampleOutputValues(tcTimeValues,outputData,outportInfo,outTimeValues)    
    if (length(tcTimeValues)==length(outTimeValues) && all(tcTimeValues==outTimeValues))
        % No need to sample
        sampledOutputValues = outputData;
        return;
    end
 
    if ~iscell(outputData)
        DataMatrix = Sldv.DataUtils.interpBelow(outTimeValues, outputData, tcTimeValues, outportInfo.Dimensions);
        if isscalar(outportInfo.Dimensions)
            sampledOutputValues = DataMatrix';
        else
            sampledOutputValues = DataMatrix;
        end   
    else
        numComponents = length(outputData);
        sampledOutputValues = cell(numComponents,1);
        for i=1:numComponents
            sampledOutputValues{i} = resampleOutputValues(tcTimeValues,outputData{i},outportInfo{i+1},outTimeValues);            
        end
    end
 end