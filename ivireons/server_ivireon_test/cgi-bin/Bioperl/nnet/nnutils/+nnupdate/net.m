function net = net(net)
%UPDATENET Creates a current network object from an old network structure.
%
%
%  NET = UPDATE(S)
%    S - Structure with fields of old neural network object.
%  Returns
%    NET - New neural network
%
%  This function is caled by NETWORK/LOADOBJ to update old neural
%  network objects when they are loaded from an M-file.

% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.8.2 $  $Date: 2010/05/10 17:31:39 $

  if ~isfield(net,'version') && ~isfield(net,'gradientFcn')
    net = updatePre5p0_to_5p0(net);
  end
  if ~isfield(net,'version') && isfield(net,'gradientFcn')
    net = update5p0_to_5p1(net);
  end
  if strcmp(net.version,'5.1')
    net = update5p1_to_6p0(net);
  end
  if (ischar(net.version) && strcmp(net.version,'6')) || ...
      (isnumeric(net.version) && (net.version == 6))
    net = update6p0_to_7p0(net);
  end
  if ~strcmp(net.version,'7')
    nnerr.throw('Compatibility','Unable to update network object, unrecognized version.')
  end
  net = network(net);
  net.numInputs = net.numInputs; % TODO - Test without this line
end

function net = update6p0_to_7p0(net)
  
  %net = nn.hints(net);
  x = net;
  y = struct;
  y.version = '7';
  y.name = x.name;
  y.efficiency.cacheDelayedInputs = true;
  y.efficiency.flattenTime = true;
  y.efficiency.memoryReduction = 1;
  y.userdata = x.userdata;
  y.numInputs = x.numInputs;
  y.numLayers = x.numLayers;
  y.numOutputs = x.numOutputs;
  y.numInputDelays = x.numInputDelays;
  y.numLayerDelays = x.numLayerDelays;
  y.numFeedbackDelays = 0;
  y.numWeightElements = 0;
  y.sampleTime = 1;
  y.biasConnect = logical(net.biasConnect);
  y.inputConnect = logical(net.inputConnect);
  y.layerConnect = logical(net.layerConnect);
  y.outputConnect = logical(net.outputConnect);
  y.inputs = x.inputs;
  y.layers = x.layers;
  y.biases = x.biases;
  y.outputs = x.outputs;
  y.inputWeights = x.inputWeights;
  y.layerWeights = x.layerWeights;
  % TODO - warning
  if strcmp(x.adaptFcn,'trains')
    y.adaptFcn = 'adaptwb';
    y.adaptParam = adaptwb('defaultParam');
  else
    y.adaptFcn = x.adaptFcn;
    y.adaptParam = x.adaptParam;
  end
  y.divideFcn = x.divideFcn;
  y.divideParam = x.divideParam;
  y.divideMode = 'sample';
  y.initFcn = x.initFcn;
  % TODO - warning
  if strcmp(x.performFcn,'msereg') || strcmp(x.performFcn,'mseregec')
    y.performFcn = 'mse';
    y.performParam = mse('defaultParam');
    y.performParam.regularization = (1-x.performParam.ratio);
  elseif strcmp(x.performFcn,'msne')
    y.performFcn = 'mse';
    y.performParam = mse('defaultParam');
    y.performParam.normalization = 'standard';
  elseif strcmp(x.performFcn,'msnereg')
    y.performFcn = 'mse';
    y.performParam = mse('defaultParam');
    y.performParam.regularization = (1-x.performParam.ratio);
    y.performParam.normalization = 'standard';
  else
    y.performFcn = x.performFcn;
    y.performParam = x.performParam;
  end
  y.plotFcns = x.plotFcns;
  y.plotParams = x.plotParams;
  y.derivFcn = 'defaultderiv';
  y.trainFcn = x.trainFcn;
  y.trainParam = x.trainParam;
  y.IW = x.IW;
  y.LW = x.LW;
  y.b = x.b;
  y.revert.IW = x.IW;
  y.revert.LW = x.LW;
  y.revert.b = x.b;
  y.hint.ok = false;
  % TODO - warning
  y.gradientFcn = '';
  y.gradientParam = struct;
  net = y;
  for i=1:net.numInputs
    x = net.inputs{i};
    y = struct;
    y.name = x.name;
    y.feedbackOutput = [];
    y.processFcns = x.processFcns;
    y.processParams = x.processParams;
    y.processSettings = x.processSettings;
    for j=1:length(y.processSettings)
      settings = y.processSettings{j};
      if ~isfield(settings,'no_change'), settings.no_change = false; end
      y.processSettings{j} = settings;
    end
    y.processedRange = x.processedRange;
    if isnan(y.processedRange(1)), y.processedRange(1)=-inf; end
    if isnan(y.processedRange(2)), y.processedRange(2)=inf; end
    y.processedSize = x.processedSize;
    y.range = x.range;
    if isnan(y.range(1)), y.range(1)=-inf; end
    if isnan(y.range(2)), y.range(2)=inf; end
    y.size = x.size;
    y.userdata = x.userdata;
    y.exampleInput = x.exampleInput;
    if isempty(y.processFcns)
      y.processFcns = cell(1,0);
      y.processParams = cell(1,0);
      y.processSettings = cell(1,0);
    end
    net.inputs{i} = y;
  end
  for i=1:net.numLayers
    x = net.layers{i};
    range = repmat(feval(x.transferFcn,'activeInputRange'),x.size,1);
    y = struct;
    y.dimensions = x.dimensions;
    y.distanceFcn = x.distanceFcn;
    if isempty(y.distanceFcn)
      y.distanceParam = struct;
    else
      y.distanceParam = feval(x.distanceFcn,'defaultParam');
    end
    y.distances = x.distances;
    y.initFcn = x.initFcn;
    if isfield(x,'name')
      y.name = x.name;
    else
      y.name = 'Layer';
    end
    y.netInputFcn = x.netInputFcn;
    y.netInputParam = x.netInputParam;
    y.positions = x.positions;
    y.range = range;
    y.size = x.size;
    y.topologyFcn = x.topologyFcn;
    y.transferFcn = x.transferFcn;
    y.transferParam = x.transferParam;
    y.userdata = x.userdata;
    net.layers{i} = y;
  end
  for i=find(net.outputConnect)
    x = net.outputs{i};
    y = struct;
    y.name = x.name;
    y.feedbackInput = [];
    y.feedbackDelay = 0;
    y.feedbackMode = 'none';
    y.processFcns = x.processFcns;
    y.processParams = x.processParams;
    y.processSettings = x.processSettings;
    for j=1:length(y.processSettings)
      settings = y.processSettings{j};
      if ~isfield(settings,'no_change'), settings.no_change = false; end
      y.processSettings{j} = settings;
    end
    y.processedRange = x.processedRange;
    if isempty(y.processedRange)
      y.processedRange = x.range;
    end
    if isnan(y.processedRange(1)), y.processedRange(1)=-inf; end
    if isnan(y.processedRange(2)), y.processedRange(2)=inf; end
    y.processedSize = x.processedSize;
    y.range = x.range;
    if isnan(y.range(1)), y.range(1)=-inf; end
    if isnan(y.range(2)), y.range(2)=inf; end
    y.size = x.size;
    y.userdata = x.userdata;
    y.exampleOutput = x.exampleOutput;
    if isempty(y.processFcns)
      y.processFcns = cell(1,0);
      y.processParams = cell(1,0);
      y.processSettings = cell(1,0);
    end
    net.outputs{i} = y;
  end
  for i=1:net.numLayers
    if net.biasConnect(i)
      x = net.biases{i};
      y = struct;
      y.initFcn = x.initFcn;
      y.initFcn = x.initFcn;
      y.learn = x.learn;
      y.learnFcn = x.learnFcn;
      y.learnParam = x.learnParam;
      if isfield(x,'size')
        y.size = x.size;
      else
        y.size = net.layers{i}.size;
      end
      y.userdata = x.userdata;
      net.biases{i} = y;
    end
    for j=find(net.inputConnect(i,:))
      x = net.inputWeights{i,j};
      y = struct;
      y.delays = x.delays;
      y.initFcn = x.initFcn;
      y.initSettings = struct;
      y.learn = x.learn;
      y.learnFcn = x.learnFcn;
      y.learnParam = x.learnParam;
      y.size = x.size;
      y.userdata = x.userdata;
      y.weightFcn = x.weightFcn;
      y.weightParam = x.weightParam;
      net.inputWeights{i,j} = y;
    end
    for j=find(net.layerConnect(i,:))
      x = net.layerWeights{i,j};
      y = struct;
      y.delays = x.delays;
      y.initFcn = x.initFcn;
      y.initSettings = struct;
      y.learn = x.learn;
      y.learnFcn = x.learnFcn;
      y.learnParam = x.learnParam;
      y.size = x.size;
      y.userdata = x.userdata;
      y.weightFcn = x.weightFcn;
      y.weightParam = x.weightParam;
      net.layerWeights{i,j} = y;
    end
  end
  if isfield(net.trainParam,'mem_reduc')
    if (net.trainParam.mem_reduc ~= 1)
      net.efficiency.memoryReduction = net.trainParam.mem_reduc;
      warning('nnet:Update','NET.trainParam.mem_reduc has been replaced by NET.efficiency.memoryReduction');
    end
    net.trainParam = rmfield(net.trainParam,'mem_reduc');
  end
  net = nnupdate.read_only_values(net);
