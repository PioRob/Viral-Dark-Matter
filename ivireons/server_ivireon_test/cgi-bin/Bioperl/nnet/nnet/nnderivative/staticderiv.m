function out1 = staticderiv(in1,in2,in3,in4,in5,in6,in7)
%STATICDERIV Static backpropagation derivative function.
%
%  <a href="matlab:doc staticderiv">staticderiv</a>('dperf_dwb',net,X,T,Xi,Ai,EW) takes a network, inputs X,
%  targets T, initial input states Xi, initial layer states Ai, and error
%  weights EW, and returns the gradient, the derivative of performance with
%  respect to the network's weights and biases.
%
%  <a href="matlab:doc staticderiv">staticderiv</a>('de_dwb',net,X,T,Xi,Ai,EW) returns the Jacobian, the
%  derivative of each error with respect to the network's weights and biases.
%
%  <a href="matlab:doc staticderiv">staticderiv</a> calculates static derivatives, it ignores any connections
%  through non-zero delays.  For dynamic networks with delays, <a href="matlab:doc bttderiv">bttderiv</a>
%  or <a href="matlab:doc fpderiv">fpderiv</a> are recommended instead.
%
%  Here a feedforward network is trained and derivatives calculated.
%
%    [x,t] = <a href="matlab:doc simplefit_dataset">simplefit_dataset</a>;
%    net = <a href="matlab:doc feedforwardnet">feedforwardnet</a>(10);
%    net = <a href="matlab:doc train">train</a>(net,x,t);
%    y = net(x);
%    perf = <a href="matlab:doc perform">perform</a>(net,t,y)
%    dwb = <a href="matlab:doc staticderiv">staticderiv</a>('dperf_dwb',net,x,t)
%
%  See also DEFAULTDERIV, BTTDERIV, FPDERIV.

