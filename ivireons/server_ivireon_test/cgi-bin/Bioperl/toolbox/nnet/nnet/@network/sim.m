function [Y,Xf,Af,E,perf]=sim(net,varargin)
%SIM Simulate a neural network.
%
%  SIM(NET,X) takes a network NET and inputs X and returns the outputs
%  Y generated by the network.  This syntax is equivalent to NET(X).
%
%  [Y,Xf,Af] = <a href="matlab:doc sim">sim</a>(NET,X,Xi,Ai) takes a dynamic network NET, inputs X,
%  and initial input and layer delays Xi and Ai.  It returns the outputs Y
%  and final input and layer delays states Xf and Af.
%
%  <a href="matlab:doc sim">sim</a> arguments can have two formats: matrices, for static
%  problems and networks with single inputs and outputs, and cell arrays
%  for multiple timesteps and networks with multiple inputs and outputs.
%
%  The matrix format is as follows:
%    X  - RxQ matrix
%    Y  - UxQ matrix.
%  Where:
%    Q  = number of samples
%    R  = number of elements in the network's input
%    U  = number of elements in the network's output
%
%  The cell array format is most general:
%    X  - NixTS cell array, each element X{i,ts} is an RixQ matrix.
%    Xi - NixID cell array, each element Xi{i,k} is an RixQ matrix.
%    Ai - NlxLD cell array, each element Ai{i,k} is an SixQ matrix.
%    Y  - NOxTS cell array, each element Y{i,ts} is a UixQ matrix.
%    Xf - NixID cell array, each element Xf{i,k} is an RixQ matrix.
%    Af - NlxLD cell array, each element Af{i,k} is an SixQ matrix.
%  Where:
%    TS = number of time steps
%    Ni = NET.<a href="matlab:doc nnproperty.net_numInputs">numInputs</a>
%    Nl = NET.<a href="matlab:doc nnproperty.net_numLayers">numLayers</a>, 
%    No = NET.<a href="matlab:doc nnproperty.net_numOutputs">numOutputs</a>
%    ID = NET.<a href="matlab:doc nnproperty.net_numInputDelays">numInputDelays</a>
%    LD = NET.<a href="matlab:doc nnproperty.net_numLayerDelays">numLayerDelays</a>
%    Ri = NET.<a href="matlab:doc nnproperty.net_inputs">inputs</a>{i}.<a href="matlab:doc nnproperty.input_size">size</a>
%    Si = NET.<a href="matlab:doc nnproperty.net_layers">layers</a>{i}.<a href="matlab:doc nnproperty.layer_size">size</a>
%    Ui = NET.<a href="matlab:doc nnproperty.net_outputs">outputs</a>{i}.<a href="matlab:doc nnproperty.output_size">size</a>
%
%  The columns of Xi, Xf, Ai, and Af are ordered from oldest delay
%  condition to most recent:
%    Xi{i,k} = input i at time ts=k-ID.
%    Xf{i,k} = input i at time ts=TS+k-ID.
%    Ai{i,k} = layer output i at time ts=k-LD.
%    Af{i,k} = layer output i at time ts=TS+k-LD.
%
%  [Y,Pf,Af] = SIM(net,{Q TS},Pi,Ai) is used for networks
%  which do not have an input, such as Hopfield networks
%  when cell array notation is used.
%
%  Here a static feedforward network is created, trained on some data, then
%  simulated using SIM and network notation.
%
%    [x,t] = <a href="matlab:doc simplefit_dataset">simplefit_dataset</a>;
%    net = <a href="matlab:doc feedforwardnet">feedforwardnet</a>(10);
%    net = <a href="matlab:doc train">train</a>(net,x,t);
%    y1 = <a href="matlab:doc sim">sim</a>(net,x)
%    y2 = net(x)
%
%  Here a dynamic NARX network is created, trained, and simulated on
%  time series data.
%
%   [X,T] = <a href="matlab:doc simplenarx_dataset">simplenarx_dataset</a>;
%   net = <a href="matlab:doc narxnet">narxnet</a>(1:2,1:2,10);
%   <a href="matlab:doc view">view</a>(net)
%   [Xs,Xi,Ai,Ts] = <a href="matlab:doc preparets">preparets</a>(net,X,{},T);
%   net = <a href="matlab:doc train">train</a>(net,Xs,Ts,Xi,Ai);
%   Y1 = <a href="matlab:doc sim">sim</a>(net,Xs,Xi,Ai)
%   Y2 = net(Xs,Xi,Ai)
%
%  See also INIT, REVERT, ADAPT, TRAIN

% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.8.4.10.2.1 $ $Date: 2010/07/14 23:38:48 $

% CHECK AND FORMAT ARGUMENTS
% --------------------------

nnassert.minargs(nargin,1);
nntype.network('assert',net,'NET');
[X,Xi,Ai,T,EW] = nnmisc.defaults(varargin,{},{},{},{},{1});

% Convert explicit timesteps to inputs
xMatrix = ~iscell(X);
if (net.numInputs == 0)
  if xMatrix && isscalar(X)
    % Q
    X = {zeros(0,X)};
  elseif ~xMatrix && isscalar(X) && isscalar(X{1})
    % {TS}
    X = cell(1,X{1});
  elseif xMatrix && (ndims(X)==2) && all(size(X)==[1 2])
    % [Q TS]
    Q = X(1);
    TS = X(2);
    X = cell(1,TS);
    for i=1:TS,X{i} = zeros(1,Q); end
    xMatrix = false;
  elseif ~xMatrix && (ndims(X)==2) && all(size(X)==[1 2]) ...
      && isscalar(X{1}) && isscalar(X{2})
    % {Q TS}
    Q = X{1}; TS = X{2};
    X = cell(1,TS);
    for i=1:TS,X{i} = zeros(1,Q); end
    xMatrix = false;
  end
end
X = nntype.data('format',X,'Inputs');

tMatrix = ~iscell(T);
xiMatrix = ~iscell(Xi) || isempty(Xi);
aiMatrix = ~iscell(Ai) || isempty(X);
if isempty(Xi), Xi = {}; end
if isempty(Ai), Ai = {}; end
if ~isempty(T), T = nntype.data('format',T,'Targets'); end
if ~isempty(Xi), Xi = nntype.data('format',Xi,'Input delay states'); end
if ~isempty(Ai), Ai = nntype.data('format',Ai,'Layer delay states'); end

[X,Xi,Ai,T,EW,Q,TS,err] = nnsim.prep(net,X,Xi,Ai,T,EW);
if ~isempty(err), nnerr.throw(err), end

% Hints
net = nn.hints(net);
if net.hint.zeroDelay, nnerr.throw('Network contains a zero-delay loop.'); end

net = struct(net);

% SIMULATE NETWORK
% ----------------

[Y,Xf,Af] = nnsim.y(net,X,Xi,Ai,Q);

% Optional arguments
if nargout >= 4, E = gsubtract(T,Y); end
if nargout >= 5
  perf = feval(net.performFcn,net,T,Y,EW,net.performParam);
end

% FORMAT OUTPUT ARGUMENTS
% -----------------------

if (xMatrix)
  if (net.numOutputs == 0)
    Y = zeros(0,Q);
  else
    Y = cell2mat(Y);
  end
end
if (xiMatrix), Xf = cell2mat(Xf); end
if (aiMatrix), Af = cell2mat(Af); end
if (nargout>4) && (tMatrix)
  if (net.numOutputs == 0)
    E = zeros(0,Q);
  else
    E = cell2mat(E);
  end
end