end

function net = update5p1_to_6p0(net)
  net.name = '';
  net.version = 6.0;
  net.plotFcns = {};
  net.plotParams = {};
end

function net = update5p0_to_5p1(net)
  net.version = '5.1';
  if any(net.targetConnect ~= net.outputConnect)
    disp('Notification: Property net.targetConnect is obsolete. Use net.outputConnect instead.');
  end
  net = rmfield(net,'numTargets');
  net = rmfield(net,'targetConnect');
  net = rmfield(net,'targets');
  for  i =1:net.numInputs
    oldInput = net.inputs{i};
    newInput = [];
    newInput.exampleInput = oldInput.range;
    newInput.name = 'Input';
    newInput.processFcns = {};
    newInput.processParams = {};
    newInput.processSettings = cell(1,0);
    newInput.processedRange = oldInput.range;
    newInput.processedSize = oldInput.size;
    newInput.range = oldInput.range;
    newInput.size = oldInput.size;
    newInput.userdata = oldInput.userdata;
    net.inputs{i} = newInput;
  end
  for i=find(net.numLayers)
    oldLayer = net.layers{i};
    newLayer.dimensions = oldLayer.dimensions;
    newLayer.distanceFcn = oldLayer.distanceFcn;
    newLayer.distances = oldLayer.distances;
    newLayer.initFcn = oldLayer.initFcn;
    newLayer.name = 'Layer';
    newLayer.netInputFcn = oldLayer.netInputFcn;
    newLayer.netInputParam = oldLayer.netInputParam;
    newLayer.positions = oldLayer.positions;
    newLayer.size = oldLayer.size;
    newLayer.topologyFcn = oldLayer.topologyFcn;
    newLayer.transferFcn = oldLayer.transferFcn;
    newLayer.transferParam = oldLayer.transferParam;
    newLayer.userdata = oldLayer.userdata;
    net.layers{i} = newLayer;
  end
  for i=find(net.outputConnect)
    oldOutput = net.outputs{i};
    newOutput = [];
    newOutput.exampleOutput = [];
    newOutput.name = 'Output';
    newOutput.processFcns = {};
    newOutput.processParams = {};
    newOutput.processSettings = {};
    newOutput.processedRange = [-inf inf];
    newOutput.processedSize = oldOutput.size;
    newOutput.range = [-inf inf];
    newOutput.size = oldOutput.size;
    newOutput.userdata = oldOutput.userdata;
    net.outputs{i} = newOutput;
  end
  net.divideFcn = '';
  net.divideParam = [];
  net.hint = [];
  net.hint.ok = 0;