% Copyright 2010 The MathWorks, Inc.

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Propagation Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  if (nargin < 1), nnerr.throw('Not enough input arguments.'); end
  if ischar(in1)
    switch in1
      case 'info',
        out1 = INFO;
      case 'dperf_dwb'
        if nargin < 4, nnerr.throw('Not enough input arguments.'); end
        if nargin < 5, in5 = {}; end
        if nargin < 6, in6 = {}; end
        if nargin < 7, in7 = {1}; end
        [net,err] = nntype.network('format',in2,'Network');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [x,err] = nntype.data('format',in3,'Input data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [t,err] = nntype.data('format',in4,'Target data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [xi,err] = nntype.data('format',in5,'Input states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ai,err] = nntype.data('format',in6,'Layer states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ew,err] = nntype.data('format',in7,'Error weights');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [out1,err] = dperf_dwb(net,x,t,xi,ai,ew);
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        
      case 'de_dwb'
        if nargin < 4, nnerr.throw('Not enough input arguments.'); end
        if nargin < 5, in5 = {}; end
        if nargin < 6, in6 = {}; end
        if nargin < 7, in7 = {1}; end
        [net,err] = nntype.network('format',in2,'Network');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [x,err] = nntype.data('format',in3,'Input data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [t,err] = nntype.data('format',in4,'Target data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [xi,err] = nntype.data('format',in5,'Input states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ai,err] = nntype.data('format',in6,'Layer states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ew,err] = nntype.data('format',in7,'Error weights');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [out1,err] = de_dwb(net,x,t,xi,ai,ew);
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        
      case 'gradient'
        if nargin < 4, in4 = nn.subfcns(in2); end
        out1 = calc_gradient(in2,in3,in4);
      case 'jacobian'
        if nargin < 4, in4 = nn.subfcns(in2); end
        out1 = calc_jacobian(in2,in3,in4);
        
      % Testing
      
      case 'dperf_dwb_jac'
        if nargin < 4, nnerr.throw('Not enough input arguments.'); end
        if nargin < 5, in5 = {}; end
        if nargin < 6, in6 = {}; end
        if nargin < 7, in7 = {1}; end
        [net,err] = nntype.network('format',in2,'Network');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [x,err] = nntype.data('format',in3,'Input data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [t,err] = nntype.data('format',in4,'Target data');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [xi,err] = nntype.data('format',in5,'Input states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ai,err] = nntype.data('format',in6,'Layer states');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [ew,err] = nntype.data('format',in7,'Error weights');
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        [out1,err] = dperf_dwb_jac(net,x,t,xi,ai,ew);
        if ~isempty(err), throwAsCaller(MException(nnerr.tag('Arguments',2),err)); end
        
      % NNET 6 Compatibility
      case 'check_param'
        out1 = '';
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me, 
          nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
  end
end

function [dwb,err] = dperf_dwb(net,x,t,xi,ai,ew)
  [x,xi,ai,t,ew,Q,TS,err] = nnsim.prep(net,x,xi,ai,t,ew);
  if ~isempty(err), dwb=[]; return; end
  if (Q == 0) || (TS == 0)
    dwb = zeros(net.numWeightElements,1);
    return
  end
  fcns = nn.subfcns(net);
  data.P = nnproc.pre_inputs(fcns,[xi x]);
  [data.P,t] = nntraining.fix_nan_inputs(net,data.P,ai,t,Q,TS);
  if net.efficiency.cacheDelayedInputs && (net.numInputDelays > 0);
    data.Pd = nnsim.pd(net,data.P);
    data.P = [];
  else
    data.Pd = [];
  end
  data.Ai = ai;
  data.T = t;
  data.EW = ew;
  data.Q = Q;
  data.TS = TS;
  [~,data] = nntraining.perf_all(net,data,fcns);
  dwb = calc_gradient(net,data,fcns);
end

function [dwb,err] = dperf_dwb_jac(net,x,t,xi,ai,ew)
  [d1,err] = de_dwb(net,x,t,xi,ai,ew);
  if ~isempty(err), dwb = []; return; end
  y = nnsim.y(net,x,xi,ai);
  perf = feval(net.performFcn,net,t,y,ew,net.performParam);
  d2 = feval(net.performFcn,'dperf_dy',net,t,y,ew,perf,net.performParam);
  d2 = cell2mat(d2);
  d2 = d2(:);
  dwb = (d1*d2);
end

function [dwb,err] = de_dwb(net,x,t,xi,ai,ew)
  [x,xi,ai,t,ew,Q,TS,err] = nnsim.prep(net,x,xi,ai,t,ew);
  if ~isempty(err), dwb=[]; return; end
  if (Q == 0) || (TS == 0)
    dwb = zeros(net.numWeightElements,0);
    return
  end
  fcns = nn.subfcns(net);
  data.P = nnproc.pre_inputs(fcns,[xi x]);
  [data.P,t] = nntraining.fix_nan_inputs(net,data.P,ai,t,Q,TS);
  if net.efficiency.cacheDelayedInputs && (net.numInputDelays > 0);
    data.Pd = nnsim.pd(net,data.P);
    data.P = [];
  else
    data.Pd = [];
  end
  data.Ai = ai;
  data.T = t;
  data.EW = ew;
  data.Q = Q;
  data.TS = TS;
  [~,data] = nntraining.perf_all(net,data,fcns);
  dwb = calc_jacobian(net,data,fcns);
end
  
function sf = subfunctions
  sf.calc_gradient = @calc_gradient;
  sf.calc_jacobian = @calc_jacobian;
end

function v = fcnversion
  v = 7;
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
  info = nnfcnDerivative(mfilename,'Static backpropagation',...
    fcnversion,subfunctions);
end

function gWB = calc_gradient(net,data,fcns)
  if any([data.Q data.TS net.numOutputs net.numWeightElements] == 0)
    gWB = zeros(net.numWeightElements,1);
    return
  end
  gE = cell(net.numLayers,data.TS);
  fcn = fcns.perform;
  gE(net.outputConnect,:) = fcn.dperf_de(...
    net,data.T,data.Y,data.EW,data.perf,fcn.param);
  Alstart = size(data.Ac,2)-data.TS+1;
  Al = data.Ac(:,Alstart:end);
  gE = nnproc.dperf(net,Al,gE,data.Q,fcns);
  [gB,gIW,gLW] = nnprop.grad(net,data.P,data.Pd,data.Zb,data.Zi,...
    data.Zl,data.N,data.Ac,gE,data.Q,data.TS,fcns);
  gWB = formwb(net,gB,gIW,gLW);
end

function jWB = calc_jacobian(net,data,fcns)
  jWB = nnprop.jac_s(net,data.P,data.Pd,data.Zb,data.Zi,data.Zl,...
    data.N,data.Ac,data.T,data.EW,data.Q,data.TS,fcns);
end
