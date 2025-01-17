function [net,seed] = rand_net(seed,enableDynamic)
%RAND_NET Random neural network.

% Copyright 2010 The MathWorks, Inc.

% Function Choices
fcns = nntest.fcn_choices;

% Enable Dynamic
if nargin < 2, enableDynamic = true; end

% Seed
if (nargin < 1) || isempty(seed)
  seed = 100*sum(clock);
  rand('seed',seed);
else
  rand('seed',seed);
end

% Number of Inputs
numInputs = floor(rand*3)+1;

% Number of Layers
numLayers = floor(rand*4)+1;

% Input Connect
inputMode = floor(4*rand)+1;
switch inputMode
  case 1, % First layer gets all inputs
    inputConnect = false(numLayers,numInputs);
    inputConnect(1,:) = true;
  case 2, % Each input goes to one random layer
    inputConnect = false(numLayers,numInputs);
    for i=1:numInputs
      inputConnect(floor(rand*numLayers)+1,i) = true;
    end
  case 3, % Each input goes to at least one random layer
    inputConnect = false(numLayers,numInputs);
    for i=1:numInputs
      inputConnect(:,i) = rand(numLayers,1) > 0.5;
      inputConnect(floor(rand*numLayers)+1,i) = true;
    end
  case 4, % All inputs to all layers
    inputConnect = true(numLayers,numInputs);
end

% Bias Connect
biasMode = floor(3*rand)+1;
switch biasMode
  case 1, % No biases
    biasConnect = false(numLayers,1);
  case 2, % All biases
    biasConnect = true(numLayers,1);
  case 3, % Random biases
    biasConnect = rand(numLayers,1) > 0.5;
end

% Output Connect
outputMode = floor(3*rand(1,1))+1;
switch outputMode
  case 1, % Last layer is output
    outputConnect = false(1,numLayers);
    outputConnect(numLayers) = true;
  case 2, % All outputs
    outputConnect = true(1,numLayers);
  case 3, % Random outputs
    outputConnect = (rand(1,numLayers) > 0.5);
end

% Zero-Delay Layer Connect
zeroDelayMode = floor(3*rand)+1;
switch zeroDelayMode
  case 1, % Feedforward
    layerConnect = false(numLayers,numLayers);
    for i=2:numLayers
      layerConnect(i,i-1) = true;
    end
  case 2, % Random forward
    layerConnect = ((tril(ones(numLayers))-eye(numLayers)).*rand(numLayers)) > 0.7;
  case 3, % Cascade forward
    layerConnect = logical(tril(ones(numLayers))-eye(numLayers));
end

% Static/Dynamic
dynamicMode = enableDynamic;
if dynamicMode
  inputDelayMode = rand > 0.8;
  layerForwardDelayMode = rand > 0.8;
  layerRecurrentDelayMode = rand > 0.8;
  layerFeedbackDelayMode = rand > 0.8;
else
  inputDelayMode = false;
  layerForwardDelayMode = false;
  layerRecurrentDelayMode = false;
  layerFeedbackDelayMode = false;
end

% Delay Presence
delayPresence = min(1,0.5+rand);

% Input Delays
maxInputDelay = 0;
inputDelays = cell(numLayers,numInputs);
for i=1:numel(inputDelays), inputDelays{i} = 0; end
if inputDelayMode
  for i=1:find(inputConnect)
    if rand < delayPresence
      n = 1 + floor(rand*3);
      fcn = nntest.rand_choice(fcns.forwardDelayFcns);
      delays = fcn(n);
      maxInputDelay = max(maxInputDelay,max(delays));
      inputDelays{i} = delays;
    end
  end
end

% Layer Forward Delays
maxLayerDelay = 0;
layerDelays = cell(numLayers,numLayers);
for i=1:numel(layerDelays), layerDelays{i} = 0; end
if layerForwardDelayMode
  for i=1:find(layerConnect)
    if rand < delayPresence
      n = 1 + floor(rand*3);
      fcn = nntest.rand_choice(fcns.forwardDelayFcns);
      delays = fcn(n);
      maxLayerDelay = max(maxLayerDelay,max(delays));
      layerDelays{i} = delays;
    end
  end
end

% Layer Recurrent Delays
if layerRecurrentDelayMode
  for i=1:numLayers
    if rand < delayPresence
      layerConnect(i,i) = true;
      n = 1 + floor(rand*3);
      fcn = nntest.rand_choice(fcns.feedbackDelayFcns);
      delays = fcn(n);
      maxLayerDelay = max(maxLayerDelay,max(delays));
      layerDelays{i,i} = delays;
    end
  end
