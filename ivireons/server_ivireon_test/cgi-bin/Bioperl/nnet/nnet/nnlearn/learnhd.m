function [out1,out2] = learnhd(varargin)
%LEARNHD Hebb with decay weight learning rule.
%
%  <a href="matlab:doc learnhd">learnhd</a> is the Hebb weight learning function.
%
%  <a href="matlab:doc learnhd">learnhd</a>(W,P,Z,N,A,T,E,gW,gA,D,LP,LS) takes several inputs,
%    W  - SxR weight matrix (or Sx1 bias vector).
%    P  - RxQ input vectors (or ones(1,Q)).
%    Z  - SxQ weighted input vectors.
%    N  - SxQ net input vectors.
%    A  - SxQ output vectors.
%    T  - SxQ layer target vectors.
%    E  - SxQ layer error vectors.
%    gW - SxR gradient with respect to performance.
%    gA - SxQ output gradient with respect to performance.
%    D  - SxS neuron distances.
%    LP - Learning parameters, none, LP = [].
%    LS - Learning state, initially should be = [].
%  and returns,
%    dW - SxR weight (or bias) change matrix.
%    LS - New learning state.
%
%  Learning occurs according to LEARNHD's learning parameters
%  shown here with default values.
%    LP.dr - 0.01 - Decay rate.
%    LP.lr - 0.1  - Learning rate
%
%  <a href="matlab:doc learnhd">learnhd</a>(CODE) returns useful information for each CODE string:
%    'pnames'    - Returns names of learning parameters.
%    'pdefaults' - Returns default learning parameters.
%    'needg'     - Returns 1 if this function uses gW or gA.
%
%  Here we define a random input P, output A, and weights W
%  for a layer with a 2-element input and 3 neurons.  We also
%  define the decay and learning rates.
%
%    p = rand(2,1);
%    a = rand(3,1);
%    w = rand(3,2);
%    lp.dr = 0.05;
%    lp.lr = 0.5;
%
%  <a href="matlab:doc learnhd">learnhd</a> only needs these values to calculate a weight change.
%
%    dW = <a href="matlab:doc learnhd">learnhd</a>(w,p,[],[],a,[],[],[],[],[],lp,[])
%
%  See also LEARNH, ADAPT, TRAIN.

% Mark Beale, 1-31-92
% Revised 11-31-97, MB
% Copyright 1992-2010 The MathWorks, Inc.
% $Revision: 1.1.6.8 $  $Date: 2010/04/24 18:09:21 $

%% =======================================================
%  BOILERPLATE_START
%  This code is the same for all Learning Functions.

  persistent INFO;
  if isempty(INFO), INFO = get_info; end
  if (nargin < 1), nnerr.throw('Not enough arguments.'); end
  in1 = varargin{1};
  if ischar(in1)
    switch in1
      case 'info'
        out1 = INFO;
      case 'check_param'
        out1 = check_param(varargin{2});
      otherwise,
        try
          out1 = eval(['INFO.' in1]);
        catch me
          nnerr.throw(['Unrecognized first argument: ''' in1 ''''])
        end
    end
  else
    [out1,out2] = apply(varargin{:});
  end
end

function sf = subfunctions
  sf.apply = @apply;
end

function v = fcnversion
  v = 7;
end

%  BOILERPLATE_END
%% =======================================================

function info = get_info
  info = nnfcnLearning(mfilename,'Hebb with Decay',...
    fcnversion,subfunctions,false,true,true,false, ...
    [ ...
    nnetParamInfo('lr','Learning Rate','nntype.pos_scalar',0.1,...
    'Relative speed of learning.') ...
    nnetParamInfo('dr','Decay Rate','nntype.real_0_to_1',0.01,...
    'Percentage of weight decay per iteration.') ...
    ]);
end

function err = check_param(param)
  err = '';
end

function [dw,ls] = apply(w,p,z,n,a,t,e,gW,gA,d,lp,ls)
  dw = lp.lr*a*p' - lp.dr*w;
end