end

function net2 = updatePre5p0_to_5p0(net1)
  net2.numInputs = net1.numInputs;
  net2.numLayers = net1.numLayers;
  net2.biasConnect = net1.biasConnect;
  net2.inputConnect = net1.inputConnect;
  net2.layerConnect = net1.layerConnect;
  net2.outputConnect = net1.outputConnect;
  net2.targetConnect = net1.targetConnect;
  net2.numOutputs = net1.numOutputs;
  net2.numTargets = net1.numTargets;
  net2.numInputDelays = net1.numInputDelays;
  net2.numLayerDelays = net1.numLayerDelays;
  net2.inputs = cell(net2.numInputs,1);
  for i=1:net1.numInputs
    net2.inputs{i}.size = net1.inputs{i}.size;
    net2.inputs{i}.range = net1.inputs{i}.range;
    net2.inputs{i}.userdata = net1.inputs{i}.userdata;
  end
  net2.layers = cell(net2.numLayers,1);
  for i=1:net1.numLayers
    net2.layers{i}.dimensions = net1.layers{i}.dimensions;
    net2.layers{i}.distanceFcn = net1.layers{i}.distanceFcn;
    net2.layers{i}.distances = net1.layers{i}.distances;
    net2.layers{i}.initFcn = net1.layers{i}.initFcn;
    net2.layers{i}.netInputFcn = net1.layers{i}.netInputFcn;
    net2.layers{i}.netInputParam = feval(net1.layers{i}.netInputFcn,'fpdefaults');
    net2.layers{i}.positions = net1.layers{i}.positions;
    net2.layers{i}.size = net1.layers{i}.size;
    net2.layers{i}.topologyFcn = net1.layers{i}.topologyFcn;
    net2.layers{i}.transferFcn = net1.layers{i}.transferFcn;
    net2.layers{i}.transferParam = feval(net1.layers{i}.transferFcn,'fpdefaults');
    net2.layers{i}.userdata = net1.layers{i}.userdata;
  end
  net2.biases = cell(net2.numLayers,1);
  for i=find(net1.biasConnect')
    net2.biases{i}.initFcn = net1.biases{i}.initFcn;
    net2.biases{i}.learn = net1.biases{i}.learn;
    net2.biases{i}.learnFcn = net1.biases{i}.learnFcn;
    net2.biases{i}.learnParam = net1.biases{i}.learnParam;
    net2.biases{i}.userdata = net1.biases{i}.userdata;
  end
  net2.inputWeights = cell(net2.numLayers,net2.numInputs);
  for i=1:net1.numLayers
    for j = find(net1.inputConnect(i,:))
      net2.inputWeights{i,j}.delays = net1.inputWeights{i,j}.delays;
      net2.inputWeights{i,j}.initFcn = net1.inputWeights{i,j}.initFcn;
      net2.inputWeights{i,j}.learn = net1.inputWeights{i,j}.learn;
      net2.inputWeights{i,j}.learnFcn = net1.inputWeights{i,j}.learnFcn;
      net2.inputWeights{i,j}.learnParam = net1.inputWeights{i,j}.learnParam;
      net2.inputWeights{i,j}.size = net1.inputWeights{i,j}.size;
      net2.inputWeights{i,j}.userdata = net1.inputWeights{i,j}.userdata;
      net2.inputWeights{i,j}.weightFcn = net1.inputWeights{i,j}.weightFcn;
      net2.inputWeights{i,j}.weightParam = feval(net1.inputWeights{i,j}.weightFcn,'fpdefaults');
    end
  end
  net2.layerWeights = cell(net2.numLayers,net2.numLayers);
  for i=1:net1.numLayers
    for j = find(net1.layerConnect(i,:))
      net2.layerWeights{i,j}.delays = net1.layerWeights{i,j}.delays;
      net2.layerWeights{i,j}.initFcn = net1.layerWeights{i,j}.initFcn;
      net2.layerWeights{i,j}.learn = net1.layerWeights{i,j}.learn;
      net2.layerWeights{i,j}.learnFcn = net1.layerWeights{i,j}.learnFcn;
      net2.layerWeights{i,j}.learnParam = net1.layerWeights{i,j}.learnParam;
      net2.layerWeights{i,j}.size = net1.layerWeights{i,j}.size;
      net2.layerWeights{i,j}.userdata = net1.layerWeights{i,j}.userdata;
      net2.layerWeights{i,j}.weightFcn = net1.layerWeights{i,j}.weightFcn;
      net2.layerWeights{i,j}.weightParam = feval(net1.layerWeights{i,j}.weightFcn,'fpdefaults');
    end
  end
  net2.outputs = cell(1,net2.numOutputs);
  for i=find(net1.outputConnect)
    net2.outputs{i}.size = net1.outputs{i}.size;
    net2.outputs{i}.userdata = net1.outputs{i}.userdata;
  end
  net2.targets = cell(1,net2.numTargets);
  for i=find(net1.targetConnect)
    net2.targets{i}.size = net1.targets{i}.size;
    net2.targets{i}.userdata = net1.targets{i}.userdata;
  end
  net2.adaptFcn = net1.adaptFcn;
  net2.adaptParam = net1.adaptParam;
  net2.initFcn = net1.initFcn;
  net2.initParam = net1.initParam;
  net2.performFcn = net1.performFcn;
  net2.performParam = net1.performParam;
  net2.trainFcn = net1.trainFcn;
  net2.trainParam = net1.trainParam;
  if isfield(net1,'gradientFcn'),
    net2.gradientFcn = net1.gradientFcn;
    net2.gradientParam = net1.gradientParam;
  elseif ~isempty(net2.trainFcn)
    net2.gradientFcn = feval(net2.trainFcn,'gdefaults',net2.numLayerDelays);
    net2.gradientParam = [];
  else
    net2.gradientFcn = '';
    net2.gradientParam = [];
  end
  net2.IW = net1.IW;
  net2.LW = net1.LW;
  net2.b = net1.b;
  net2.userdata = net1.userdata; 
  net2.hint = [];
  net2.revert = [];
end