end

% Layer Feedback Delays
if layerFeedbackDelayMode
  feedbackConnect = triu(ones(numLayers))-eye(numLayers);
  for i=1:find(feedbackConnect)
    if rand < delayPresence
      layerConnect(i) = true;
      n = 1 + floor(rand*3);
      fcn = nntest.rand_choice(fcns.feedbackDelayFcns);
      delays = fcn(n);
      maxLayerDelay = max(maxLayerDelay,max(delays));
      layerDelays{i} = delays;
    end
  end
end

% Layer Order Mode
layerOrderMode = floor(rand*2)+1;
switch layerOrderMode
  case 1, % Natural
    layerOrder = 1:numLayers;
  case 2, % Random
    layerOrder = randperm(numLayers);
end
inputConnect = inputConnect(layerOrder,:);
inputDelays = inputDelays(layerOrder,:);
biasConnect = biasConnect(layerOrder);
layerConnect = layerConnect(layerOrder,:);
layerConnect = layerConnect(:,layerOrder);
layerDelays = layerDelays(layerOrder,:);
layerDelays = layerDelays(:,layerOrder);

% Network
net = network;
net.numInputs = numInputs;
net.numLayers = numLayers;
net.biasConnect = biasConnect;
net.inputConnect = inputConnect;
net.layerConnect = layerConnect;
net.outputConnect = outputConnect;
for i=1:numLayers
  for j=1:numInputs
    if inputConnect(i,j)
      net.inputWeights{i,j}.delays = inputDelays{i,j};
    end
  end
  for j=1:numLayers
    if layerConnect(i,j)
      net.layerWeights{i,j}.delays = layerDelays{i,j};
    end
  end
end

% Input Processing Functions
numFcns = length(fcns.inputProcessFcns);
for i=1:numInputs
  n = floor(rand*numFcns)+1;
  order = randperm(numFcns);
  net.inputs{i}.processFcns = fcns.inputProcessFcns(order(1:n));
end

% Weight Functions
for i=1:numLayers
  for j=1:numInputs
    if inputConnect(i,j)
      fcn = nntest.rand_choice(fcns.weightFcns);
      net.inputWeights{i,j}.weightFcn = fcn;
      net.inputWeights{i,j}.initFcn = 'rands';
    end
  end
  for j=1:numLayers
    if layerConnect(i,j)
      fcn = nntest.rand_choice(fcns.weightFcns);
      net.layerWeights{i,j}.weightFcn = fcn;
      net.layerWeights{i,j}.initFcn = 'rands';
    end
  end
end

% Bias Functions
for i=1:numLayers
  if biasConnect(i)
    net.biases{i}.initFcn = 'rands';
  end
end

% Net Input Functions
for i=1:numLayers
  fcn = nntest.rand_choice(fcns.netInputFcns);
  net.layers{i}.netInputFcn = fcn;
end

% Transfer Functions
for i=1:numLayers
  fcn = nntest.rand_choice(fcns.transferFcns);
  net.layers{i}.transferFcn = fcn;
end

% Layer Initialization Functions
for i=1:numLayers
  fcn = nntest.rand_choice(fcns.initLayerFcns);
  net.layers{i}.initFcn = fcn;
end

% Output Processing Functions
numFcns = length(fcns.outputProcessFcns);
for i=find(outputConnect)
  n = floor(rand*numFcns)+1;
  order = randperm(numFcns);
  net.outputs{i}.processFcns = fcns.outputProcessFcns(order(1:n));
end

% Performance Function
fcn = nntest.rand_choice(fcns.performFcns);
net.performFcn = fcn;

% Sizes
inputSizes = floor(rand(1,numInputs)*5+0.5);
layerSizes = floor(rand(1,numLayers)*5+0.5);
for i=1:numInputs
  net.inputs{i}.size = inputSizes(i);
end
for i=1:numLayers
  net.layers{i}.size = layerSizes(i);
end

% Name
net.name = ['nntest.rand_net(' num2str(seed) ')'];
for i=1:net.numInputs
  net.inputs{i}.name = ['x' num2str(i)];
end
for i=1:net.numLayers
  net.layers{i}.name = ['Layer ' num2str(i)];
end
for i=1:net.numOutputs
  ii = find(cumsum(net.outputConnect)==i,1);
  net.outputs{ii}.name = ['y' num2str(ii)];
end


