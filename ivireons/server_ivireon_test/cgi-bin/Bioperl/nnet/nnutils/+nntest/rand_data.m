function [x,t,seed] = rand_data(net,seed)
%RAND_DATA

% Copyright 2010 The MathWorks, Inc.

if nargin < 1, nnerr.throw('Not enough input arguments.'); end

% Seed & Network
if (nargin == 1)
  seed = net;
  net = nntest.rand_net(seed);
end
rand('seed',seed);

% Sizes
inputSizes = zeros(1,net.numInputs);
for i=1:net.numInputs, inputSizes(i) = net.inputs{i}.size; end
layerSizes = zeros(1,net.numLayers);
for i=1:net.numLayers, layerSizes(i) = net.layers{i}.size; end
outputSizes = layerSizes(net.outputConnect);

% Samples
Q = floor(rand*4);

% Timesteps
TS = 1 + floor(rand*3);

% Inputs
TSi = TS + max([net.numInputDelays,net.numLayerDelays,net.numFeedbackDelays]);
x = nndata(inputSizes,Q,TSi);
scale = gmultiply(nndata(inputSizes),10);
x = gmultiply(x,scale);

% Targets
t = nndata(outputSizes,Q,TSi);
scale = gmultiply(nndata(outputSizes),10);
t = gmultiply(t,scale);

% Special Inputs
N = sum(inputSizes);
for i=1:N
  if (rand > 0.98)
    % Constant input
    x = nnfast.setelements(x,i,nndata(1,Q,TSi,rand));
  elseif (rand > 0.98)
    % Partially NaN input
    xi = nnfast.getelements(x,i);
    for j=1:TSi, xi{j}(1,rand(1,Q)>0.9) = NaN; end
    x = nnfast.setelements(x,i,xi);
  elseif (rand > 0.98)
    % Constant NaN input
    x = nnfast.setelements(x,i,nndata(1,Q,TSi,NaN));
  elseif (rand > 0.98) && (i > 1)
    % Dependent input
    xi = nnfast.getelements(x,1);
    for j=2:(i-1)
      xi = gadd(xi,getelements(x,j));
    end
    x = nnfast.setelements(x,i,xi);
  end
end
  
% Special Targets
N = sum(outputSizes);
for i=1:N
  if (rand > 0.98)
    % Constant
    t = nnfast.setelements(t,i,nndata(1,Q,TSi,rand));
  elseif (rand > 0.98)
    % Partially NaN
    ti = nnfast.getelements(t,i);
    for j=1:TSi, ti{j}(1,rand(1,Q)>0.9) = NaN; end
    t = nnfast.setelements(t,i,ti);
  elseif (rand > 0.98)
    % Constant NaN
    t = nnfast.setelements(t,i,nndata(1,Q,TSi,NaN));
  elseif (rand > 0.98) && (i > 1)
    % Dependent
    ti = nnfast.getelements(t,1);
    for j=2:(i-1)
      ti = gadd(ti,nnfast.getelements(t,j));
    end
    t = nnfast.setelements(t,i,ti);
  end
end
